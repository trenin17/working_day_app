import Foundation
import UIKit

final class AUUCoordinator {
    private weak var commonViewController: AUUCommonViewController?
    private weak var stepVC: UIViewController?
    
    func start(on viewController: UINavigationController) {
        let commonVC = assembleCommonViewController()
        commonViewController = commonVC
        viewController.pushViewController(commonVC, animated: true)
        attachUsernameStep()
    }
    
    private func attachUsernameStep() {
        let usernameStep = AUUUsernameStep()
        usernameStep.delegate = self
        attachStep(step: usernameStep)
    }
    
    private func attachClarifyStep(
        authData: AUUClarifyStepAuthData,
        usernameStepData: AUUUsernameStepUsernameStepData
    ) {
        let clarifyStep = AUUClarifyStep(authData: authData, prevData: usernameStepData)
        clarifyStep.delegate = self
        attachStep(step: clarifyStep)
    }
    
    private func assembleCommonViewController() -> AUUCommonViewController {
        return AUUCommonViewControllerImpl()
    }
    
    private func attachStep(step: UIViewController) {
        guard let commonViewController = commonViewController else { return }
        if let prevStep = stepVC {
            prevStep.willMove(toParent: nil)
            prevStep.removeFromParent()
            prevStep.view.removeFromSuperview()
            stepVC = nil
        }
        stepVC = step
        commonViewController.addChild(step)
        commonViewController.view.addSubview(step.view)
        step.didMove(toParent: commonViewController)
        step.view.snp.makeConstraints { make in
            make.top.equalTo(commonViewController.childViewLayoutGuide.snp.top)
            make.leading.equalTo(commonViewController.childViewLayoutGuide.snp.leading)
            make.trailing.equalTo(commonViewController.childViewLayoutGuide.snp.trailing)
            make.bottom.equalTo(commonViewController.childViewLayoutGuide.snp.bottom)
        }
    }
}

extension AUUCoordinator: AUUUsernameStepDelegate {
    func usernameStep(finishWith data: AUUUsernameStepUsernameStepData) {
        let mockAuthData = AUUClarifyStepAuthData(username: "@user123", password: "qwerty")
        attachClarifyStep(authData: mockAuthData, usernameStepData: data)
    }
}

extension AUUCoordinator: AUUClarifyStepDelegate {
    func didTapOkButton() {
        print("Ass")
    }
    
    
}
