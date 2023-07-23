import Foundation

public enum VacationServer: String {
    case production
    case mockServer
    case mockLocal

    public init(value: String?) {
        self = VacationServer(rawValue: value ?? "") ?? .production
    }

    public static var current: VacationServer = .production
}
