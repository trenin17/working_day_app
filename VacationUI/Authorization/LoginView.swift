//
//  LoginView.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 5/1/23.
//

import SwiftUI

struct LoginView: View {
    var credentialsStore: CredentialsStore
    @ObservedObject var service = AuthorizationService()
    @State var login: String = "user1"
    @State var password: String = "user1password"
    var body: some View {
        viewForState()
    }
    
    @ViewBuilder
    private func viewForState() -> some View {
        switch service.state {
        case .requestNotSent:
            baseView(isDisabled: false, errorMessage: nil)
        case .requestSent:
            baseView(isDisabled: true, errorMessage: nil)
        case .failure(let error):
            baseView(isDisabled: false, errorMessage: error)
        case .authorizedSuccess(let data):
            finishLoginView(with: data)
        }
    }
    
    private func baseView(
        isDisabled: Bool,
        errorMessage: String?
    ) -> some View {
        VStack {
            Spacer()
            vacationLogo
            makeTextField(placeholder: "Логин", text: $login)
            makeTextField(placeholder: "Пароль", text: $password)
            if let msg = errorMessage {
                Text(msg)
                    .foregroundColor(.red)
            }
            Button(
                action: {
                    guard isDisabled == false else { return }
                    let request = AuthorizationRequest(login: login, password: password)
                    service.authorize(data: request)

                },
                label: {
                    ZStack(alignment: .leading) {
                        isDisabled ? Color(uiColor: .systemGray4) : ColorPalette.Logo.titleBlue
                        Text("Войти")
                            .foregroundColor(Color.white)
                            .padding(.leading, 12)
                    }
                }
            )
            .frame(height: 35)
            .cornerRadius(10)
            Spacer()
        }
        .padding([.leading, .trailing], 60)
    }
    
    private var vacationLogo: some View {
        HStack(spacing: 4) {
            Text("РАБОЧИЙ")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(ColorPalette.Logo.titleBlue)
            Text("ДЕНЬ")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(ColorPalette.Logo.titleRed)
        }
    }
    
    private func finishLoginView(
        with data: AuthorizationResponseSuccess
    ) -> some View {
        let mappedRole: Credentials.Role
        switch data.role {
        case .admin:
            mappedRole = .admin
        case .user:
            mappedRole = .user
        }
        let creds = Credentials(id: login, token: data.token, role: mappedRole)
        credentialsStore.updateCredentials(creds)
        return EmptyView()
    }
    
    private func makeTextField(
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        TextField(placeholder, text: text)
            .autocorrectionDisabled(true)
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 6))
            .background(Color(uiColor: .systemGray5))
            .cornerRadius(8)
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static let mockStore = CredentialsStore.shared
    static var previews: some View {
        LoginView(credentialsStore: mockStore)
    }
}
