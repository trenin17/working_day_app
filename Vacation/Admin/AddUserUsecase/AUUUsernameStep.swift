import Foundation
import UIKit
import SnapKit

protocol AUUUsernameStepDelegate: AnyObject {
    func usernameStep(finishWith data: AUUUsernameStepUsernameStepData)
}

struct AUUUsernameStepUsernameStepData {
    let name: String
    let surname: String
    let secondName: String
}

final class AUUUsernameStep: UIViewController {
    
    weak var delegate: AUUUsernameStepDelegate?
    
    private lazy var surnameTextField = makeTextField(hint: "Фамилия")
    private lazy var nameTextField = makeTextField(hint: "Имя")
    private lazy var secondNameTextField = makeTextField(hint: "Отчество")
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(handleAddTap), for: .touchUpInside)
        btn.snp.makeConstraints {
            make in make.height.equalTo(40)
        }
        btn.backgroundColor = ColorPalette.accent
        btn.setTitle("Создать", for: .normal)
        btn.setTitleColor(ColorPalette.textMain, for: .normal)
        return btn
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
        stackView.addArrangedSubview(surnameTextField)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(secondNameTextField)
        stackView.addArrangedSubview(addButton)
    }
    
    
    private func makeTextField(hint: String) -> UITextField {
        let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let textField = TextFieldWithPadding(padding: padding)
        textField.delegate = self
        textField.placeholder = hint
        textField.backgroundColor = ColorPalette.fillMinor
        textField.snp.makeConstraints {
            make in make.height.equalTo(40)
        }
        textField.layer.cornerRadius = 5
        return textField
    }
    
    @objc
    private func handleAddTap() {
        guard
            let name = nameTextField.text, nameTextField.text != "",
            let surname = surnameTextField.text, surnameTextField.text != "",
            let secondName = secondNameTextField.text, secondNameTextField.text != ""
        else {
            presentAlert(text: "Заполните фамилию имя и отчество нового сотрудника")
            return
        }
        
        delegate?.usernameStep(
            finishWith: AUUUsernameStepUsernameStepData(
                name: name,
                surname: surname,
                secondName: secondName
            )
        )
    }
    
    private func presentAlert(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

extension AUUUsernameStep: UITextFieldDelegate {
    
}
