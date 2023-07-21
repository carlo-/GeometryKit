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
    
    func contains(_ point: CGPoint) -> Bool {
        let triangle1 = [tl, tr, br]
        let triangle2 = [tl, br, bl]
        
        let (wA1, wB1, wC1) = barycentricCoords(triangle1, point)
        let (wA2, wB2, wC2) = barycentricCoords(triangle2, point)
        
        return (0 <= wA1 && wA1 <= 1 && 0 <= wB1 && wB1 <= 1 && 0 <= wC1 && wC1 <= 1) ||
               (0 <= wA2 && wA2 <= 1 && 0 <= wB2 && wB2 <= 1 && 0 <= wC2 && wC2 <= 1)
    }
    
    /// Checks if this quad fully contains another quad.
    func contains(_ quad: Quad) -> Bool {
        return contains(quad.tl) && contains(quad.tr) && contains(quad.br) && contains(quad.bl)
    }
}

// MARK: - Utilities

private func barycentricCoords(_ vertices: [CGPoint], _ point: CGPoint) -> (CGFloat, CGFloat, CGFloat) {
    let (x1, y1) = (vertices[0].x, vertices[0].y)
    let (x2, y2) = (vertices[1].x, vertices[1].y)
    let (x3, y3) = (vertices[2].x, vertices[2].y)
    
    let (x, y) = (point.x, point.y)
    
    let denom = ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
    let wA = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / denom
    let wB = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / denom
    let wC = 1 - wA - wB
    
    return (wA, wB, wC)
}
