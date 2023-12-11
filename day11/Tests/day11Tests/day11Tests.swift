import XCTest
@testable import day11

final class day11Tests: XCTestCase {
    let exampleInput =
    """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """
    
    func test_compare_universes() {
        let universe = Universe(exampleInput)
        XCTAssertEqual(universe.description, exampleInput)
    }

    func test_universe_findGalaxies() {
        let universe = Universe(exampleInput)
        let expectedGalaxies = [
            1: Vector2D(x: 3, y: 0), 
            2: Vector2D(x: 7, y: 1), 
            3: Vector2D(x: 0, y: 2), 
            4: Vector2D(x: 6, y: 4), 
            5: Vector2D(x: 1, y: 5),
            6: Vector2D(x: 9, y: 6), 
            7: Vector2D(x: 7, y: 8), 
            8: Vector2D(x: 0, y: 9), 
            9: Vector2D(x: 4, y: 9), 
        ]
        
        XCTAssertEqual(universe.galaxies.count, expectedGalaxies.count)
        for (key, value) in expectedGalaxies {
            XCTAssertEqual(universe.galaxies[key], value)
        }
    }
    
    func test_universe_rowsToExpand() {
        let universe = Universe(exampleInput)
        
        XCTAssertEqual(universe.rowsToExpand.sorted(), [3,7])
    }
    
    func test_universe_colsToExpand() {
        let universe = Universe(exampleInput)
        
        XCTAssertEqual(universe.colsToExpand.sorted(), [2,5,8])
    }
    
    func test_universe_shortestPathLengthBetweenGalaxies() {
        struct Pair: Hashable {
            let from: Int
            let to: Int
            
            init(_ from: Int, _ to: Int) {
                self.from = from
                self.to = to
            }
        }
        
        let universe = Universe(exampleInput)
        
        let expected = [
            Pair(1, 7): 15,
            Pair(3, 6): 17,
            Pair(8, 9): 5
        ]
        
        for entry in expected {
            XCTAssertEqual(universe.findShortestPathLength(from: entry.key.from, to: [entry.key.to], expandMultiplier: 2), [entry.value])
        }
    }
    
    func test_universe_shortestPathBetweenAllGalaxies() {
        let universe = Universe(exampleInput)
        XCTAssertEqual(universe.sumOfShortestPathsBetweenAllGalaxies(expandMultiplier: 2), 374)
    }
    
    func test_part1() {
        let universe = Universe(input)
        let result = universe.sumOfShortestPathsBetweenAllGalaxies(expandMultiplier: 2)
        XCTAssertEqual(result, 10165598)
    }
    
    // MARK: Part 2    
    func test_universe_sumOfShortestPathsBetweenAllGalaxies_part2_withMultiplier10() {
        let universe = Universe(exampleInput)
        
        XCTAssertEqual(universe.sumOfShortestPathsBetweenAllGalaxies(expandMultiplier: 10), 1030)
    }
    
    func test_universe_sumOfShortestPathsBetweenAllGalaxies_part2_withMultiplier100() {
        let universe = Universe(exampleInput)
        
        XCTAssertEqual(universe.sumOfShortestPathsBetweenAllGalaxies(expandMultiplier: 100), 8410)
    }
    
    func test_part2() {
        let universe = Universe(input)
        let result = universe.sumOfShortestPathsBetweenAllGalaxies(expandMultiplier: 1_000_000)
        XCTAssertEqual(result, 678728808158)
    }
}
