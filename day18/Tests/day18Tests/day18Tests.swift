import XCTest
@testable import day18

final class day18Tests: XCTestCase {
    let exampleInput =
    """
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """
    
    func test_countOutline() {
        let outline =
        """
        #######
        #.....#
        ###...#
        ..#...#
        ..#...#
        ###.###
        #...#..
        ##..###
        .#....#
        .######
        """
        
        let lavaCount = outline.filter { $0 == "#" }.count
        
        XCTAssertEqual(lavaCount, 38)
    }
    
    func test_countInside() {
        let inside =
        """
        #######
        #######
        #######
        ..#####
        ..#####
        #######
        #####..
        #######
        .######
        .######
        """
        
        let lavaCount = inside.filter { $0 == "#" }.count
        
        XCTAssertEqual(lavaCount, 62)
        
    }
    
    func test_digPlan_outlineCount_withExampleInput() {
        let digPlan = DigPlan(exampleInput, useHex: false)
        XCTAssertEqual(digPlan.circumference, 38)
    }
    
    func test_digPlan_insideCount_withExampleInput() {
        let digPlan = DigPlan(exampleInput, useHex: false)
        XCTAssertEqual(digPlan.insideCount, 62)
    }
    
    func test_part1() {
        let digPlan = DigPlan(input, useHex: false)
        let result = digPlan.insideCount
        XCTAssertEqual(result, 47527)
    }
    
    // MARK: Part2
    func test_hexDigPlan_insideCount_withExampleInput() {
        let digPlan = DigPlan(exampleInput, useHex: true)
        XCTAssertEqual(digPlan.insideCount, 952408144115)
    }
        
    func test_part2() {
        let digPlan = DigPlan(input, useHex: true)
        let result = digPlan.insideCount
        XCTAssertEqual(result, 52240187443190)
    }
    
    
    
}
