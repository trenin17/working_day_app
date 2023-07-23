import Foundation
import EFNetwork

enum GlobalConstants {
    static let baseURL = "http://vm.trenin17.online:8080"
}

struct VacationNotificationDTO: Decodable {
        let id: String
        let type: String
        let isRead: Bool
        let sender: ListEmployeeDTO?
        let text: String
        let actionId: String
        let created: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case isRead = "is_read"
        case sender = "sender"
        case text = "text"
        case actionId = "action_id"
        case created = "created"
    }
}

struct NotificationResponse: Decodable {
    let notifications: [VacationNotificationDTO]
}

protocol AbsenseVerdictInvoker {
    func acceptVacationRequest(actionId: String, notificationId: String)
    func declineVacationRequest(actionId: String, notificationId: String)
}

struct AbscenceVerdictPayload: Encodable {
    let actionId: String
    let notificationId: String
    let approve: Bool
    
    private enum CodingKeys: String, CodingKey {
        case actionId = "action_id"
        case notificationId = "notification_id"
        case approve
    }
}

class NotificationsStore: ObservableObject, AbsenseVerdictInvoker {
    
    private enum Constant {
        private static let baseURL = GlobalConstants.baseURL
        static let notificationURL = baseURL + "/v1/notifications"
        static let abscenceVerdict = baseURL + "/v1/abscence/verdict"
    }
    
    enum ViewState {
        case initial
        case loading
        case loaded([NotificationModel])
        case error(description: String)
    }
    
    @Published var state: ViewState
    @Published var avatarURL: String?
    
    let networkManager: EFNetworkManager
    
    init(
        networkManager: EFNetworkManager
    ) {
        self.networkManager = networkManager
        self.state = .initial
    }
    
    init(
        mock_notifications: [NotificationModel]
    ) {
        self.networkManager = .default
        self.state = .loaded(mock_notifications)
    }
    
    func fetchIfNeeded() {
        switch state {
        case .initial, .error:
            fetchState()
        case .loading, .loaded:
            return
        }
    }
    
    private func fetchState() {
        Task {
            await _fetchState()
        }
    }
    
    @MainActor
    private func _fetchState() async {
        self.state = .loading
        let newState = await networkManager
            .postAsync(url: Constant.notificationURL)
            .handle(statusCode: 200, of: NotificationResponse.self) { response -> ViewState in
                let converter = NotificationConverter(
                    abscenceVerdictInvoker: self
                )
                let converted = response.notifications.map {
                    converter.convert(dto: $0)
                }
                return .loaded(converted)
            }
            .fallback {
                return .error(description: "Что-то пошло не так")
            }
        self.state = newState
    }
    
    func acceptVacationRequest(actionId: String, notificationId: String) {
        Task {
            await vacationRequestVerdictRequest(actionId: actionId, notificationId: notificationId, verdict: true)
        }
    }
    
    func declineVacationRequest(actionId: String, notificationId: String) {
        Task {
            await vacationRequestVerdictRequest(actionId: actionId, notificationId: notificationId, verdict: false)
        }
    }
    
    private func vacationRequestVerdictRequest(actionId: String, notificationId: String, verdict: Bool) async {
        let payload = AbscenceVerdictPayload(
            actionId: actionId,
            notificationId: notificationId,
            approve: true
        )
        await networkManager
            .postAsync(
                url: Constant.abscenceVerdict,
                body: payload
            )
            .handleCode(200) {
                self.fetchState()
            }
            .fallback {
                return
            }
    }

    
}

struct NotificationConverter {
    
    let abscenceVerdictInvoker: AbsenseVerdictInvoker
    
    func convert(dto: VacationNotificationDTO) -> NotificationModel {
        return NotificationModel(
            id: dto.id,
            shouldShowBadge: !dto.isRead,
            avatarURL: dto.sender?.photoLink,
            senderName: dto.sender.flatMap { "\($0.surname) \($0.name)" },
            text: dto.text,
            buttons: buttons(
                id: dto.id,
                actionId: dto.actionId,
                for: convertType(dtoType: dto.type)
            )
        )
    }
    
    private func convertType(dtoType: String) -> NotificationModel.NotificationType {
        switch dtoType {
        case "vacation_request":
            return .vacationRequest
        case "vacation_approved":
            return .vacationApproved
        default:
            return .unknown
        }
    }
    
    private func buttons(
        id: String,
        actionId: String,
        for type: NotificationModel.NotificationType
    ) -> [VacationNotificationView.NotificationButton] {
        switch type {
        case .vacationRequest:
            return [
                .init(text: "Принять", color: .green, action: .tap({
                    abscenceVerdictInvoker.acceptVacationRequest(actionId: actionId, notificationId: id)
                })),
                .init(text: "Отклонить", color: .red, action: .tap({
                    abscenceVerdictInvoker.declineVacationRequest(actionId: actionId, notificationId: id)
                })),
            ]
        case .vacationApproved:
            return [
                //.init(text: "Документ", color: .green, action: .tap({}))
            ]
        case .unknown:
            return []
        }
    }

}
