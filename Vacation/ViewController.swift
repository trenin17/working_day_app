import UIKit
import SnapKit

class LaunchViewController: UIViewController {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(systemName: "beach.umbrella.fill")!
            .withTintColor(ColorPalette.accent, renderingMode: .alwaysTemplate)
        return view
    }()
    
    let vacationLabel: UILabel = {
        let label = UILabel()
        label.text = "Vacation"
        label.font = .systemFont(ofSize: 46, weight: .semibold)
        label.textColor = ColorPalette.accent
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
//        view.addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200 - view.safeAreaInsets.top),
//            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            imageView.heightAnchor.constraint(equalToConstant: 200),
//            imageView.widthAnchor.constraint(equalToConstant: 200)
//        ])
////        imageView.snp.makeConstraints { make in
////            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(200)
////            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
////            make.width.height.equalTo(200)
////        }
//        
//        view.addSubview(vacationLabel)
//        vacationLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            vacationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
//            vacationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//        ])
////        vacationLabel.snp.makeConstraints { make in
////            make.top.equalTo(imageView.snp.bottom).offset(5)
////            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
////        }
    }
    
    


}

