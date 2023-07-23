import SwiftUI
import Kingfisher

class ViewHolder<Wrapee: View> {
    
    private let wrapee: Wrapee
    
    init(wrapee: Wrapee) {
        self.wrapee = wrapee
    }
    
    func asView() -> some View {
        return wrapee
    }
}

struct UserInfoView: View {
    let viewModel: UserInfo
    
    var body: some View {
        VStack(spacing: 5) {
            VacationAsyncImage(url: viewModel.avatarURL)
                .circle(size: 200)
            name
            personalInfo
        }
    }
    
    var name: some View {
        Text(viewModel.username)
            .font(.headline)
    }
    
    var personalInfo: some View {
        VStack(alignment: .leading) {
            personalInfoItem(
                key: "Телефон",
                value: viewModel.phone ?? "Не указан"
            )
            personalInfoItem(
                key: "e-mail",
                value: viewModel.email ?? "Не указан"
            )
            personalInfoItem(
                key: "Дата рождения",
                value: viewModel.birthday ?? "Не указана"
            )
        }
    }
    
    private func personalInfoItem(key: String, value: String) -> some View {
        HStack {
            Text("\(key):")
            Text(value)
        }
    }

}

struct UserInfoView_Previews: PreviewProvider {
    
    static let viewModel =  UserInfo(
        id: .random,
        username: .randomName,
        avatarURL: .randomURL,
        phone: String?.random,
        email: String?.random,
        birthday: String?.random
    )
    
    static var previews: some View {
        UserInfoView(viewModel: viewModel)
    }
}
