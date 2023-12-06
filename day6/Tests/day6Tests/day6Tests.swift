import XCTest
@testable import day6

final class day6Tests: XCTestCase {
let exampleInput = 
    """
    Time:      7  15   30
    Distance:  9  40  200
    """

    func test_winningOptions_withSingleExampleInput() {
        let race = Race(time: 7, recordDistance: 9)
        XCTAssertEqual(race.winningOptions, [2,3,4,5])
    }

    func test_winningOptionsCountForRaces() {
        let expected = [4, 8, 9]
        let result = winningOptionsCountForRaces(exampleInput)
        XCTAssertEqual(expected.count, result.count)
        for i in 0 ..< expected.count {
            XCTAssertEqual(result[i], expected[i])
        }
    }

    func test_numberOfWaysToBeatRecord_withExampleInput() {
        XCTAssertEqual(numberOfWaysToBeatRecord(exampleInput), 288)
    }

    func test_part1() {
        let result = numberOfWaysToBeatRecord(input)
        XCTAssertEqual(result, 449550)
    }


    // MARK: Part 2
    func test_test_winningOptions_withLargerInput() {
        let race = Race(time: 71530, recordDistance: 940200)
        XCTAssertEqual(race.winningOptionsCount, 71503)
    }

    func test_interpretInput_part2_withExampleInput() {
        let race = interpretInput_part2(exampleInput)
        XCTAssertEqual(race.time, 71530)
        XCTAssertEqual(race.recordDistance, 940200)
    }

    func test_part2() {
        let race = interpretInput_part2(input)
        print("Race: \(race)")
        let result = race.winningOptionsCount
        XCTAssertEqual(result, 28360140)
    }
}
