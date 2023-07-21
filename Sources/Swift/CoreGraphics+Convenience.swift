//
//  File.swift
//  
//
//  Created by Carlo Rapisarda on 2023-07-18.
//

import CoreGraphics

public extension CGPoint {
    
    func distance(to p: CGPoint) -> CGFloat {
        CGPointLengthBetween_AGK(self, p)
    }
    
    func converted(from currentReferenceSize: CGSize, to newReferenceSize: CGSize) -> CGPoint {
        if !(currentReferenceSize.width > 0 && currentReferenceSize.height > 0) {
            preconditionFailure("The reference dimensions must be larger than zero!")
        }
        return CGPoint(
            x: newReferenceSize.width * x / currentReferenceSize.width,
            y: newReferenceSize.height * y / currentReferenceSize.height
        )
    }
}

public extension CGSize {
    
    enum RectifyingStrategy {
        case minimumSize
        case average
        case maximumSize
    }
    
    init(corners: [CGPoint], topFirst: Bool = true, strategy: RectifyingStrategy = .average) {
        precondition(corners.count == 4)
        
        let parallelA1 = corners[0].distance(to: corners[1])
        let parallelB1 = corners[1].distance(to: corners[2])
        let parallelA2 = corners[2].distance(to: corners[3])
        let parallelB2 = corners[3].distance(to: corners[0])
        
        let lengthA: CGFloat
        let lengthB: CGFloat
        
        switch strategy {
        case .minimumSize:
            lengthA = min(parallelA1, parallelA2)
            lengthB = min(parallelB1, parallelB2)
        case .average:
            lengthA = (parallelA1 + parallelA2) / 2.0
            lengthB = (parallelB1 + parallelB2) / 2.0
        case .maximumSize:
            lengthA = max(parallelA1, parallelA2)
            lengthB = max(parallelB1, parallelB2)
        }
        
        if topFirst {
            self.init(width: lengthA, height: lengthB)
        } else {
            self.init(width: lengthB, height: lengthA)
        }
    }
}

public extension CGRect {
    
    var withZeroedOrigin: CGRect {
        CGRect(origin: .zero, size: size)
    }

    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - 0.5 * size.width,
                             y: center.y - 0.5 * size.height)
        self.init(origin: origin, size: size)
    }
}
