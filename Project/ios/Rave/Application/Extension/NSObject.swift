import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self.self)
    }
}
