import XCTest
import Collections
@testable import day15

final class day15Tests: XCTestCase {
    let exampleInput =
    """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
    
    lazy var exampleCommandStrings = exampleInput.split(separator: ",").map { String($0) }
    
    func test_sumNumbers() {
        let input = [30, 253, 97, 47, 14, 180, 9, 197, 48, 214, 231]
        
        XCTAssertEqual(sumNumbers(input), 1320)
    }
    
    func test_asciiHash_HASH() {
        XCTAssertEqual(asciiHash("HASH"), 52)
    }
    
    func test_hashString_withExampleInput() {
        let result = hashString(exampleInput)
        XCTAssertEqual(result, 1320)
    }
    
    func test_part1() {
        let result = hashString(input)
        print(result)
        XCTAssertEqual(result, 520500)
    }
    
    // Part 2
    func test_lensBoxContainer_interpretCommand_rn_eq_1() {
        let container = LensBoxContainer()
        container.interpret("rn=1")
        XCTAssertEqual(container.boxes[0]["rn"], 1)
    }
    
    func test_lensBoxContainer_interpretFirstTwoCommands_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings[0..<2])
        XCTAssertEqual(container.boxes[0]["rn"], 1)
        XCTAssertFalse(container.boxes[0].contains(where: { $0.key == "cm"} ))
    }
    
    func test_lensBoxContainer_interpretFirstThreeCommands_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings[0..<3])
        XCTAssertEqual(container.boxes[0]["rn"], 1)
        XCTAssertEqual(container.boxes[1]["qp"], 3)
    }
    
    func test_lensBoxContainer_interpretFirstFourCommands_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings[0..<4])
        let expected_box0: OrderedDictionary = ["rn": 1, "cm": 2]
        XCTAssertEqual(container.boxes[0], expected_box0)
        XCTAssertEqual(container.boxes[1]["qp"], 3)
    }
    
    // After "qp-":
    func test_lensBoxContainer_interpretFirstFiveCommands_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings[0..<5])
        let expected_box0: OrderedDictionary = ["rn": 1, "cm": 2]
        XCTAssertEqual(container.boxes[0], expected_box0)
        XCTAssertEqual(container.boxes[1], [:])
    }
    
    // After "pc=4":
    func test_lensBoxContainer_interpretFirst6Commands_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings[0..<6])
        let expected_box0: OrderedDictionary = ["rn": 1, "cm": 2]
        XCTAssertEqual(container.boxes[0], expected_box0)
        XCTAssertEqual(container.boxes[3]["pc"], 4)
    }
    
    // after all commands
    func test_lensBoxContainer_interpret_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings)
        let expected_box0: OrderedDictionary = ["rn": 1, "cm": 2]
        let expected_box3: OrderedDictionary = ["ot": 7, "ab": 5, "pc": 6]
        XCTAssertEqual(container.boxes[0], expected_box0)
        XCTAssertEqual(container.boxes[3], expected_box3)
    }
    
    func test_calculateFocusPower_withExampleInput() {
        let expected = [
            "rn": 1,
            "cm": 4,
            "ot": 28,
            "ab": 40,
            "pc": 72
        ]
        
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings)
        
        let result = expected.reduce(into: [:]) {
            $0[$1.key] = container.getLensPower($1.key)
        }
        
        XCTAssertEqual(result.count, expected.count)
        
        for expect in expected {
            XCTAssertEqual(result[expect.key], expect.value)
        }
    }
    
    func test_totalFocalPower_withExampleInput() {
        let container = LensBoxContainer()
        container.interpret(exampleCommandStrings)
        XCTAssertEqual(container.totalFocalPower, 145)
    }
    
    func test_part2() {
        let commands = input.split(separator: ",").map { String($0) }
        let container = LensBoxContainer()
        container.interpret(commands)
        print(container.totalFocalPower)
    }
}
