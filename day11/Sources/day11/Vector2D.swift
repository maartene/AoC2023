//
//  Vector2D.swift
//  Pocket Tactics
//
//  Created by Maarten Engels on 14/10/2023.
//

import Foundation

/// A 2D vector with integer coordinates.
struct Vector2D {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Vector2D: Equatable { }

extension Vector2D {

    /// The zero vector.
    static var zero: Vector2D {
        Vector2D(x: 0, y: 0)
    }
}

extension Vector2D {
    static func +(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(vector: Vector2D, scalar: Int) -> Vector2D {
        Vector2D(x: vector.x * scalar, y: vector.y * scalar)
    }
}

extension Vector2D: Hashable { }

extension Vector2D {
    /// An array of unit vectors in all Manhattan directions (NESW).
    static var directionVectors = [
        Vector2D(x: 1, y: 0),
        Vector2D(x: -1, y: 0),
        Vector2D(x: 0, y: 1),
        Vector2D(x: 0, y: -1)
    ]
    
    /// An array of all neighbours in Manhattan directions (NESW).
    var neighbours: [Vector2D] {
        [
            Vector2D(x: self.x - 1, y: self.y),
            Vector2D(x: self.x + 1, y: self.y),
            Vector2D(x: self.x, y: self.y - 1),
            Vector2D(x: self.x, y: self.y + 1)
        ]
    }
}

extension Vector2D {
    /// Returns the dot product of two vectors, where each vector is first normalized to length 1.
    /// - Parameters:
    /// - parameter lhs: The first vector.
    /// - parameter rhs: The second vector.
    /// - Returns: The dot product of the two vectors. As the vectors are normalized, the result is between -1 and 1.
    static func dotNormalized(_ lhs: Vector2D, _ rhs: Vector2D) -> Double {
        let lhsLength = lhs.magnitude
        let rhsLength = rhs.magnitude
        let xDotPart = (Double(lhs.x) / lhsLength) * (Double(rhs.x) / rhsLength)
        let yDotPart = (Double(lhs.y) / lhsLength) * (Double(rhs.y) / rhsLength)
        return xDotPart + yDotPart
    }
    
    /// The (Pythagorian) length of the vector.
    var magnitude: Double {
        sqrt(Double(x * x + y * y))
    }
}
