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
    
    func test_longestPath_withExampleInput() async{
        let result = await findMaxium(exampleInput)
        XCTAssertEqual(result, 94)
    }
    
    func test_part1() async {
        let result = await findMaxium(input, passCount: 100)
        XCTAssertEqual(result, 2042)
    }
    
    // MARK: Part 2
    func test_longestPath_withoutSlopes_withExampleInput() async {
        var changedString = exampleInput.replacingOccurrences(of: ">", with: ".")
        changedString = changedString.replacingOccurrences(of: "<", with: ".")
        changedString = changedString.replacingOccurrences(of: "^", with: ".")
        changedString = changedString.replacingOccurrences(of: "v", with: ".")
        
//        let result = await findMaxium(changedString, passCount: 100)
        let map = Map(changedString)
        let result = map.longestPath_dfs()
        XCTAssertEqual(result, 154)
    }
    
    func test_part2() async {
        var changedString = input.replacingOccurrences(of: ">", with: ".")
        changedString = changedString.replacingOccurrences(of: "<", with: ".")
        changedString = changedString.replacingOccurrences(of: "^", with: ".")
        changedString = changedString.replacingOccurrences(of: "v", with: ".")
        
        let map = Map(changedString)
        let result = map.longestPath_dfs()
        
        print("Found maximum: \(result)")
        // 5746 not right
        // 6262 not right
        // 6370 not right
        // 14:35  6422 not right
        
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
