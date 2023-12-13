import XCTest
@testable import day13

final class day13Tests: XCTestCase {
    let exampleInput1 =
    """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """
    
    let exampleInput2 =
    """
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """
    
    let exampleInput =
    """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """
    
    lazy var mountainRangeExample1 = MountainRange(exampleInput1)
    
    lazy var mountainRangeExample2 = MountainRange(exampleInput2)
    
    func test_isVerticalReflection_withExampleInput_with5_returnsTrue() {
        let result = mountainRangeExample1.isVerticalMirror(col: 4)
        XCTAssertTrue(result)
    }
    
    func test_isVerticalReflection_withExampleInput_with6_returnsFalse() {
        let result = mountainRangeExample1.isVerticalMirror(col: 5)
        XCTAssertFalse(result)
    }
    
    func test_isVerticalReflection_withExampleInput_with0_returnsFalse() {
        let result = mountainRangeExample1.isVerticalMirror(col: 0)
        XCTAssertFalse(result)
    }
    
    func test_findVerticalReflection_withExampleInput1() {
        let result = mountainRangeExample1.findVerticalReflection()
        XCTAssertEqual(result, 4)
    }
    
    func test_findVerticalReflection_withExampleInput2_returnsNil() {
        let result = mountainRangeExample2.findVerticalReflection()
        XCTAssertNil(result)
    }
    
    func test_findHorizontalReflection_withExampleInput2() {
        let result = mountainRangeExample2.findHorizontalReflection()
        XCTAssertEqual(result, 3)
    }
    
    func test_findHorizontalReflection_withExampleInput1_returnsNil() {
        let result = mountainRangeExample1.findHorizontalReflection()
        XCTAssertNil(result)
    }
    
    func test_calculateCheckSum_withExampleInput() {
        let result = calculateCheckSum(exampleInput)
        XCTAssertEqual(result, 405)
    }
    
    func test_part1() {
        let result = calculateCheckSum(input)
        XCTAssertEqual(result, 30802)
    }
    
    // MARK: Part 2
    func test_findHorizontalReflection_withExampleInput1_returns2_whenFlipping0_0() {
        let result = mountainRangeExample1.findHorizontalReflection(flipLocation: Vector2D(x: 0, y: 0))
        XCTAssertEqual(result, 2)
    }
    
    func test_findHorizontalReflection_withExampleInput2_returns0_whenFlipping4_1() {
        let result = mountainRangeExample2.findHorizontalReflection(flipLocation: Vector2D(x: 4, y: 1))
        XCTAssertEqual(result, 0)
    }
    
    func test_findHorizontalReflectionWithFlipping_withExampleInput1_returns2() {
        let result = mountainRangeExample1.findReflectionWithFlipping()
        XCTAssertEqual(result.col, nil)
        XCTAssertEqual(result.row, 2)
    }
    
    func test_findHorizontalReflectionWithFlipping_withExampleInput2_returns0() {
        let result = mountainRangeExample2.findReflectionWithFlipping()
        XCTAssertEqual(result.col, nil)
        XCTAssertEqual(result.row, 0)
    }
    
    func test_calculateCheckSumWithFlipping_withExampleInput() {
        let result = calculateCheckSumWithFlipping(exampleInput)
        XCTAssertEqual(result, 400)
    }
    
    func test_part2() {
        let result = calculateCheckSumWithFlipping(input)
        XCTAssertEqual(result, 37876)
    }
    
    let exampleInput3 =
    """
    ..#.#...##.
    ##.#.##.##.
    ##.##.##..#
    ..#..##.##.
    ##.#.###.##
    ..#.#..#..#
    ..###..#..#
    ..###.##..#
    ##....#####
    ##..##.....
    ..#..#.#..#
    """
    
    func test_calculateChecksum_withExampleInput3() {
        let result = calculateCheckSum(exampleInput3)
        XCTAssertEqual(result, 1)
    }
    
    func test_calculateChecksumWithFlipping_withExampleInput3() {
        let exampleRange3 = MountainRange(exampleInput3)
        let result = exampleRange3.findReflectionWithFlipping()
        XCTAssertEqual(result.col, 8)
        XCTAssertEqual(result.row, nil)
    }
}
