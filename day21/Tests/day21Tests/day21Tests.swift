import XCTest
@testable import day21

struct Map {
    let tiles: [Vector2D: Character]
    let startPosition: Vector2D
    let width: Int
    let height: Int
    let targetStepCount: Int
    
    init(_ inputString: String, targetStepCount: Int) {
        self.targetStepCount = targetStepCount
        let lines = inputString.split(separator: "\n").map { String($0) }
        
        height = lines.count
        width = lines.first?.count ?? 0
        var startPosition = Vector2D.zero
        var tiles = [Vector2D: Character]()
        for y in 0 ..< height {
            let line = lines[y]
            let lineArray = line.split(separator: "").map { Character(String($0)) }
            for x in 0 ..< width {
                if lineArray[x] == "S" {
                    startPosition = Vector2D(x: x, y: y)
                    tiles[Vector2D(x: x, y: y)] = "."
                } else {
                    tiles[Vector2D(x: x, y: y)] = lineArray[x]
                }
            }
        }
//        
//        // multiply map
//        let multiplier = max(width / targetStepCount, height / targetStepCount) / 2
//        for i in -multiplier ... multiplier {
//            for tile in tiles {
//                tiles[Vector2D(x: tile.key.x + width * i, y: tile.key.y + height * i)]
//            }
//        }
        
        self.tiles = tiles
        self.startPosition = startPosition
    }
    
    func getTileCountWithinSteps() -> Int {
        let dijkstra = bfs(target: startPosition)
        //printDijkstra(tiles: dijkstra, colCount: width, rowCount: height)
        return dijkstra.filter { $0.value == targetStepCount || ($0.value < targetStepCount && $0.value % 2 == targetStepCount % 2) }
            .count
    }
    
    func getNeighboursFor(_ currentNode: Vector2D) -> [Vector2D] {
        currentNode.neighbours.filter {
            let multiplier = max(targetStepCount / width, targetStepCount / height) + 1
            let coord = Vector2D(x: (multiplier * width + $0.x) % width, y: (multiplier * height + $0.y) % height)
            
            let manhattanDistance = abs((startPosition.x - $0.x) + (startPosition.y - $0.y))
            guard manhattanDistance <= targetStepCount else {
                return false
            }
            
            return tiles[coord] == "."
        }
    }
    
    func bfs(target: Vector2D) -> [Vector2D: Int] {
            var unvisited = [target]
            var unvisitedSet = Set([target])
            var visited = Set<Vector2D>()
            var dist = [Vector2D: Int]()
            
            
            dist[target] = 0
            var currentNode = target
            while unvisited.isEmpty == false {
                let neighbours = getNeighboursFor(currentNode)
                for neighbour in neighbours {
                    if visited.contains(neighbour) == false && unvisitedSet.contains(neighbour) == false {
                        unvisited.append(neighbour)
                        unvisitedSet.insert(neighbour)
                    }
                    let alt = dist[currentNode]! + 1
                    if alt < dist[neighbour, default: Int.max] {
                        dist[neighbour] = alt
                    }
                }
                
                unvisitedSet.remove(currentNode)
                currentNode = unvisited[0]
                unvisited.removeFirst()
                visited.insert(currentNode)
                
//                if let newNode = unvisited.min(by: { dist[$0, default: Int.max] < dist[$1, default: Int.max] }) {
//                    currentNode = newNode
//                }
            }
            return dist
        }
}

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
        let map = Map(exampleInput, targetStepCount: 6)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 16)
    }
    
    func test_part1() {
        let map = Map(input, targetStepCount: 64)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 3709)
    }
    
    // part 2
    func test_map_getTileCountWithingSteps_10steps_forExampleInput() {
        let map = Map(exampleInput, targetStepCount: 10)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 50)
    }
    
    func test_map_getTileCountWithingSteps_50steps_forExampleInput() {
        let map = Map(exampleInput, targetStepCount: 50)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 1594)
    }
    
    func test_map_getTileCountWithingSteps_100steps_forExampleInput() {
        let map = Map(exampleInput, targetStepCount: 100)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 6536)
    }
    
    func test_map_getTileCountWithingSteps_3steps_forExampleInput() {
        let map = Map(exampleInput, targetStepCount: 3)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 6)
    }
    
    func test_map_getTileCountWithingSteps_500steps_forExampleInput() {
        let map = Map(exampleInput, targetStepCount: 500)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 167004)
    }
    
    func test_map_getTileCountWithingSteps_1000steps_forExampleInput() {
        let map = Map(exampleInput, targetStepCount: 1000)
        let result = map.getTileCountWithinSteps()
        XCTAssertEqual(result, 668697)
    }
    
//    func test_map_getTileCountWithingSteps_5000steps_forExampleInput() {
//        let map = Map(exampleInput, targetStepCount: 5000)
//        let result = map.getTileCountWithinSteps()
//        XCTAssertEqual(result, 16733044)
//    }
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
