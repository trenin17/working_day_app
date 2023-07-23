import Foundation
import UIKit

final class LoginCoordinator {
    
    private lazy var loginViewController = LoginViewController()
    
    func startLogin(on viewController: UIViewController) {
        let controller = viewController.presentingViewController ?? viewController
        loginViewController.modalPresentationStyle = .overFullScreen
        controller.present(loginViewController, animated: true)
    }
}
