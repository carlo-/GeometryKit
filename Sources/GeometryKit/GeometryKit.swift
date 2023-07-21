import UIKit
import AGGeometryKit

public typealias Quad = AGGeometryKit.AGKQuad

public extension Quad {
    
    func applying(_ t: CGAffineTransform) -> Self {
        AGKQuadApplyCGAffineTransform(self, t)
    }
    
    func moveRelativeToSelf(x: CGFloat = 0, y: CGFloat = 0) -> Self {
        AGKQuadMoveRelativeToSelf(self, x, y)
    }
    
    func mirroring(x: Bool, y: Bool) -> Self {
        AGKQuadMirror(self, x, y)
    }
}
