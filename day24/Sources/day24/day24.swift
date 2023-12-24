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
        
        // checks
        // inside search area?
        guard searchArea.contains(px) && searchArea.contains(py) else {
            //print("Found intersection (\(px),\(py)), but outside of search range")
            return nil
        }
        
        let p_intersect = DVector2D(x: px, y: py)
        
        // in the future for this hailstone? (dot product > 0)
        let line1 = (p_intersect - position.xy).normalized
        guard DVector2D.dot(line1, velocity.xy.normalized) >= 0 else {
            //print("Found intersection (\(px),\(py)), but it's in the past for this hailstone")
            return nil
        }
        
        // in the future for the other hailstone? (dot product > 0)
        let line2 = (p_intersect - other.position.xy).normalized
        guard DVector2D.dot(line2, other.velocity.xy.normalized) >= 0 else {
            //print("Found intersection (\(px),\(py)), but it's in the past for the other hailstone")
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

// MARK: Part 2

/// We need to find a solution for these equations:
/// ```
/// position_rock + velocity_rock * t1 == position_hail_1 + velocity_hail_1 * t1;
/// position_rock + velocity_rock * t2 == position_hail_2 + velocity_hail_2 * t2;
/// position_rock + velocity_rock * t3 == position_hail_3 + velocity_hail_3 * t3;
/// ```
/// Where each equation is a 3D vector equation. So they can be expanded into three separate equations:
/// ```
/// position_rock + velocity_rock * t1 == position_hail_1 + velocity_hail_1 * t1
/// ```
/// becomes:
/// ````
/// position_rock.x + velocity_rock.x * t1 == position_hail_1.x + velocity_hail_1.x * t1
/// position_rock.y + velocity_rock.y * t1 == position_hail_1.y + velocity_hail_1.y * t1
/// position_rock.z + velocity_rock.z * t1 == position_hail_1.z + velocity_hail_1.z * t1
/// ```
/// So 9 equations in total, with 9 unknowns:
///     position_rock.x, position_rock.y, position_rock.z, 
///     velocity_rock.x, velocity_rock.y, velocity_rock.z, 
///     t1, t2, t3
/// 
/// I used a SageMath workbook to find the answer, as doing this in pure Swift seems like a chore
/// And entering 18 formula's in Symbolabs single inputfield row is very fragile.
///
/// Here's the workbook code:
/// ```
/// var('x y z vx vy vz t1 t2 t3 ans')
/// eq1 = x + (vx * t1) == (input removed) + ( (input removed ) * t1)
/// eq2 = y + (vy * t1) == (input removed) + ( (input removed ) * t1)
/// eq3 = z + (vz * t1) == (input removed) + ( (input removed ) * t1)
/// eq4 = x + (vx * t2) == (input removed) + ( (input removed ) * t2)
/// eq5 = y + (vy * t2) == (input removed) + ( (input removed ) * t2)
/// eq6 = z + (vz * t2) == (input removed) + ( (input removed ) * t2)
/// eq7 = x + (vx * t3) == (input removed) + ( (input removed ) * t3)
/// eq8 = y + (vy * t3) == (input removed) + ( (input removed ) * t3)
/// eq9 = z + (vz * t3) == (input removed) + ( (input removed ) * t3)
/// eq10 = ans == x + y + z
/// print(solve([eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8,eq9,eq10],x,y,z,vx,vy,vz,t1,t2,t3,ans))
/// ```
/// Maybe next year we have a Z3 variant for Swift?
