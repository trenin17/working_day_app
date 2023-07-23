import SwiftUI

struct EmployeeListItemView: View {
    
    private enum Constant {
        static let imageSize: CGFloat = 35
        static let height: CGFloat = 50
        static let badgeSize: CGFloat = 10
    }
    let viewModel: EmployeeListItem
    
    var body: some View {
        HStack(spacing: 20) {
            avatar
                .padding(.leading, 5)
            Text(viewModel.name).foregroundColor(.black)
            Spacer()
            if let badge = viewModel.badge {
                badgeView(notifications: badge)
            }
        }
    }
    
    var avatar: some View {
        VacationAsyncImage(
            url: viewModel.avatarURL
        )
        .circle(size: Constant.imageSize)
    }
    
    func badgeView(notifications: Int) -> some View {
        ZStack {
            ColorPalette.redAlert
            Text("\(notifications)")
                .font(.caption2)
                .foregroundColor(.white)
        }
        .circle(size: 19)
        .padding(.trailing, 5)
    }
    
    func badgeView2(notifications: Int) -> some View {
        Text("\(notifications)")
            .font(.caption2)
            .foregroundColor(.white)
            .padding(5)
            .background(ColorPalette.redAlert)
            .frame(height: Constant.badgeSize)
            .padding(5)
            .clipShape(Circle())
            .padding(.trailing, 5)
    }
}

struct EmployeeListItemView_Previews: PreviewProvider {
    static let viewModelWithAvatar = EmployeeListItem(
        id: .random,
        avatarURL: .randomURL,
        name: "With avatar",
        badge: 25
    )
    
    static let viewModelWithNoAvatar = EmployeeListItem(
        id: .random,
        avatarURL: nil,
        name: "No avatar",
        badge: 2
    )
    
    static var previews: some View {
        VStack {
            EmployeeListItemView(viewModel: viewModelWithAvatar)
            EmployeeListItemView(viewModel: viewModelWithNoAvatar)
        }
        
    }
}

