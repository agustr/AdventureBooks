import Foundation
import UIKit

extension CGSize {
    func aspectRatio() -> CGFloat {
        self.width / self.height
    }
}
