import Foundation
import XCTest
@testable import day12

struct Entry: Hashable {
    let string: String
    let nums: [Int]
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
    
    func disable_test_part1() throws {
        let result = try sumCountPermutations(input)
        print(result)
        XCTAssertEqual(result, 6981)
    }
    
    // MARK: Part 2
    func test_otherApproach_withExampleInput() {
        let expected = [1,4,1,1,4,10]
        
        let lines = exampleInput.split(separator: "\n").map { String($0) }
        
        var result = [Int]()
        for i in 0 ..< lines.count {
            let line = lines[i]
            let lineSplits = line.split(separator: " ").map { String($0) }
            let inputString = lineSplits[0]
            let groups = lineSplits[1].split(separator: ",").compactMap {
                Int(String($0))
            }
            result.append(countArrangements2(line: inputString, counts: groups))
            print("\(Double(result.count) / Double(lines.count) * 100)%")
        }
        
        XCTAssertEqual(result, expected)
    }
    
    func test_otherApproach_part1() {
        let lines = input.split(separator: "\n").map { String($0) }
        
        var result = [Int]()
        for i in 0 ..< lines.count {
            let line = lines[i]
            let lineSplits = line.split(separator: " ").map { String($0) }
            let inputString = lineSplits[0]
            let groups = lineSplits[1].split(separator: ",").compactMap {
                Int(String($0))
            }
            result.append(countArrangements2(line: inputString, counts: groups))
            print("\(Double(result.count) / Double(lines.count) * 100)%")
        }
        
        XCTAssertEqual(result.reduce(0, +), 6981)
    }
    
    func test_part2_withExampleInput() {
        let lines = exampleInput.split(separator: "\n").map { String($0) }
        
        var result = [Int]()
        for i in 0 ..< lines.count {
            let line = lines[i]
            let lineSplits = line.split(separator: " ").map { String($0) }
            let inputString = (0 ..< 5).map { _ in lineSplits[0] }
                .joined(separator: "?")
            
            let group = lineSplits[1].split(separator: ",").compactMap {
                Int(String($0))
            }
            let groups = (0 ..< 5).flatMap { _ in group }
            
            result.append(countArrangements2(line: inputString, counts: groups))
            print("\(Double(result.count) / Double(lines.count) * 100)%")
        }
        
        XCTAssertEqual(result.reduce(0, +), 525152)
    }
    
    func test_part2() {
        let lines = input.split(separator: "\n").map { String($0) }
        
        var result = [Int]()
        for i in 0 ..< lines.count {
            let line = lines[i]
            let lineSplits = line.split(separator: " ").map { String($0) }
            let inputString = (0 ..< 5).map { _ in lineSplits[0] }
                .joined(separator: "?")
            
            let group = lineSplits[1].split(separator: ",").compactMap {
                Int(String($0))
            }
            let groups = (0 ..< 5).flatMap { _ in group }
            
            result.append(countArrangements2(line: inputString, counts: groups))
            print("\(Double(result.count) / Double(lines.count) * 100)%")
        }
        
        XCTAssertEqual(result.reduce(0, +), 4546215031609)
    }
}
