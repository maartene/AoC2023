import XCTest
@testable import day23

final class day23Tests: XCTestCase {
    let exampleInput =
    """
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
    """
    
    func test_longestPath_withExampleInput() {
        let map = Map(exampleInput)
        let result = map.longestPathUsingDFS()
        XCTAssertEqual(result, 94)
    }
    
    func test_part1() {
        let map = Map(input)
        let result = map.longestPathUsingDFS()
        XCTAssertEqual(result, 2042)
    }
    
    // MARK: Part 2
    func test_longestPath_withoutSlopes_withExampleInput() {
        var changedString = exampleInput.replacingOccurrences(of: ">", with: ".")
        changedString = changedString.replacingOccurrences(of: "<", with: ".")
        changedString = changedString.replacingOccurrences(of: "^", with: ".")
        changedString = changedString.replacingOccurrences(of: "v", with: ".")
        
        let map = Map(changedString)
        let result = map.longestPathUsingDFS()
        XCTAssertEqual(result, 154)
    }
    
    func test_part2() {
        var changedString = input.replacingOccurrences(of: ">", with: ".")
        changedString = changedString.replacingOccurrences(of: "<", with: ".")
        changedString = changedString.replacingOccurrences(of: "^", with: ".")
        changedString = changedString.replacingOccurrences(of: "v", with: ".")
        
        let map = Map(changedString)
        let result = map.longestPathUsingDFS()
        
        print("Found maximum: \(result)")
        XCTAssertEqual(result, 6466)
        
    }
    
    func test_simplifyGraph() {
        var changedString = input.replacingOccurrences(of: ">", with: ".")
        changedString = changedString.replacingOccurrences(of: "<", with: ".")
        changedString = changedString.replacingOccurrences(of: "^", with: ".")
        changedString = changedString.replacingOccurrences(of: "v", with: ".")
        
        let map = Map(input)
        map.simplifyGraph()
        
    }
}
