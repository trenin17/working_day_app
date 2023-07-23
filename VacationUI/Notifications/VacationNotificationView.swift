import Foundation
import SwiftUI

struct VacationNotificationView: View {
    
    private enum Constant {
        static let height: CGFloat = 90
        static let cornerRadius: CGFloat = 15
    }
    
    struct NotificationButton {
        let text: String
        let color: Color
        let action: Action
        
        enum Action {
            case navigation(() -> AnyView)
            case tap(() -> Void)
        }
    }
    
    private struct EnumeratedNotificationButton: Identifiable {
        let id: Int
        let button: NotificationButton
    }
    
    var imageURL: String? = nil
    var senderName: String = ""
    var text: String = ""
    var buttons: [NotificationButton] = []
    var shouldShowBade: Bool = false
    
    var body: some View {
        content
            .background(ColorPalette.backgroundMinor)
            .cornerRadius(Constant.cornerRadius)
            .showBadge(shouldShowBade)
            .padding([.leading, .trailing], 20)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                    VacationAsyncImage(url: imageURL)
                        .defaultImage { IconAsset.avatarPlaceholder }
                        .circle(size: 60)
                    texts
                    Spacer()
                }
                buttonsView
                .padding(.bottom, 12)
                .padding(.leading, 4)
        }
        .padding(.horizontal, 8)
    }
    
    private var buttonsView: some View {
        let enumbuttons = self.buttons.enumerated().map {
            EnumeratedNotificationButton(id: $0.offset, button: $0.element)
        }
            return HStack {
                ForEach(enumbuttons) { element in
                    switch element.button.action {
                    case .tap(let tap):
                        actionButton(button: element.button, action: tap)
                    case .navigation(let navigation):
                        navigationButton(button: element.button, action: navigation)
                    }
                }
            }
    }
    
    private func actionButton(button: NotificationButton, action: @escaping () -> Void) -> some View {
        Button(
            action: action,
            label: { buttonView(button: button) }
        )
    }
    
    private func navigationButton(button: NotificationButton, action: () -> AnyView) -> some View {
        NavigationLink(
            destination: action,
            label: { buttonView(button: button) }
        )
    }
    
    private func buttonView(button: NotificationButton) -> some View {
        Text(button.text)
            .foregroundColor(.white)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(button.color)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
    }
    
    private var texts: some View {
        VStack(alignment: .leading) {
            Text(senderName)
                .font(.body)
                .fontWeight(.medium)
            Text(text)
                .font(.body)
                .fontWeight(.regular)
            Spacer()
        }
        .frame(height: 80)
        .padding(.vertical, 8)
    }
    
    func imageURL(_ imageURL: String?) -> VacationNotificationView {
        var copy = self
        copy.imageURL = imageURL
        return copy
    }
    
    func senderName(_ senderName: String) -> VacationNotificationView {
        var copy = self
        copy.senderName = senderName
        return copy
    }
    
    func text(_ text: String) -> VacationNotificationView {
        var copy = self
        copy.text = text
        return copy
    }
    
    func shouldShowBade(_ shouldShowBade: Bool) -> VacationNotificationView {
        var copy = self
        copy.shouldShowBade = shouldShowBade
        return copy
    }
    
    func buttons(
        _ buttons: [NotificationButton]
    ) -> VacationNotificationView {
        var copy = self
        copy.buttons = buttons
        return copy
    }
    
}

struct VacationNotificationView_Preview: PreviewProvider {
    
    static var previews: some View {
        VStack {
            VacationNotificationView()
                .imageURL(String.randomURL)
                .senderName("Бухгалтерия")
                .text("Заявлени на оформление больничного принято. Спасибо вам!")
                .shouldShowBade(true)
                .buttons(
                    [
                        .init(
                            text: "Документ",
                            color: .blue,
                            action: .tap({})
                        )
                    ]
                )
            VacationNotificationView()
                .imageURL(String.randomURL)
                .senderName("Бухгалтерия")
                .text("Прошу отправить меня в отпуск")
                .shouldShowBade(true)
                .buttons(
                    [
                        .init(
                            text: "Принять",
                            color: .green,
                            action: .tap({})
                        ),
                        .init(
                            text: "Отклонить",
                            color: .red,
                            action: .tap({})
                        )
                    ]
                )
        }
        
    }
    
}


fileprivate extension View {
    @ViewBuilder
    func showBadge(_ shouldShow: Bool) -> some View {
        if !shouldShow {
            self
        } else {
            overlay(
                ZStack {
                    ColorPalette.redAlert.circle(size: 15)
                }
                    .offset(x: 5, y: -7)
                , alignment: .topTrailing)
        }
    }
}
