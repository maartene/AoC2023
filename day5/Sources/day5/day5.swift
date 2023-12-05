import Foundation

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

        init?(input: String) {
            let numbers = input.split(separator: " ")
                .map { String($0) }
                .compactMap { Int($0) }
            
            guard numbers.count == 3 else {
                return nil
            }
            
            destinationRangeStart = numbers[0]
            sourceRangeStart = numbers[1]
            rangeLength = numbers[2]

        }
    }

func mapSeedToSoil(_ seed: Int, in input: String) -> Int {
    let maps = input
        .split(separator: "\n")
        .map { String($0) }
        .compactMap { Map(input: $0) }

    if let relevantMap = maps.first(where: { $0.sourceIsInRange(seed)} ) {
        return relevantMap.getDestinationFor(seed)
    }
    return seed
}

func seedToLocation(_ seed: Int, in input: String) -> Int {
    func valueInMap(_ input: Int, in maps: [Map]) -> Int {
        if let relevantMap = maps.first(where: { $0.sourceIsInRange(input)} ) {
            return relevantMap.getDestinationFor(input)
        }
        return input
    }
    
    
    let lines = input
        .split(separator: "\n")
        .map { String($0) }
    
    
    var maps = [String: [Map]]()
    
    let mapNames = [
        "seed-to-soil map:",
        "soil-to-fertilizer map:",
        "fertilizer-to-water map:",
        "water-to-light map:",
        "light-to-temperature map:",
        "temperature-to-humidity map:",
        "humidity-to-location map:"
    ]
    
    for mapName in mapNames {
        var index = lines.firstIndex(of: mapName)! + 1
        var mapsOfType = [Map]()
        while index < lines.count, let mapToAdd = Map(input: lines[index]) {
            mapsOfType.append(mapToAdd)
            index += 1
        }
        maps[mapName] = mapsOfType
        //print(mapName, mapsOfType)
    }
    
    let seedToSoilMaps = maps["seed-to-soil map:"]!
    let soilToFertilizerMaps = maps["soil-to-fertilizer map:"]!
    let fertilizerToWaterMaps = maps["fertilizer-to-water map:"]!
    let waterToLightMaps = maps["water-to-light map:"]!
    let lightToTemperatureMaps = maps["light-to-temperature map:"]!
    let temperatureToHumidityMaps = maps["temperature-to-humidity map:"]!
    let humidityToLocationMaps = maps["humidity-to-location map:"]!
    
    let seedToSoil = valueInMap(seed, in: seedToSoilMaps)
    let soilToFertilizer = valueInMap(seedToSoil, in: soilToFertilizerMaps)
    let fertilizerToWater = valueInMap(soilToFertilizer, in: fertilizerToWaterMaps)
    let waterToLight = valueInMap(fertilizerToWater, in: waterToLightMaps)
    let lightToTemperature = valueInMap(waterToLight, in: lightToTemperatureMaps)
    let temperatureToHumidity = valueInMap(lightToTemperature, in: temperatureToHumidityMaps)
    return valueInMap(temperatureToHumidity, in: humidityToLocationMaps)
}

func calculateLowestLocation(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { String($0) }
    let seedLine = lines[0]
    let seedSplit = seedLine.split(separator: ":").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines)}
    let seeds = seedSplit[1]
        .split(separator: " ")
        .compactMap { Int(String($0)) }
    
    print("seeds: \(seeds)")
    
    let locations = seeds.map {
        seedToLocation($0, in: input)
    }
    
    return locations.min()!
}

func calculateLowestLocation_part2(_ input: String) -> Int {
    let lines = input.split(separator: "\n").map { String($0) }
    let seedLine = lines[0]
    let seedSplit = seedLine.split(separator: ":").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines)}
    let seedValues = seedSplit[1]
        .split(separator: " ")
        .compactMap { Int(String($0)) }
    
    // with some help from https://github.com/seankit/aoc-2023/blob/main/Sources/Day05.swift#L17
    var seedRanges: [Range<Int>] = []
    for i in stride(from: 0, to: seedValues.count, by: 2) {
        let range = seedValues[i]..<seedValues[i]+seedValues[i+1]
        seedRanges.append(range)
    }
    
    var best: Int = .max
    for range in seedRanges {
        var left = range.lowerBound
        var right = range.upperBound
        
        var lowest: Int = .max
        while left < right {
            let seed = (left + right) / 2
            let site = seedToLocation(seed, in: input)
            if site < lowest {
                lowest = site
                right = seed - 1
            } else {
                left = seed + 1
            }
        }
        best = min(best, lowest)
    }
    return best
}
