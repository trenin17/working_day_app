import SwiftUI

struct TopNavigationView: View {
    
    private enum Constant {
        static let slotSize: CGFloat = 40
    }
    
    private var leadView: () -> AnyView?
    private var text: String
    private var trailView: () -> AnyView?
    
    public init() {
        self.leadView = { nil }
        self.text = ""
        self.trailView = { nil }
    }
    
    var body: some View {
        HStack {
            if let leadView = leadView() {
                leadView
                    .frame(width: Constant.slotSize, height: Constant.slotSize)
                    .padding(.leading, 4)
            } else {
                Spacer()
                    .frame(width: Constant.slotSize)
            }
            Text(text)
                .font(.title2)
            Spacer()
            if let trailView = trailView() {
                trailView
                    .frame(width: Constant.slotSize, height: Constant.slotSize)
                    .padding(.trailing, 4)
            }
        }
    }
    
    public func leadView<V: View>(@ViewBuilder _ view: @escaping () -> V?) -> TopNavigationView {
        var copy = self
        copy.leadView = { AnyView(view()) }
        return copy
    }
    
    public func trailView<V: View>(@ViewBuilder _ view: @escaping () -> V?) -> TopNavigationView {
        var copy = self
        copy.trailView = { AnyView(view()) }
        return copy
    }
    
    public func text(_ text: String) -> TopNavigationView {
        var copy = self
        copy.text = text
        return copy
    }
}
