import Foundation

public class PedingCompletionsQueue<CompletionValue> {
    public typealias Completion = (CompletionValue) -> Void
    
    private var queue: [Completion] = []
    private let lock = NSLock()
    
    public init() {}
    
    public func add(_ completion: @escaping Completion) {
        lock.lock()
        queue.append(completion)
        lock.unlock()
    }
    
    public func resolveAllCompletions(with value: CompletionValue) {
        queue.forEach { $0(value) }
        queue = []
    }
}
