import Foundation
import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    lazy var loginTextField = UITextField()
    lazy var passwordTextField = UITextField()
    
    override func viewDidLoad() {
        setupView()
        view.backgroundColor = ColorPalette.background
    }
    
    func setupView() {
        view.addSubview(loginTextField)
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.height.equalTo(40)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        loginTextField.placeholder = "Логин"
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        passwordTextField.placeholder = "Пароль"
    }
    
}
