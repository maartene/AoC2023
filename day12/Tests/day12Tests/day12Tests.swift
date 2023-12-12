import Foundation
import XCTest
@testable import day12

func pow2(_ exponent: Int) -> Int {
    var result = 1
    for _ in 0 ..< exponent {
        result *= 2
    }
    return result
}

func calculatePermutations(_ inputString: String, continuousGroups: [Int]) throws -> Int {
    
    // naive approach
    
    // calculate all possible strings
    
    let inputArray = inputString.split(separator: "").map { String($0) }
    
    let questionMarkCount = inputArray.filter( { $0 == "?" } ).count
    
    var regexString = "^(\\.*)"
    for i in 0 ..< continuousGroups.count {
        for _ in 0 ..< continuousGroups[i] {
            regexString += "#"
        }
        regexString += i == continuousGroups.count - 1 ? "(\\.*)\\Z" : "(\\.+)"
    }
    // and filter the ones that fit regular expression
    //let regex = try Regex("^(\\.*)#(\\.+)#(\\.+)###(\\.*)")
    //assert(regexString == "^(\\.*)#(\\.+)#(\\.+)###(\\.*)")
    let regex = try Regex(regexString)
    //let result = possibleCases.filter { $0.contains(regex) }
    
    var possibleCases = 0
    for i in 0 ..< pow2(questionMarkCount) {
        var possibleCase = inputArray
        let binaryString = String(String(i, radix: 2).reversed()).padding(toLength: questionMarkCount, withPad: "0", startingAt: 0)
        let binaryStringArray = binaryString.split(separator: "").map { String($0) }
        var qmIndex = 0
        //print(i, binaryString)
        for j in 0 ..< inputArray.count {
            if inputArray[j] == "?" {
                if qmIndex < binaryStringArray.count && binaryStringArray[qmIndex] == "1" {
                    possibleCase[j] = "#"
                } else {
                    possibleCase[j] = "."
                }
                qmIndex += 1
            }
        }
        if possibleCase.joined().contains(regex) {
            possibleCases += 1
        }
    }
    
    //print(possibleCases)
    
//        "???.###",
//        "....###",
//        "#...###",
//        ".#..###",
//        "##..###",
//        "..#.###",
//        "#.#.###",
//        ".##.###",
//        "###.###"
//    ]
    
    // let result = try calculatePermutations("?###????????", continuousGroups: [3,2,1])
    //let compareString = "^(\\.*)###(\\.+)##(\\.+)#(\\.*)\\Z"
    
    
    //print(result)
    return possibleCases
}

func countPermutations(_ input: String) throws -> [Int] {
    let lines = input.split(separator: "\n").map { String($0) }
    
    var result = [Int]()
    for i in 0 ..< lines.count {
        let line = lines[i]
        let lineSplits = line.split(separator: " ").map { String($0) }
        let inputString = lineSplits[0]
        let groups = lineSplits[1].split(separator: ",").compactMap {
            Int(String($0))
        }
        result.append(try calculatePermutations(inputString, continuousGroups: groups))
        print("\(Double(result.count) / Double(lines.count) * 100)%")
    }

    return result
}

func sumCountPermutations(_ input: String) throws -> Int {
    let counts = try countPermutations(input)

    return counts.reduce(0, +)
}

final class day12Tests: XCTestCase {
    let exampleInput =
    """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """
    
    func compareArrayContents(_ result: [String], _ expected: [String]) {
        XCTAssertEqual(result.count, expected.count)
        
        for entry in expected {
            XCTAssertTrue(result.contains(entry))
        }
    }
    
    func test_permutations_forSpecificCase1() throws {
        let result = try calculatePermutations("???.###", continuousGroups: [1,1,3])
        XCTAssertEqual(result, 1)
    }
    
    func test_permutations_withExampleInput() throws {
        let expected = [1,4,1,1,4,10]
        
        let result = try countPermutations(exampleInput)
        XCTAssertEqual(result, expected)
    }
    
    func test_permutations_forSpecificCase3() throws {
        let result = try calculatePermutations("?###????????", continuousGroups: [3,2,1])
        XCTAssertEqual(result, 10)
    }
    
    func test_sumCountPermutations_withExampleInput() throws {
        let result = try sumCountPermutations(exampleInput)
        XCTAssertEqual(result, 21)
    }
    
    func test_part1() throws {
        let result = try sumCountPermutations(input)
        print(result)
        XCTAssertEqual(result, 6981)
    }
    
//    func test_countQuestionMarks() {
//        let lines = input.split(separator: "\n").map { String($0) }
//        let counts = lines.map { line in
//            line.filter({$0 == "?"}).count
//        }
//        let countDict = counts.reduce(into: [Int: Int]()) { (result, count) in
//            if let existingCount = result[count] {
//                result[count] = existingCount + 1
//            } else {
//                result[count] = 1
//            }
//        }
//        print(countDict)
//    }
}
