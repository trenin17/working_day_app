import Foundation
import UIKit

public struct Credentials: Codable {
    public let login: String
}

public enum AppMode {
    case employee
    case none
}

public class CredentialProvider {
    
    public private(set) var credentials: Credentials?
    public private(set) var appMode: AppMode
    
    public init(shouldHasCredentials: Bool) {
        self.credentials = shouldHasCredentials ? Credentials(login: "Erokha") : nil
        self.appMode = shouldHasCredentials ? .employee : .none
    }
}

final class AppCoordinator {
    
    public private(set) var mainViewController: UINavigationController = {
        let navVC = UINavigationController(
            rootViewController: LaunchViewController()
        )
        navVC.isNavigationBarHidden = true
        return navVC
    }()
    
    private let credentialProvider: CredentialProvider
    private let loginCoordinator = LoginCoordinator()
    private let auuCoordinator = AUUCoordinator()
    
    init(credentialProvider: CredentialProvider) {
        self.credentialProvider = credentialProvider
    }
    
    func start() {
        if credentialProvider.credentials == nil {
            loginCoordinator.startLogin(on: mainViewController)
        } else {
            switch credentialProvider.appMode {
            case .employee:
                auuCoordinator.start(on: mainViewController)
            case .none:
                assertionFailure("Illegal state. Harakiri!")
                DispatchQueue.main.sync { print("Killing myself") }
            }
        }
    }
    
}
