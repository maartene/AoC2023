//
//  Vectors.swift
//
//
//  Created by Maarten Engels on 24/12/2023.
//

import Foundation

struct DVector2D {
    let x: Float80
    let y: Float80
    
    static var zero: DVector2D {
        return DVector2D(x: 0, y: 0)
    }
    
    static func +(_ v1: DVector2D, _ v2: DVector2D) -> DVector2D {
        DVector2D(x: v1.x + v2.x, y: v1.y + v2.y)
    }
    
    static func -(_ v1: DVector2D, _ v2: DVector2D) -> DVector2D {
        DVector2D(x: v1.x - v2.x, y: v1.y - v2.y)
    }
    
    static func *(_ v: DVector2D, _ scalar: Float80) -> DVector2D {
        DVector2D(x: v.x * scalar, y: v.y * scalar)
    }
    
    static func /(_ v: DVector2D, _ scalar: Float80) -> DVector2D {
        DVector2D(x: v.x / scalar, y: v.y / scalar)
    }
    
    static func det(_ p1: DVector2D, _ p2: DVector2D) -> Float80 {
        p1.x * p2.y - p1.y * p2.x
    }
    
    static func dot(_ v1: DVector2D, _ v2: DVector2D) -> Float80 {
        v1.x * v2.x + v1.y * v2.y
    }
    
    var magnitude: Float80 {
        sqrt(x*x + y*y)
    }
    
    var normalized: DVector2D {
        let magnitude = magnitude
        return DVector2D(x: x / magnitude, y: y / magnitude)
    }
}

extension DVector2D: Equatable { }

extension DVector2D: Hashable { }

struct DVector3D {
    let x: Float80
    let y: Float80
    let z: Float80
    
    static var zero: DVector3D {
        DVector3D(x: 0, y: 0, z: 0)
    }
    
    var xy: DVector2D {
        DVector2D(x: x, y: y)
    }
}

extension DVector3D: Equatable { }
