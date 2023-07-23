import Foundation
import EFNetwork

struct VacationUserActionsDateFormatterProvider {
    static let encodeFormat: String = "yyyy-MM-dd'T'HH:mm:ss"
    static let decodeFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
}

struct ActionsRequest: Encodable {
    
    private enum Constant {
        static let secondInDay: TimeInterval = 24 * 3600
    }
    
    let from: String
    let to: String
    let employeeId: String?
    
    private enum CodingKeys: String, CodingKey {
        case from
        case to
        case employeeId = "employee_id"
    }
    
    static func `default`(with id: String? = nil) -> ActionsRequest {
        let start = Date.now - Constant.secondInDay * 31
        let end = Date.now + Constant.secondInDay * 31
        
        let formatter = DateFormatter()
        formatter.dateFormat = VacationUserActionsDateFormatterProvider.encodeFormat
        
        return ActionsRequest(
            from: formatter.string(from: start),
            to: formatter.string(from: end),
            employeeId: id
        )
        
    }
}

struct ActionsResponseDTO: Decodable {
    
    struct ActionDTO: Decodable {
        let id: String
        let type: String
        let startDate: String
        let endDate: String
        
        private enum CodingKeys: String, CodingKey {
            case id
            case type
            case startDate = "start_date"
            case endDate = "end_date"
        }
    }
    
    let actions: [ActionDTO]
}

class ProfileCalendarStore: ObservableObject {
    
    @Published var state: ViewState = .initial
    
    let networkManager: EFNetworkManager
    let userId: String?
    
    init(
        networkManager: EFNetworkManager,
        userId: String? = nil
    ) {
        self.networkManager = networkManager
        self.userId = userId
    }
    
    func fetchStateIfNeeded() {
        switch state {
        case .error, .initial:
            fetchState()
        case .loaded, .loading:
            return
        }
    }
    
    func fetchState() {
        Task {
            await _fetchState()
        }
    }
    
    @MainActor
    private func _fetchState() async {
        self.state = .loading
        await networkManager
            .postAsync(url: Constant.actionsURL, body: ActionsRequest.default(with: userId))
            .handle(statusCode: 200, of: ActionsResponseDTO.self) { response in
                let userActions = UserActionsConverter().convert(dto: response)
                self.state = .loaded(userActions)
                self.objectWillChange.send()
            }
            .fallback {
                self.state = .error
            }
        
    }
    
    private func sendVacationRequest() {
        
    }
}

class UserActionsConverter {
    func convert(dto: ActionsResponseDTO) -> VacationUserActions {
        let actions = dto.actions.compactMap { range -> VacationRange? in
            guard
                let start = formatter.date(from: range.startDate),
                let end = formatter.date(from: range.endDate)
            else {
                return nil
            }
            let type: VacationRange.VacationType = {
                switch range.type {
                case "vacation":
                    return .vacation
                case "attendance":
                    return .attendance
                default:
                    return .unknown
                }
            }()
            return VacationRange(
                start: start,
                end: end,
                type: type
            )
        }
        return .init(actions: actions)
    }
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = VacationUserActionsDateFormatterProvider.decodeFormat
        return formatter
    }()
}

extension ProfileCalendarStore {
    private enum Constant {
        private static let baseURL = GlobalConstants.baseURL
        static let actionsURL = baseURL + "/v1/actions"
    }
    
    enum ViewState {
        case initial
        case loading
        case loaded(VacationUserActions)
        case error
    }
    
}
    
struct VacationRange {
    
    enum VacationType {
        case illness
        case abscence
        case vacation
        case attendance
        case unknown
    }
    
    let start: Date
    let end: Date
    let type: VacationType
}

struct VacationUserActions {
    let actions: [VacationRange]
}

