
struct ProfileData {
    var userInfo: UserInfo
    var buttons: [Button]
    
    struct Button {
        let title: String
        let badge: Bool
    }
}
