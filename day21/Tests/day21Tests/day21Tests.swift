import XCTest
@testable import day21

final class day21Tests: XCTestCase {
    let exampleInput =
    """
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    """
    
    func test_map_getTileCountWithingSteps_forExampleInput() {
        let map = Map(exampleInput)
        let result = map.getTileCountWithinSteps(6)
        XCTAssertEqual(result, 16)
    }
    
    func test_part1() {
        let map = Map(input)
        let result = map.getTileCountWithinSteps(64)
        XCTAssertEqual(result, 3709)
    }
    
    // part 2
    func test_map_getTileCountWithingSteps_10steps_forExampleInput() {
        let map = Map(exampleInput)
        let result = map.getTileCountWithinSteps(10)
        XCTAssertEqual(result, 50)
    }
    
    func test_map_getTileCountWithingSteps_50steps_forExampleInput() {
        let map = Map(exampleInput)
        let result = map.getTileCountWithinSteps(50)
        XCTAssertEqual(result, 1594)
    }
    
    func test_map_getTileCountWithingSteps_100steps_forExampleInput() {
        let map = Map(exampleInput)
        let result = map.getTileCountWithinSteps(100)
        XCTAssertEqual(result, 6536)
    }
    
    func test_map_getTileCountWithingSteps_3steps_forExampleInput() {
        let map = Map(exampleInput)
        let result = map.getTileCountWithinSteps(3)
        XCTAssertEqual(result, 6)
    }
        
    func test_map_bigCount() {
        let map = Map(input)
        let result = map.getTileCountWithinStepsBig(26501365)
        XCTAssertEqual(result, 617361073602319)
    }
}

func printDijkstra(tiles: [Vector2D: Int], colCount: Int, rowCount: Int) {
    for y in 0 ..< rowCount {
        var row = "|"
        for x in 0 ..< colCount {
            let coord = Vector2D(x: x, y: y)
            if let value = tiles[coord] {
                if value > 100 {
                    row += "##|"
                } else {
                    row += String(format: "%02d", value) + "|"
                }
            } else {
                row += "  |"
            }
        }
        print(row)
    }
}
