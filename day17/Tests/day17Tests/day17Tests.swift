import XCTest
@testable import day17





final class day17Tests: XCTestCase {
    let exampleInput =
    """
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
    """
    
    func test_f_witExampleInput() {
//        let factory = Factory(exampleInput)
//        let result1 = factory.f(Input(position: Vector2D(x: factory.width - 1, y: factory.height - 1), direction: .left, upCount: 0, downCount: 0, leftCount: 1, rightCount: 0), visited: [])
//        
//        XCTAssertEqual(result1, 102)
    }
    
    func test_dijkstra() {
        let factory = Factory(exampleInput)
        let dijkstra = factory.dijkstra2(target: .zero)
        
        let last = dijkstra.filter { $0.key.position == Vector2D(x: factory.width - 1, y: factory.height - 1) }
        let minimum = last.values.min()
        XCTAssertEqual(minimum, 102)
        
    }
    
    func test_part1() {
        let factory = Factory(input)
        let dijkstra = factory.dijkstra2(target: .zero)
        
        let last = dijkstra.filter { $0.key.position == Vector2D(x: factory.width - 1, y: factory.height - 1) }
        let minimum = last.values.min()
        XCTAssertEqual(minimum, 861)
    }
    
    // MARK: Part 2
    func test_ultraCrucible() {
        let factory = Factory(exampleInput)
        let dijkstra = factory.dijkstra2_ultraCrucible_2(target: .zero)
        
        let last = dijkstra.filter { $0.key.position == Vector2D(x: factory.width - 1, y: factory.height - 1) }
        let minimum = last.values.min()
        XCTAssertEqual(minimum, 94)
    }
    
    func test_getNeighbours_ultra_5_0() {
        let factory = Factory(exampleInput)
        let result = factory.getNeighbours_ultra(Input(position: Vector2D(x: 5, y: 0), previousPosition: Vector2D(x: 4, y: 0), straightCount: 4))
        
        XCTAssertTrue(result.map { $0.position }.contains(Vector2D(x: 5, y: 1)))
    }
    
    let exampleInput2 =
    """
    111111111111
    999999999991
    999999999991
    999999999991
    999999999991
    """
    
    func test_ultraCrucible_withExampleInput2_2() {
        let factory = Factory(exampleInput2)
        let dijkstra = factory.dijkstra2_ultraCrucible_2(target: .zero)
        
        let last = dijkstra.filter { $0.key.position == Vector2D(x: factory.width - 1, y: factory.height - 1) &&
            $0.key.chainLength >= 4
        }
        let minimum = last.values.min()
        XCTAssertEqual(minimum, 71)
    }
    
    func test_part2() {
        let factory = Factory(input)
        let dijkstra = factory.dijkstra2_ultraCrucible_2(target: .zero)
        
        let last = dijkstra.filter { $0.key.position == Vector2D(x: factory.width - 1, y: factory.height - 1) &&
            $0.key.chainLength >= 4 }
        let minimum = last.values.min()
        XCTAssertEqual(minimum, 1037)
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
