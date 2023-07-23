import Foundation

public final class VacationTimer {
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Public properties
    
    public var onTimerTic: ((String, String) -> Void)? = nil
    public var onFireTimerCompletion: (() -> Void)? = nil
    
    // MARK: - Private properties
    
    private let lock = NSLock()
    private var timer = Timer()
    private var numberOfRunsLeft = 0
    private var shouldCallCompletions = true
    private var shouldCallFireCompletion = false
    private var shouldCallNearestTicCompletion = false
    private var nearestTicCompletionData: (String, String)? = nil
    
    // MARK: - Public methods
    
    public func startTimer(
        minutes: Int,
        seconds: Int
    ) {
        timer.invalidate()
        numberOfRunsLeft = seconds + minutes * 60
        timerClosure(timer: timer)
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] timer in
            self?.timerClosure(timer: timer)
        }
            
    }
    
    private func timerClosure(timer: Timer) {
        numberOfRunsLeft -= 1

        if numberOfRunsLeft == 0 {
            lock.lock()
            if shouldCallCompletions {
                onFireTimerCompletion?()
            } else {
                shouldCallFireCompletion = true
                shouldCallNearestTicCompletion = false
            }
            lock.unlock()
            timer.invalidate()
        } else {
            let minutesLeft = numberOfRunsLeft / 60
            let secondsLeft = numberOfRunsLeft - (60 * minutesLeft)
            let minutesString = minutesLeft < 10 ? "0\(minutesLeft)" : "\(minutesLeft)"
            let secondsString = secondsLeft < 10 ? "0\(secondsLeft)" : "\(secondsLeft)"
            lock.lock()
            if shouldCallCompletions {
                onTimerTic?(minutesString, secondsString)
            } else {
                shouldCallNearestTicCompletion = true
                nearestTicCompletionData = (minutesString, secondsString)
            }
            lock.unlock()
        }
    }
    
    public var isRunning: Bool {
        return numberOfRunsLeft > 0
    }
    
    public func stopCompletions() {
        lock.lock()
        self.shouldCallCompletions = false
        lock.unlock()
    }
    
    public func resumeCompletions() {
        lock.lock()
        self.shouldCallCompletions = true
        if shouldCallFireCompletion {
            onFireTimerCompletion?()
            shouldCallFireCompletion = false
        } else if shouldCallNearestTicCompletion {
            nearestTicCompletionData.flatMap { onTimerTic?($0, $1) }
            shouldCallNearestTicCompletion = false
        }
        lock.unlock()
    }
}
