import CoreGraphics

public typealias Quad = AGKQuad

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
