import XCTest
@testable import day24

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
        let positionNumbers = positionParts.compactMap { part in Double(part.trimmingCharacters(in: .whitespaces)) }
        let position = DVector3D(x: positionNumbers[0], y: positionNumbers[1], z: positionNumbers[2])
        
        let velocityString = parts[1]
        let velocityParts = velocityString.split(separator: ",").map { String($0) }
        let velocityNumbers = velocityParts.compactMap { part in Double(part.trimmingCharacters(in: .whitespaces)) }
        let velocity = DVector3D(x: velocityNumbers[0], y: velocityNumbers[1], z: velocityNumbers[2])
        
        self.init(position: position, velocity: velocity)
    }
    
    func intersectsXY(_ other: HailStone, searchArea: ClosedRange<Double>) -> DVector2D? {
        // Points on the first line segment (this hailstone)
        let p1 = position.xy
        let p2 = position.xy + velocity.xy * 3
        
        // Points on the second line segment (other hailstone)
        let p3 = other.position.xy
        let p4 = other.position.xy + other.velocity.xy * 3
        
        
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
            print("Found intersection (\(px),\(py)), but outside of search range")
            return nil
        }
        
        return DVector2D(x: px, y: py)
    }
}

final class day24Tests: XCTestCase {
    let exampleInput =
    """
    19, 13, 30 @ -2,  1, -2
    18, 19, 22 @ -1, -1, -2
    20, 25, 34 @ -2, -2, -4
    12, 31, 28 @ -1, -2, -1
    20, 19, 15 @  1, -5, -3
    """
    
    func test_hailStone_fromInputString() {
        let inputString = ("19, 13, 30 @ -2,  1, -2")
        let expected = HailStone(position: DVector3D(x: 19, y: 13, z: 30), velocity: DVector3D(x: -2, y: 1, z: -2))
        let result = HailStone(inputString)
        
        XCTAssertEqual(result.position, expected.position)
        XCTAssertEqual(result.velocity, expected.velocity)
    }
    
    func test_hailstone1_intersects_hailstone2_insideSearchArea() throws {
        let hailStoneA = HailStone("19, 13, 30 @ -2,  1, -2")
        let hailStoneB = HailStone("18, 19, 22 @ -1, -1, -2")
        let expected = DVector2D(x: 14.333, y: 15.333)
        
        let result = try XCTUnwrap(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.0)))
        
        XCTAssertEqual(result.x, expected.x, accuracy: 0.01)
        XCTAssertEqual(result.y, expected.y, accuracy: 0.01)
    }
    
    func test_hailstone1_intersects_hailstone3_insideSearchArea() throws {
        let hailStoneA = HailStone("19, 13, 30 @ -2,  1, -2")
        let hailStoneB = HailStone("20, 25, 34 @ -2, -2, -4")
        let expected = DVector2D(x: 11.667, y: 16.667)
        
        let result = try XCTUnwrap(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.0)))
        
        XCTAssertEqual(result.x, expected.x, accuracy: 0.01)
        XCTAssertEqual(result.y, expected.y, accuracy: 0.01)
    }
    
    func test_hailstone1_intersects_hailstone4_outsideSearchArea() throws {
        let hailStoneA = HailStone("19, 13, 30 @ -2,  1, -2")
        let hailStoneB = HailStone("12, 31, 28 @ -1, -2, -1")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone2_neverIntersects_hailstone3() {
        let hailStoneA = HailStone("18, 19, 22 @ -1, -1, -2")
        let hailStoneB = HailStone("20, 25, 34 @ -2, -2, -4")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone1_intersects_hailstone5_inThePast() {
        let hailStoneA = HailStone("19, 13, 30 @ -2,  1, -2")
        let hailStoneB = HailStone("20, 25, 34 @ -2, -2, -4")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
}
