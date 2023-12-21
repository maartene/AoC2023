import XCTest
@testable import day21

struct Map {
    let tiles: [Vector2D: Character]
    let startPosition: Vector2D
    let width: Int
    let height: Int
    
    init(_ inputString: String) {
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
    
    func getTileCountWithinSteps(_ targetStepCount: Int) -> Int {
        let dijkstra = bfs(target: startPosition, with: targetStepCount)
        //printDijkstra(tiles: dijkstra, colCount: width, rowCount: height)
        return dijkstra.filter { $0.value == targetStepCount || ($0.value < targetStepCount && $0.value % 2 == targetStepCount % 2) }
            .count
    }
    
    func getNeighboursFor(_ currentNode: Vector2D, with targetStepCount: Int) -> [Vector2D] {
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
    
    func bfs(target: Vector2D, with targetStepCount: Int) -> [Vector2D: Int] {
            var unvisited = [target]
            var unvisitedSet = Set([target])
            var visited = Set<Vector2D>()
            var dist = [Vector2D: Int]()
            
            
            dist[target] = 0
            var currentNode = target
            while unvisited.isEmpty == false {
                let neighbours = getNeighboursFor(currentNode, with: targetStepCount)
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

func crazyCalc(_ inputString: String, targetStepCount: Int) -> Int {
    let map = Map(inputString)
    let reachableTilesPerFullSquare = map.getTileCountWithinSteps(map.height)
    let fullTilesCount = targetStepCount / map.height
    let numberOfFullSquares = Int(1.5 * Double(fullTilesCount * fullTilesCount) - 0.5 * Double(fullTilesCount))
    let numberOfReachableTilesInFullSquares = numberOfFullSquares * reachableTilesPerFullSquare
    
    let lastSteps = targetStepCount % map.height
    let reachableTilesCountPerPartialSquare = map.getTileCountWithinSteps(lastSteps) - 1
    let partialSquareCount = (fullTilesCount * 4) + 1
    let reachableTilesInPartialSquares = partialSquareCount * reachableTilesCountPerPartialSquare
    
    return numberOfReachableTilesInFullSquares + reachableTilesInPartialSquares
//
//    //−0.7089𝑥2+417.7𝑥+1.000
//    var map = Map(input)
//    let tilesPerSquare = map.getTileCountWithinSteps()
//    
//    let bigsteps = (26501365 / 131)
//    
//    
//    let numberOfFullTiles = 2 * bigsteps * bigsteps + 2 *  bigsteps
//    
//    print("big steps tiles: ", bigsteps, numberOfFullTiles)
//    let numberOfFullTilesTiles = tilesPerSquare * numberOfFullTiles
//    print("Total number of reachable tiles in full squares: ", numberOfFullTilesTiles)
//    
//    let lastSteps = 26501365 % 131
//    map = Map(input, targetStepCount: lastSteps)
//    let lastTiles = map.getTileCountWithinSteps()
//    let lastTilesInOuterRing = 4 * (bigsteps + 1) * lastTiles
//    print("last part tiles: ", lastTilesInOuterRing)
//    
//    print("total: ", lastTilesInOuterRing + numberOfFullTilesTiles )
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
    
    let patternInput =
    """
    ...........
    ......##.#.
    .###..#..#.
    ..#.#...#..
    ....#.#....
    .....S.....
    .##......#.
    .......##..
    .##.#.####.
    .##...#.##.
    ...........
    """
    
    func test_patternInput() {
        let map = Map(patternInput)
        for i in 0 ..< 50 {
            let count = map.getTileCountWithinSteps(1 + i * 2)
            print("\(1 + i * 2): \(count)")
        }
    }
    
    func test_input() {
        let map = Map(input)
        
        let modulo = 26501365 % map.height
        
        for i in 3 ... 7 {
            let count = map.getTileCountWithinSteps(modulo * i)
            print("\(modulo * i): \(count)")
        }
    }
    
//    func test_crazyCalc_1() {
//        let result = crazyCalc(input, targetStepCount: 1)
//        XCTAssertEqual(result, 4)
//    }
//    
//    func test_crazyCalc_131() {
//        let result = crazyCalc(input, targetStepCount: 131)
//        XCTAssertEqual(result, 15301)
//    }
//    
//    func test_crazyCalc_163() {
//        let result = crazyCalc(input, targetStepCount: 163)
//        XCTAssertEqual(result, 23157) // 23157
//    }
//    
//    func test_crazyCalc_262() {
//        let result = crazyCalc(input, targetStepCount: 262)
//        XCTAssertEqual(result, 60771)
//    }
    
//    func test_map_getTileCountWithingSteps_500steps_forExampleInput() {
//        let map = Map(exampleInput, targetStepCount: 500)
//        let result = map.getTileCountWithinSteps()
//        XCTAssertEqual(result, 167004)
//    }
//    
//    func test_map_getTileCountWithingSteps_1000steps_forExampleInput() {
//        let map = Map(exampleInput, targetStepCount: 1000)
//        let result = map.getTileCountWithinSteps()
//        XCTAssertEqual(result, 668697)
//    }
    
    
        
        // 634419234701821,00
        // 1252405005729977 too big
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
