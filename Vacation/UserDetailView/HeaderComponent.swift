import Foundation
import UIKit
import SnapKit

class HeaderViewComponenet: UIView {
    
    private enum Constants {
        static let imageSize: CGFloat = 30
    }
    
    let lead: UIImage
    let text: String
    let trail: UIImage?
    
    private lazy var leadImageView = UIImageView(image: lead)
    private lazy var trailImageView = UIImageView(image: trail)
    private lazy var label = UILabel()
    
    init(lead: UIImage, text: String, trail: UIImage?) {
        self.lead = lead
        self.text = text
        self.trail = trail
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(leadImageView)
        addSubview(label)
        addSubview(trailImageView)
        
        leadImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.top.equalTo(self.snp.top)
            make.height.width.equalTo(Constants.imageSize)
        }
        leadImageView.clipsToBounds = true
        leadImageView.layer.cornerRadius = Constants.imageSize / 2
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(leadImageView.snp.trailing).offset(10)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(leadImageView.snp.height)
        }
        label.textColor = ColorPalette.textMain
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        trailImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-8)
            make.top.equalTo(self.snp.top)
            make.height.width.equalTo(Constants.imageSize)
        }
        
        snp.makeConstraints { make in make.height.equalTo(Constants.imageSize) }
    }
}




enum ProfileViewMode {
    case myProfile
    case employeeProfile
    case adminModeProfile
}

struct EmplyeeDomainData {
    let avatarURL: String?
    let name: String
    let phone: String
    let email: String
    let birthday: String
}

class ProfileView: UIView {
    
    private enum Constants {
        static let imageSize: CGFloat = 150
    }
    
    let mode: ProfileViewMode
    let data: EmplyeeDomainData
    
    private lazy var avatarImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var labelsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    init(mode: ProfileViewMode, data: EmplyeeDomainData) {
        self.mode = mode
        self.data = data
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(labelsStackView)
        
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
            make.height.width.equalTo(Constants.imageSize)
        }
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = Constants.imageSize / 2
        avatarImageView.image = Icons.hardcode_Billy
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.centerX.equalTo(self.snp.centerX)
        }
        nameLabel.text = data.name
        nameLabel.textColor = ColorPalette.textMain
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        fillLabelStack()
        
        labelsStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }
    }
    
    private func fillLabelStack() {
        let labelsData: [(String, String)] = [
            ("Телефон", data.phone),
            ("Почта", data.email),
            ("Дата рождения", data.birthday),
        ]
        labelsData.forEach { key, value in
            let label = UILabel()
            label.textColor = ColorPalette.textMain
            label.text = "\(key): \(value)"
            labelsStackView.addArrangedSubview(label)
        }
    }
}

class ProfileViewExampleVC: UIViewController {
    let mode = ProfileViewMode.myProfile
    let data = EmplyeeDomainData(
        avatarURL: nil,
        name: "Никита Ерохин",
        phone: "+79165304223",
        email: "erohkha@erokha.com",
        birthday: "05.06.2000"
    )
    
    private lazy var head = HeaderViewComponenet(
        lead: Icons.hardcode_Billy,
        text: "Мой профиль",
        trail: Icons.edit.withTintColor(.blue, renderingMode: .alwaysTemplate)
    )
    private lazy var mainView = ProfileView(mode: mode, data: data)
    
    override func viewDidLoad() {
        view.addSubview(head)
        view.addSubview(mainView)
        view.backgroundColor = .systemBackground
        
        head.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(head.snp.bottom).offset(100)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
