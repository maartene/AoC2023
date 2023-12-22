//
//  Vector3D.swift
//  Pocket Tactics
//
//  Created by Maarten Engels on 14/08/2023.
//

import Foundation

/// A 3D vector with integer coordinates.
struct Vector3D {
    let x: Int
    let y: Int
    let z: Int
    
    init(x: Int, y: Int, z: Int = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Vector3D: Equatable { }

extension Vector3D {

    /// The zero vector.
    static var zero: Vector3D {
        Vector3D(x: 0, y: 0, z: 0)
    }
}

extension Vector3D {
    static func +(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        Vector3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func -(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        Vector3D(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func *(vector: Vector3D, scalar: Int) -> Vector3D {
        Vector3D(x: vector.x * scalar, y: vector.y * scalar, z: vector.z * scalar)
    }
}

extension Vector3D: Hashable { }

//extension Vector3D {
//
//    /// Creates a new Vector2D from the x and y coordinates of this Vector3D.
//    var xy: Vector2D {
//        Vector2D(x: self.x, y: self.y)
//    }
//}

extension Vector3D {

    /// A random vector with integer coordinates.
    static var random: Vector3D {
        Vector3D(x: Int.random(in: -10...10), y: Int.random(in: -10...10), z: Int.random(in: -10...10))
    }
}
