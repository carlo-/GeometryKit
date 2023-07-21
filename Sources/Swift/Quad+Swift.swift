import CoreGraphics

public typealias Quad = AGKQuad

public extension Quad {
    
    var corners: [CGPoint] {
        return [
            topLeft,
            topRight,
            bottomRight,
            bottomLeft
        ]
    }
    
    var path: CGPath {
        let p = CGMutablePath()
        p.addLines(between: [topLeft, topRight, bottomRight, bottomLeft, topLeft])
        return p
    }
    
    var topLeft: CGPoint {
        get { tl }
        mutating set {
            self = AGKQuadModifyCorner(self, AGKCornerTopLeft, newValue)
        }
    }
    
    var topRight: CGPoint {
        get { tr }
        mutating set {
            self = AGKQuadModifyCorner(self, AGKCornerTopRight, newValue)
        }
    }
    
    var bottomRight: CGPoint {
        get { br }
        mutating set {
            self = AGKQuadModifyCorner(self, AGKCornerBottomRight, newValue)
        }
    }
    
    var bottomLeft: CGPoint {
        get { bl }
        mutating set {
            self = AGKQuadModifyCorner(self, AGKCornerBottomLeft, newValue)
        }
    }
}

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
    
    var minX: CGFloat {
        corners.map(\.x).min()!
    }
    
    var minY: CGFloat {
        corners.map(\.y).min()!
    }
    
    var maxX: CGFloat {
        corners.map(\.x).max()!
    }
    
    var maxY: CGFloat {
        corners.map(\.y).max()!
    }
    
    var boundingBox: CGRect {
        CGRect(x: minX , y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    var origin: CGPoint {
        get {
            boundingBox.origin
        }
        mutating set {
            let oldValue = self.origin
            self = applying(.init(
                translationX: (newValue.x - oldValue.x),
                y: (newValue.y - oldValue.y)
            ))
        }
    }
    
    init(topLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint, bottomLeft: CGPoint) {
        self.init(
            tl: topLeft,
            tr: topRight,
            br: bottomRight,
            bl: bottomLeft
        )
    }
    
    init(_ corners: [CGPoint]) {
        self.init(
            tl: corners[0],
            tr: corners[1],
            br: corners[2],
            bl: corners[3]
        )
    }
    
    func converted(from currentReferenceSize: CGSize, to newReferenceSize: CGSize) -> Quad {
        Self(corners.map { $0.converted(from: currentReferenceSize, to: newReferenceSize) })
    }
    
    func withZeroOrigin() -> Quad {
        var result = self
        result.origin = .zero
        return result
    }
    
    func withLocalCoordinates() -> (relativeQuad: Quad, absoluteFrame: CGRect) {
        let frame = boundingBox
        let quad = withZeroOrigin()
        return (relativeQuad: quad, absoluteFrame: frame)
    }
}

public extension Quad {
    
    func flippingAxisX(within width: CGFloat) -> Quad {
        Quad(corners.map { CGPoint(x: width - $0.x, y: $0.y) })
    }
    
    func flippingAxisY(within height: CGFloat) -> Quad {
        Quad(corners.map { CGPoint(x: $0.x, y: height - $0.y) })
    }
    
    func flippingAxisX() -> Quad {
        flippingAxisX(within: boundingBox.width)
    }
    
    func flippingAxisY() -> Quad {
        flippingAxisY(within: boundingBox.height)
    }
    
    func flippedVertically() -> Quad {
        Quad(
            topLeft: bottomLeft,
            topRight: bottomRight,
            bottomRight: topRight,
            bottomLeft: topLeft
        )
    }
    
    func flippedHorizontally() -> Quad {
        Quad(
            topLeft: topRight,
            topRight: topLeft,
            bottomRight: bottomLeft,
            bottomLeft: bottomRight
        )
    }
    
    var center: CGPoint {
        AGKQuadGetCenter(self)
    }
    
    var rectangularSize: CGSize {
        CGSize(corners: corners, topFirst: true, strategy: .average)
    }
    
    var rectangularFrame: CGRect {
        rectangularFrame(withCenter: center)
    }
    
    func rectangularFrame(withCenter center: CGPoint) -> CGRect {
        CGRect(center: center, size: rectangularSize)
    }
}
