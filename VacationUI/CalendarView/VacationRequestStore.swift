import Foundation
import EFNetwork

struct VacationRequestDTO: Encodable {
    let startDate: String
    let endDate: String
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case type
    }
}

class VacationRequestStore: ObservableObject {
    
    private enum Constnats {
        private static let baseURL = GlobalConstants.baseURL
        static let vacationRequest = baseURL + "/v1/abscence/request"
    }
    enum ViewState {
        case editing
        case sendingRequest
        case dismissSuccess
        case dismissFailure
    }
    
    @Published var viewState: ViewState = .editing
    
    let calendarStore: ProfileCalendarStore
    let networkManager: EFNetworkManager
    
    init(
        networkManager: EFNetworkManager,
        calendarStore: ProfileCalendarStore
    ) {
        self.networkManager = networkManager
        self.calendarStore = calendarStore
    }
    
    func sendNetworkReqeust(
        text: String,
        startDate: Date,
        endDate: Date
    ) {
        Task {
            await _sendNetworkReqeust(text: text, startDate: startDate, endDate: endDate)
        }
    }
    
    @MainActor
    private func _sendNetworkReqeust(
        text: String,
        startDate: Date,
        endDate: Date
    ) async {
        let body = VacationRequestDTO(
            startDate: formatter.string(from: startDate),
            endDate: formatter.string(from: endDate),
            type: "vacation"
        )
        await networkManager
            .postAsync(url: Constnats.vacationRequest, body: body)
            .handleCode(200) {
                self.viewState = .dismissSuccess
            }
            .fallback {
                self.viewState = .dismissFailure
            }
    }
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = VacationUserActionsDateFormatterProvider.encodeFormat
        return formatter
    }()
}
