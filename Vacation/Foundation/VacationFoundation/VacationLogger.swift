import Foundation

public final class VacationLogger {
    
    // MARK: - Init
    public static let shared = VacationLogger(
    )
    
    private init(shouldLog: Bool = true) {
        self.shouldLog = shouldLog
    }
    
    // MARK: - Public methods
    
    public func info(_ message: String, context: Any? = nil) {
        if shouldLog { print("INFO: \(message), \(context.debugDescription)") }
    }
    
    public func debug(_ message: String, context: Any? = nil) {
        if shouldLog { print("DEBUG: \(message), \(context.debugDescription)") }
    }
    
    public func warning(_ message: String, context: Any? = nil) {
        if shouldLog { print("WARNING: \(message), \(context.debugDescription)") }
    }
    
    public func error(_ message: String, context: Any? = nil) {
        if shouldLog { print("ERROR: \(message), \(context.debugDescription)") }
    }
    
    // MARK: - Private properties
    
    /// Should be set only on AppStart, while parsing the root.plist config
    private var shouldLog: Bool
    
    public func configureFrom(userdefaults: UserDefaults) {
        let value = userdefaults.value(forKey: "Vacation.LogsEnabled") as? Bool
        self.shouldLog = value ?? false
    }
}
