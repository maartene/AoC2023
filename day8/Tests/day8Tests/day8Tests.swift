import XCTest
@testable import day8

final class day8Tests: XCTestCase {
    let exampleInput =
    """
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """
    
    let exampleInput2 =
    """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """
    
    func test_createStepEntry() {
        let input = " (BBB, CCC)"
        
        let stepEntry = StepEntry(input)
        
        XCTAssertEqual(stepEntry.left, "BBB")
        XCTAssertEqual(stepEntry.right, "CCC")
    }
        
    func test_stepsToReachZZZ_withExampleInput() {
        let result = stepsToReachZZZ(exampleInput)
        
        XCTAssertEqual(result, 2)
    }
    
    func test_stepsToReachZZZ_withExampleInput2() {
        let result = stepsToReachZZZ(exampleInput2)
        
        XCTAssertEqual(result, 6)
    }
    
    func test_part1() {
        let result = stepsToReachZZZ(input)
        XCTAssertEqual(result, 11567)
    }
    
    // MARK: Part 2
    
    let exampleInput_part2 =
    """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """
    
    func test_stepsToReachZZZ_withExampleInputPart2() {
        let result = ghostly_stepsToReachZZZ(exampleInput_part2)
        
        XCTAssertEqual(result, 6)
    }
    
    func test_part2() {
        let result = ghostly_stepsToReachZZZ(input)
        print(result)
        XCTAssertEqual(result, 9_858_474_970_153)
    }
}
