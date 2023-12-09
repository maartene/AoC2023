import XCTest
@testable import day9

final class day9Tests: XCTestCase {
    let exampleInput =
    """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """
    
    func test_differences_03691215() {
        let sequence = [0,3,6,9,12,15]
        let expected = [3,3,3,3,3]
        
        let result = differences(sequence)
        
        XCTAssertEqual(result, expected)
    }
    
    func test_differences_136101521() {
        let sequence = [1,3, 6, 10, 15, 21]
        let expected = [2,3,4,5,6]
        
        let result = differences(sequence)
        
        XCTAssertEqual(result, expected)
    }
    
    func test_predictNext_03691215() {
        let sequence = [0,3,6,9,12,15]
        
        let result = predictNext(sequence)
        
        XCTAssertEqual(result, 18)
    }
    
    func test_predictNext_136101521() {
        let sequence = [1,3, 6, 10, 15, 21]
        
        let result = predictNext(sequence)
        
        XCTAssertEqual(result, 28)
    }
    
    func test_predictNext_101316213045() {
        let sequence = [10, 13, 16, 21, 30, 45]
        
        let result = predictNext(sequence)
        
        XCTAssertEqual(result, 68)
    }
    
    func test_sumPredictedNumbers_forExampleInput() {
        let result = sumPredictedNumbers(exampleInput)
        XCTAssertEqual(result, 114)
    }
    
    func test_part1() {
        let result = sumPredictedNumbers(input)
        XCTAssertEqual(result, 1972648895)
    }
    
    // MARK: Part 2
    func test_predictPrevious_forExampleInput() {
        let input = [
            [0,3,6,9,12,15],
            [1,3, 6, 10, 15, 21],
            [10, 13, 16, 21, 30, 45]
        ]
        
        let expected = [-3,0,5]
        let result = input.map { predictPrevious($0) }
        XCTAssertEqual(result, expected)
    }
    
    func test_sumPredictedPreviousNumbers_forExampleInput() {
        let result = sumPredictedPreviousNumbers(exampleInput)
        XCTAssertEqual(result, 2)
    }
    
    func test_part2() {
        let result = sumPredictedPreviousNumbers(input)
        XCTAssertEqual(result, 919)
    }
}
