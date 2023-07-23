import Foundation
import EFNetwork

struct ListEmployeeDTO: Decodable {
    let id: String
    let name: String
    let surname: String
    let patronymic: String?
    let photoLink: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case surname
        case patronymic
        case photoLink = "photo_link"
    }
}

struct EmployeesResponse: Decodable {
    let employees: [ListEmployeeDTO]
}

class EmployeeListStore: ObservableObject {
    
    enum State {
        case loaded(viewModel: EmployeeList)
        case loading
        case error
    }
    @Published var state: State
    let networkManager: EFNetworkManager
    
    private var employees: [EmployeeListItem]
    
    var filter: String {
        didSet {
            rebuildListIfNeeded()
        }
    }
    
    init(
        mock_employees: [EmployeeListItem]
    ) {
        self.networkManager = EFNetworkManager.default
        self.employees = mock_employees
        self.state = .loaded(viewModel: EmployeeList(employees: employees))
        self.filter = ""
    }
    
    init(networkManager: EFNetworkManager) {
        self.networkManager = networkManager
        self.state = .loading
        self.employees = []
        self.filter = ""
        updateStateUnsafe()
    }
    
    private func rebuildListIfNeeded() {
        switch self.state {
        case .loaded:
            let filteredEmployees = filteredEmployees(for: self.employees)
            self.state = .loaded(viewModel: .init(employees: filteredEmployees))
        case .error, .loading:
            return
        }
    }
    
    private func filteredEmployees(for employees: [EmployeeListItem]) -> [EmployeeListItem] {
        guard filter != "" else { return employees }
        
        return employees.filter {
            $0.name.uppercased().contains(filter.uppercased())
        }
    }
    
    private func fetchEmployees() async -> State {
        return await networkManager
            .getAsync(url: "\(GlobalConstants.baseURL)/v1/employees")
            .handle(statusCode: 200, of: EmployeesResponse.self) { [weak self] responseList in
                guard let self else { return .error }
                let items = responseList.employees.map { self.mapEmployeeItem(from: $0) }
                return .loaded(viewModel: EmployeeList(employees: items))
            }
            .fallback {
                return .error
            }
    }
    
    public func refresh() {
        switch self.state {
        case .loaded, .error:
            self.state = .loading
            updateStateUnsafe()
        case .loading:
            return
        }
    }
    
    private func updateStateUnsafe() {
        Task {
            let state = await fetchEmployees()
            await MainActor.run {
                self.state = state
            }
        }
    }
    
    private func mapEmployeeItem(from dto: ListEmployeeDTO) -> EmployeeListItem {
        var displayName = "\(dto.surname) \(dto.name)"
        if let patronymic = dto.patronymic {
            displayName.append(" \(patronymic)")
        }
        return EmployeeListItem(
            id: dto.id,
            avatarURL: dto.photoLink,
            name: displayName,
            badge: nil
        )
    }
}
