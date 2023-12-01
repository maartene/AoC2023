import XCTest
@testable import day1

final class day1Tests: XCTestCase {

    let example = 
    """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    let advancedExample = 
    """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    func test_example_lines() {
        let expectedResults = [12, 38, 15, 77]
        let lines = example.split(separator: "\n").map { String($0) }
        for i in 0 ..< lines.count {
            XCTAssertEqual(calculateCalibrationFactorForLine(lines[i]), expectedResults[i])
        }
    }

    func test_example() {
        XCTAssertEqual(calculateCalibrationFactor(example), 142)
    }

    func test_advancedExample_lines() {
        let expectedResults = [29, 83, 13, 24, 42, 14, 76]
        let lines = advancedExample.split(separator: "\n").map { String($0) }
        XCTAssertEqual(lines.count, expectedResults.count)

        for i in 0 ..< expectedResults.count {
            XCTAssertEqual(calculateCalibrationFactorForLine(lines[i]), expectedResults[i])
        }
    }

    func test_advancedExample() {
        XCTAssertEqual(calculateCalibrationFactor(advancedExample), 281)
    }

    func test_output() {
        XCTAssertEqual(calculateCalibrationFactor(input), 54203)
    }
}
