//
//  File.swift
//  
//
//  Created by Carlo Rapisarda on 2023-07-21.
//

import CoreGraphics

internal func barycentricCoords(_ vertices: [CGPoint], _ point: CGPoint) -> (CGFloat, CGFloat, CGFloat) {
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
