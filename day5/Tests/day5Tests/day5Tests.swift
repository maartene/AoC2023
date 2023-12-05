import XCTest
@testable import day5

final class day5Tests: XCTestCase {
    let exampleInput = 
    """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    func test_seedToSoilMap() {
        let input = 
        """
        50 98 2
        52 50 48
        """

        let expected = 
        [0:0, 1:1, 48:48, 49:49, 50:52, 51:53, 96:98, 97:99, 98:50, 99:51, 79:81, 14:14, 55:57, 13:13]

        for pair in expected {
            XCTAssertEqual(mapSeedToSoil(pair.key, in: input), pair.value)
        }
    }

    func test_seedToLocationMap() {
        let expected = [79:82, 14:43, 55:86, 13:35]

        for pair in expected {
            XCTAssertEqual(seedToLocation(pair.key, in: exampleInput), pair.value)
        }
        
    }
    
    func test_calculateLowestLocation() {
        XCTAssertEqual(calculateLowestLocation(exampleInput), 35)
    }
    
    func test_part1() {
        let result = calculateLowestLocation(input)
        print(result)
    }
    
    // MARK: Part 2
    func test_calculateLowestLocation_part2() {
        XCTAssertEqual(calculateLowestLocation_part2(exampleInput), 46)
    }
    
    func test_part2() {
        let result = calculateLowestLocation_part2(input)
        print(result)
    }
}
