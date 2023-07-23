import Foundation
import UIKit
import SnapKit

protocol AUUClarifyStepDelegate: AnyObject {
    func didTapOkButton()
}

struct AUUClarifyStepAuthData {
    let username: String
    let password: String
}

final class AUUClarifyStep: UIViewController {
    
    weak var delegate: AUUClarifyStepDelegate?
    
    private lazy var usernameLabel = UILabel()
    private lazy var passwordLabel = UILabel()
    private lazy var prevDataLabel = UILabel()
    
    private let authData: AUUClarifyStepAuthData
    private let prevData: AUUUsernameStepUsernameStepData
    
    required init(authData: AUUClarifyStepAuthData, prevData: AUUUsernameStepUsernameStepData) {
        self.authData = authData
        self.prevData = prevData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.background
        setupView()
    }
    
    private func setupView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        
        prevDataLabel.text = "\(prevData.surname) \(prevData.name) \(prevData.secondName)"
        usernameLabel.text = "Логин: \(authData.username)"
        passwordLabel.text = "Пароль: \(authData.password)"
        
        stackView.addArrangedSubview(prevDataLabel)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(passwordLabel)
    }

}
