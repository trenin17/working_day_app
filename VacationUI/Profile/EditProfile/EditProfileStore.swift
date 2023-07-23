import SwiftUI
import EFNetwork

struct UploadImageResponse: Decodable {
    let url: String
}

struct ProfileEditRequest: Encodable {
    let phone: String?
    let email: String?
    let birthday: String?
}

class EditProfileStore: ObservableObject {
    
    private enum Constant {
        private static let baseURL = GlobalConstants.baseURL
        static let uploadPhotoURL = baseURL + "/v1/profile/upload-photo"
        static let editProfileURL = baseURL + "/v1/profile/edit"
    }
    
    enum ViewState {
        case editing
        case sendingRequest
        case editFailed
        case dismiss
        case dismissWithAlert
        
        var description: String {
            switch self {
            case .editing:
                return "editing"
            case .sendingRequest:
                return "sendingRequest"
            case .editFailed:
                return "editFailed"
            case .dismiss:
                return "dismiss"
            case .dismissWithAlert:
                return "dismissWithAlert"
            }
        }
    }
    
    @Published var state: ViewState = .editing
    var viewModel: ProfileData
    
    let networkManager: EFNetworkManager
    
    init(
        viewModel: ProfileData,
        networkManager: EFNetworkManager
    ) {
        self.viewModel = viewModel
        self.networkManager = networkManager
    }
    
    func makeEditRequest(
        phoneField: String?,
        emailField: String?,
        birthdayField: String?,
        image: UIImage?
    ) {
        self.state = .sendingRequest
        Task {
            async let dataUpload = editData(
                newPhone: phoneField,
                newEmail: emailField,
                newBirthday: birthdayField
            )
            async let imageUpload = editImageIfNeeded(image: image)
            let dataUploadSuccess = await dataUpload
            let imageUploadSuccess = await imageUpload
            await MainActor.run {
                switch (dataUploadSuccess, imageUploadSuccess) {
                case (false, _):
                    self.state = .editFailed
                case (true, true):
                    self.state = .dismiss
                case (true, false):
                    self.state = .dismissWithAlert
                }
            }
        }
    }
    
    private func editData(
        newPhone: String?,
        newEmail: String?,
        newBirthday: String?
    ) async -> Bool {
        let request = ProfileEditRequest(
            phone: newPhone,
            email: newEmail,
            birthday: newBirthday
        )
        return await networkManager
            .postAsync(url: Constant.editProfileURL, body: request)
            .handleCode(200) { return true }
            .fallback { return false }
    }
    
    private func editImageIfNeeded(image: UIImage?) async -> Bool {
        guard let image else { return true }
        return await networkManager
            .postAsync(url: Constant.uploadPhotoURL)
            .handle(statusCode: 200, of: UploadImageResponse.self) { response in
                let url = response.url
                let result = await self.uploadImage(image, to: url)
                return result
            }
            .fallback {
                return false
            }
    }
    
    private func uploadImage(_ image: UIImage, to url: String) async -> Bool {
        guard let data = image.jpegData(compressionQuality: 0) else { return false }
        return await networkManager.upload(data: data, url: url)
            .handleCode(200) {
                return true
            }
            .fallback {
                return false
            }
    }
    
}
