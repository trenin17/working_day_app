import Foundation
import UIKit
import SnapKit

final class EmployeeViewController: UIViewController {
    
    var employeeLabel: UILabel = {
        let label = UILabel()
        label.text = "Employee Mode"
        return label
    }()
    
    override func viewDidLoad() {
        setupView()
    }
    
    func setupView() {
        employeeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.height.equalTo(40)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
    }
    
}
