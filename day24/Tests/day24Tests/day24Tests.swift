import XCTest
@testable import day24

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
    
    func test_hailstone1_intersects_hailstone5_outsideSearchArea() throws {
        let hailStoneA = HailStone("19, 13, 30 @ -2,  1, -2")
        let hailStoneB = HailStone("20, 19, 15 @  1, -5, -3")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone2_neverIntersects_hailstone3() {
        let hailStoneA = HailStone("18, 19, 22 @ -1, -1, -2")
        let hailStoneB = HailStone("20, 25, 34 @ -2, -2, -4")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone2_neverIntersects_hailstone4() {
        let hailStoneA = HailStone("18, 19, 22 @ -1, -1, -2")
        let hailStoneB = HailStone("12, 31, 28 @ -1, -2, -1")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone2_intersects_hailstone5_inThePast() {
        let hailStoneA = HailStone("18, 19, 22 @ -1, -1, -2")
        let hailStoneB = HailStone("20, 19, 15 @  1, -5, -3")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone3_intersects_hailstone4_inThePast() {
        let hailStoneA = HailStone("20, 25, 34 @ -2, -2, -4")
        let hailStoneB = HailStone("12, 31, 28 @ -1, -2, -1")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone3_intersects_hailstone5_inThePast() {
        let hailStoneA = HailStone("20, 25, 34 @ -2, -2, -4")
        let hailStoneB = HailStone("20, 19, 15 @ 1, -5, -3")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_hailstone4_intersects_hailstone5_inThePast() {
        let hailStoneA = HailStone("12, 31, 28 @ -1, -2, -1")
        let hailStoneB = HailStone("20, 19, 15 @ 1, -5, -3")
        
        XCTAssertNil(hailStoneA.intersectsXY(hailStoneB, searchArea: (7.0 ... 27.000)))
    }
    
    func test_intersectingHailStones_withExampleInput() {
        let result = intersectingHailStoneCount(exampleInput, searchArea: (7.0 ... 27.000))
        XCTAssertEqual(result, 2)
    }
    
    func test_part1() {
       let result = intersectingHailStoneCount(input, searchArea: (200000000000000 ... 400000000000000))
        XCTAssertEqual(result, 20434)
    }
    
    // MARK: part 2
    // Used a SageMath workbook
}
