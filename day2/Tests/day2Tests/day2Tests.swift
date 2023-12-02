import XCTest
@testable import day2

final class day2Tests: XCTestCase {
    // MARK: Fixtures
    let exampleInput = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    let exampleCubeSet = [
        "red": 12,
        "green": 13,
        "blue": 14
    ]

    // MARK: Part 1
    func test_createGame() {
        let inputString = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
        let game = Game(inputString)

        XCTAssertEqual(game.id, 1)
        XCTAssertEqual(game.attempts[0]["red"], 4)
        XCTAssertEqual(game.attempts[0]["blue"], 3)
        XCTAssertEqual(game.attempts[1]["red"], 1)
        XCTAssertEqual(game.attempts[1]["blue"], 6)
        XCTAssertEqual(game.attempts[1]["green"], 2)
        XCTAssertEqual(game.attempts[2]["green"], 2)
    }

     func test_gameIsPossible() throws {
         let expected = [true, true, false, false, true]
         
         let games = exampleInput.split(separator: "\n")
             .map { Game(String($0))}
        
         XCTAssertEqual(games.count, expected.count)
         
         for i in 0 ..< expected.count {
             XCTAssertEqual(games[i].gameIsPossible(with: exampleCubeSet), expected[i])
         }
        
     }
    
    func test_sumPossibleIDs() {
        XCTAssertEqual(sumPossibleIDs(input: exampleInput, cubeSet: exampleCubeSet), 8)
    }
    
    func test_part1() {
        let sum = sumPossibleIDs(input: input, cubeSet: cubeSet)
        XCTAssertEqual(sum, 2149)
    }
    
    // MARK: Part 2
    func test_minimalCubeSet() {
        let expectedCubeSets = [
            ["red": 4, "green": 2, "blue": 6],
            ["red": 1, "green": 3, "blue": 4],
            ["red": 20, "green": 13, "blue": 6],
            ["red": 14, "green": 3, "blue": 15],
            ["red": 6, "green": 3, "blue": 2],
        ]
        
        let games = exampleInput.split(separator: "\n")
            .map { Game(String($0))}
       
        XCTAssertEqual(games.count, expectedCubeSets.count)
        
        for i in 0 ..< games.count {
            let game = games[i]
            let expectedCubeSet = expectedCubeSets[i]
            for color in Game.COLORS {
                XCTAssertEqual(game.minimumCubeSet[color], expectedCubeSet[color])
            }
        }
    }
    
    func test_minimalCubeSetPower() {
        let expected = [48, 12, 1560, 630, 36]
        
        let games = exampleInput.split(separator: "\n")
            .map { Game(String($0))}
       
        XCTAssertEqual(games.count, expected.count)
        
        for i in 0 ..< games.count {
            XCTAssertEqual(games[i].minimalCubeSetPower, expected[i])
        }
        
    }
    
    func test_part2() {
        let sum = sumCubeSetPowers(input: input, cubeSet: cubeSet)
        XCTAssertEqual(sum, 71274)
    }
    
}
