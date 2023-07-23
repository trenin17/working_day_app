import Foundation

extension Array where Element: Hashable {
    func removeDuplicates() -> Self {
        return [Element](Set<Element>(self))
    }
}
