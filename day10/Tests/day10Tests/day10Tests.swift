import XCTest
@testable import day10

final class day10Tests: XCTestCase {
    let exampleInput_simpleCase =
    """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """
    
    let exampleInput_complexCase =
    """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """
    
    func test_map_determineStartingPosition_withExampleInput() {
        let simpleMap = Map(exampleInput_simpleCase)
        XCTAssertEqual(simpleMap.startingPosition, Vector2D(x: 1, y: 1))
        
        let complexMap = Map(exampleInput_complexCase)
        XCTAssertEqual(complexMap.startingPosition, Vector2D(x: 0, y: 2))
    }
    
    func test_map_getCharacterAt_startingPosition() {
        let simpleMap = Map(exampleInput_simpleCase)
        XCTAssertEqual(simpleMap.getCharacterAt(Vector2D(x: 1, y: 1)), "F")
        
        let complexMap = Map(exampleInput_complexCase)
        XCTAssertEqual(complexMap.getCharacterAt(Vector2D(x: 0, y: 2)), "F")
    }
    
    func test_map_getCharacterAt_with_exampleInput_simpleCase() {
        let expected: [Vector2D: Character] = [
            Vector2D(x: 0, y: 0): ".",
            Vector2D(x: 1, y: 2): "|",
            Vector2D(x: 3, y: 3): "J",
        ]
        
        let map = Map(exampleInput_simpleCase)
        
        for pair in expected {
            XCTAssertEqual(map.getCharacterAt(pair.key), pair.value)
        }
    }
    
    func test_map_getCharacterAt_with_exampleInput_complexCase() {
        let expected: [Vector2D: Character] = [
            Vector2D(x: 0, y: 0): "7",
            Vector2D(x: 1, y: 2): "J",
            Vector2D(x: 3, y: 3): "-",
        ]
        
        let map = Map(exampleInput_complexCase)
        
        for pair in expected {
            XCTAssertEqual(map.getCharacterAt(pair.key), pair.value)
        }
    }
    
    // MARK: Part 1
    func test_map_dijkstra_with_exampleInput_simpleCase() {
        let map = Map(exampleInput_simpleCase)
        let dijkstra = map.dijkstra2(target: map.startingPosition)
        printDijkstra(tiles: dijkstra, colCount: map.colCount, rowCount: map.rowCount)
        let expected =
        """
        .....
        .012.
        .1.3.
        .234.
        ....S
        """
        let expectedMap = Map(expected)
        
        for pair in expectedMap.nodes.filter({ $0.value.isNumber }) {
            XCTAssertEqual(String(dijkstra[pair.key, default: -1]), String(pair.value))
        }
        
    }
    
    func test_map_dijkstra_with_exampleInput_complexCase() {
        let map = Map(exampleInput_complexCase)
        let dijkstra = map.dijkstra2(target: map.startingPosition)
        printDijkstra(tiles: dijkstra, colCount: map.colCount, rowCount: map.rowCount)
        let expected =
        """
        ..45.
        .236.
        01.78
        14567
        23..S
        """
        let expectedMap = Map(expected)
        
        for pair in expectedMap.nodes.filter({ $0.value.isNumber }) {
            XCTAssertEqual(String(dijkstra[pair.key, default: -1]), String(pair.value))
        }
        
    }
    
    func test_getStepCount() {
        XCTAssertEqual(getStepcount(exampleInput_simpleCase), 4)
        XCTAssertEqual(getStepcount(exampleInput_complexCase), 8)
    }
    
    func test_part1() {
        let result = getStepcount(input)
        XCTAssertEqual(result, 7093)
    }
    
    // MARK: Part 2
    let exampleInput_part2_1 =
    """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """
    
    let exampleInput_part2_2 =
    """
    ..........
    .S------7.
    .|F----7|.
    .||....||.
    .||....||.
    .|L-7F-J|.
    .|..||..|.
    .L--JL--J.
    ..........
    """
    
    let exampleInput_part2_3 =
    """
    ......................
    ..F----7F7F7F7F-7.....
    ..|F--7||||||||FJ.....
    ..||.FJ||||||||L7.....
    .FJL7L7LJLJ||LJ.L-7...
    .L--J.L7...LJS7F-7L7..
    .....F-J..F7FJ|L7L7L7.
    .....L7.F7||L7|.L7L7|.
    ......|FJLJ|FJ|F7|.LJ.
    .....FJL-7.||.||||....
    .....L---J.LJ.LJLJ....
    ......................
    """
    
    let exampleInput_part2_4 =
    """
    ......................
    .FF7FSF7F7F7F7F7F---7.
    .L|LJ||||||||||||F--J.
    .FL-7LJLJ||||||LJL-77.
    .F--JF--7||LJLJ7F7FJ-.
    .L---JF-JLJ.||-FJLJJ7.
    .|F|F-JF---7F7-L7L|7|.
    .|FFJF7L7F-JF7|JL---7.
    .7-L-JL7||F7|L7F-7F7|.
    .L.L7LFJ|||||FJL7||LJ.
    .L7JLJL-JLJLJL--JLJ.L.
    ......................
    """
    
    func test_map_findEnclosedTiles_with_exampleInput_part2_1() {
        let map = Map(exampleInput_part2_1)
        
        let expected = [
            Vector2D(x: 2, y: 6),
            Vector2D(x: 3, y: 6),
            Vector2D(x: 7, y: 6),
            Vector2D(x: 8, y: 6)
        ]
        
        let result = map.findEnclosedTiles()
        for coord in expected {
            XCTAssertTrue(result.contains(coord))
        }        
    }
    
    func test_scale3x() {
        let map = Map(exampleInput_part2_2)
        let map_3x = map.scale3()
        printMap(map_3x)
    }
    
    func test_map_findEnclosedTiles_with_exampleInput_part2_2() {
        let map = Map(exampleInput_part2_2)
        let substitutedMap = map.substitutePath()
        let map3x = substitutedMap.scale3()
        
        let expected = [
            Vector2D(x: 2, y: 6),
            Vector2D(x: 3, y: 6),
            Vector2D(x: 6, y: 6),
            Vector2D(x: 7, y: 6)
        ].map { $0 * 3 }
        
        let result = map3x.findEnclosedTiles()
        XCTAssertEqual(result.count, expected.count)
        print(result)
        for coord in expected {
            XCTAssertTrue(result.contains(coord))
        }
    }
    
    func test_map_findEnclosedTiles_with_exampleInput_part2_3() {
        let map = Map(exampleInput_part2_3)
        let map3x = map.scale3()
        let result = map3x.findEnclosedTiles()
        XCTAssertEqual(result.count, 8)
    }
    
    func test_map_findEnclosedTiles_with_exampleInput_part2_4() {
        let map = Map(exampleInput_part2_4)
        let substitutedMap = map.substitutePath()
        let map3x = substitutedMap.scale3()
        let result = map3x.findEnclosedTiles()
        XCTAssertEqual(result.count, 10)
    }
    
    func test_part2() {
        let map = Map(input)
        let substitutedMap = map.substitutePath()
        let map3x = substitutedMap.scale3()
        let result = map3x.findEnclosedTiles()
        XCTAssertEqual(result.count, 407)
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

func printMap(_ map: Map) {
    let rowCount = map.rowCount
    let colCount = map.colCount
    for y in 0 ..< rowCount {
        var row = ""
        for x in 0 ..< colCount {
            let coord = Vector2D(x: x, y: y)
            let tile = map.nodes[coord, default: " "]
            row += String(tile)
        }
        print(row)
    }
}
