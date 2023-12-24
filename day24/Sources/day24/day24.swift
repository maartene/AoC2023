import Foundation

struct HailStone {
    let position: DVector3D
    let velocity: DVector3D
    
    init(position: DVector3D, velocity: DVector3D) {
        self.position = position
        self.velocity = velocity
    }
    
    init(_ inputString: String) {
        let parts = inputString.split(separator: "@").map { String($0) }
        let positionString = parts[0]
        let positionParts = positionString.split(separator: ",").map { String($0) }
        let positionNumbers = positionParts.compactMap { part in Float80(part.trimmingCharacters(in: .whitespaces)) }
        let position = DVector3D(x: positionNumbers[0], y: positionNumbers[1], z: positionNumbers[2])
        
        let velocityString = parts[1]
        let velocityParts = velocityString.split(separator: ",").map { String($0) }
        let velocityNumbers = velocityParts.compactMap { part in Float80(part.trimmingCharacters(in: .whitespaces)) }
        let velocity = DVector3D(x: velocityNumbers[0], y: velocityNumbers[1], z: velocityNumbers[2])
        
        self.init(position: position, velocity: velocity)
    }
    
    func intersectsXY(_ other: HailStone, searchArea: ClosedRange<Float80>) -> DVector2D? {
        
        // check for hailstones that are on the same line
        // paralel lines on same segment have a dot product of -1 or 1
        let dot_velocities = DVector2D.dot(velocity.xy.normalized, other.velocity.xy.normalized)
        if dot_velocities == -1 || dot_velocities == 1 {
            // same direction, but are they the same?
            let line_from_one_to_the_other = (other.position.xy - position.xy).normalized
            let dot_lineVelocity = DVector2D.dot(line_from_one_to_the_other, velocity.xy.normalized)
            // again, the line from this hailstones position to the other hailstones position should be either the velocity or the inverse of the velocity. I.e. dot product should be -1 or 1.
            if dot_lineVelocity == -1 || dot_lineVelocity == 1 {
                // as the lines are the same, it doesn't really matter which position to return.
                return position.xy
            }
        }
        
        // Calculate intersection using function on https://en.wikipedia.org/wiki/Line–line_intersection
        // Points on the first line segment (this hailstone)
        let p1 = position.xy
        let p2 = position.xy + velocity.xy * 1_000_000
        
        // Points on the second line segment (other hailstone)
        let p3 = other.position.xy
        let p4 = other.position.xy + other.velocity.xy * 1_000_000
    
        // Determinants of the line segments
        let det_l1 = DVector2D.det(p1, p2)
        let det_l2 = DVector2D.det(p3, p4)
        
        let den = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
        
        // X coordinate
        let px_nom = det_l1 * (p3.x - p4.x) - (p1.x - p2.x) * det_l2
        let px = px_nom / den
        
        // Y coordinate
        let py_nom = det_l1 * (p3.y - p4.y) - (p1.y - p2.y) * det_l2
        let py = py_nom / den
        
        let p_intersect = DVector2D(x: px, y: py)
        
        // checks
        // inside search area?
        guard searchArea.contains(px) && searchArea.contains(py) else {
            print("Found intersection (\(px),\(py)), but outside of search range")
            return nil
        }
        
        // in the future for this hailstone? (dot product > 0)
        let line1 = (p_intersect - position.xy).normalized
        guard DVector2D.dot(line1, velocity.xy.normalized) >= 0 else {
            print("Found intersection (\(px),\(py)), but it's in the past for this hailstone")
            return nil
        }
        
        // in the future for the other hailstone? (dot product > 0)
        let line2 = (p_intersect - other.position.xy).normalized
        guard DVector2D.dot(line2, velocity.xy.normalized) >= 0 else {
            print("Found intersection (\(px),\(py)), but it's in the past for the other hailstone")
            return nil
        }
        
        return DVector2D(x: px, y: py)
    }
}

extension HailStone: Equatable { }

func intersectingHailStoneCount(_ inputString: String, searchArea: ClosedRange<Float80>) -> Int {
    let hailstones = inputString.split(separator: "\n").map { String($0) }.map { HailStone($0) }
    var hailStonesToCheck = hailstones
    
    var count = 0
    while hailStonesToCheck.isEmpty == false {
        let hailStone = hailStonesToCheck.removeFirst()
        for otherHailStone in hailStonesToCheck {
            if hailStone.intersectsXY(otherHailStone, searchArea: searchArea) != nil {
                count += 1
            }
        }
    }
    
    return count
}
