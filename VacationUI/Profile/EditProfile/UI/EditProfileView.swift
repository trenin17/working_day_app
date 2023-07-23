import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) private var presentationMode

    @ObservedObject var store: EditProfileStore
    
    @State private var updatedImage: UIImage? = nil
    @State private var showImageSelector = false
    @State private var isSelectedUpdatedImage = false
    
    @State private var phoneField: String = ""
    @State private var emailField: String = ""
    @State private var birthdayField: String = ""
    
    var body: some View {
        VStack(spacing: 5) {
            navigationView
            Spacer().frame(height: 20)
            editableAvatar
            Spacer().frame(height: 20)
            editableView
                .padding([.leading, .trailing], 20)
            Spacer()
            dissmissForStateIfNeeded
        }.onAppear {
            self.phoneField = store.viewModel.userInfo.phone ?? ""
            self.emailField = store.viewModel.userInfo.email ?? ""
            self.birthdayField = store.viewModel.userInfo.birthday ?? ""
        }
    }
    
    // MARK: - Interaction
    
    private func performEdit() {
        store.makeEditRequest(
            phoneField: phoneField == "" ? nil : phoneField,
            emailField: emailField == "" ? nil : emailField,
            birthdayField: birthdayField == "" ? nil : birthdayField,
            image: updatedImage
        )
    }
    
    var dissmissForStateIfNeeded: some View {
        switch store.state {
        case .dismiss, .dismissWithAlert:
            presentationMode.wrappedValue.dismiss()
        case .editFailed, .editing, .sendingRequest:
            break
        }
        return EmptyView()
    }
    
    // MARK: = UI
    
    private var navigationView: some View {
        TopNavigationView()
            .leadView {
                VacationAsyncImage(
                    url: store.viewModel.userInfo.avatarURL
                )
                .clipShape(Circle())
            }
            .trailView { endEditingButton }
            .text("Редактирование профиля")
    }
    
    private var endEditingButton: some View {
        Image(systemName: "checkmark")
            .fontWeight(.bold)
            .foregroundColor(ColorPalette.activeControl)
            .onTapGesture {
                performEdit()
            }
    }
    
    private var editableAvatar: some View {
        VStack {
            if let image = updatedImage {
                Image(uiImage: image)
                    .resizable()
                    .circle(size: 200)
            } else {
                VacationAsyncImage(url: store.viewModel.userInfo.avatarURL)
                    .circle(size: 200)
            }
            Button("Изменить фото") {
                showImageSelector = true
            }
            .sheet(isPresented: $showImageSelector) {
                VacationImagePicker(
                    sourceType: .photoLibrary,
                    selectedImage: self.$updatedImage
                )
            }
        }
    }
    
    private var editableView: some View {
        VStack(alignment: .leading) {
            editableTextView(
                title: "Телефон",
                variable: $phoneField
            )
            editableTextView(
                title: "E-mail",
                variable: $emailField
            )
            editableTextView(
                title: "Дата рождения",
                variable: $birthdayField
            )
        }
    }
    
    private func editableTextView(
        title: String,
        variable: Binding<String>
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField(title, text: variable)
                .autocorrectionDisabled(true)
                .frame(width: 220, height: 30)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 6))
                .background(Color(uiColor: .systemGray5))
                .cornerRadius(8)
        }
    }
    
}

struct EditProfileView_Previews: PreviewProvider {
    
    static let viewModel = ProfileData(
        userInfo: UserInfo(
            id: .random,
            username: .randomName,
            avatarURL: .randomURL,
            phone: String?.random,
            email: String?.random,
            birthday: String?.random
        ),
        buttons: [
            ProfileData.Button(title: .random, badge: .random),
            ProfileData.Button(title: .random, badge: .random),
        ]
    )
    
    static let store = EditProfileStore(viewModel: viewModel, networkManager: .default)
    
    static var previews: some View {
        EditProfileView(store: store)
    }
}
