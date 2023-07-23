import Foundation
import UIKit
import SnapKit

protocol AUUCommonViewController: UIViewController {
    var childViewLayoutGuide: UILayoutGuide { get }
}

final class AUUCommonViewControllerImpl: UIViewController, AUUCommonViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.textMain
        label.text = "Добавление сотрудника"
        return label
    }()
    
    let childViewLayoutGuide = UILayoutGuide()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.background
        setupView()
    }
    
    private func setupView() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalTo(view.snp.centerX)
        }
        view.addLayoutGuide(childViewLayoutGuide)
        childViewLayoutGuide.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
