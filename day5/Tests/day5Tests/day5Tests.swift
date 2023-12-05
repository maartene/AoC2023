import XCTest
@testable import day5

struct Map {
        let destinationRangeStart : Int
        let sourceRangeStart: Int
        let rangeLength: Int

        func sourceIsInRange(_ source: Int) -> Bool {
            source >= sourceRangeStart && source < sourceRangeStart + rangeLength 
        }

        func getDestinationFor(_ source: Int) -> Int {
            if sourceIsInRange(source) {
                let offset = source - sourceRangeStart
                return destinationRangeStart + offset
            } else {
                return source
            }
        }

        init(input: String) {
            let numbers = input.split(seperator: " ")
                .map { String($0) }
                .compactMap { Int($0) }

        }   
    }

func mapSeedToSoil(_ seed: Int, in input: String) -> Int {
    

    let maps = [
        
        Map(destinationRangeStart: 50, sourceRangeStart: 98, rangeLength: 2),
        Map(destinationRangeStart: 52, sourceRangeStart: 50, rangeLength: 48)
    ]

    if let relevantMap = maps.first(where: { $0.sourceIsInRange(seed)} ) {
        return relevantMap.getDestinationFor(seed)
    } 
    return seed
}

func seedToLocation(_ seed: Int, in input: String) -> Int {
    0
}

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
        let expected = [79:82, 14:43, 82:86, 35:35]

        for pair in expected {
            XCTAssertEqual(seedToLocation(pair.key, in: exampleInput), pair.value)
        }
        
    }
}
