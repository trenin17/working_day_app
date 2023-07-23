import SwiftUI
import Combine

@main
struct LaunchedApp: App {
    enum Mode {
        case prod
        case develop
    }
    private let mode: Mode = .prod
    
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            currentView
        }
    }
    
    @ViewBuilder
    private var currentView: some View {
        switch mode {
        case .prod:
            VacationUIAppProd().currentView
        case .develop:
            VacationUIAppDebug(store: .mockUnauthorized)
        }
    }
    
}
