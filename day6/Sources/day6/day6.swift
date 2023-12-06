import Foundation

struct Race {
    let time: Int
    let recordDistance: Int

    func distanceForButtonHeldDownTime(_ heldDownTime: Int) -> Int {
        let remainingRaceTime = time - heldDownTime
        return remainingRaceTime * heldDownTime
    }

    var winningOptions: [Int] {
        (0 ..< time)
        .filter { distanceForButtonHeldDownTime($0) > recordDistance }
    }

    var winningOptionsCount: Int {
        winningOptions.count
    }
}

func interpretInput_part1(_ input: String) -> [Race] {
    let lines = input.split(separator: "\n").map { String($0) }
    let raceTimes = lines[0]
        .split(separator: " ")
        .map { String($0) }
        .compactMap { Int($0)} 
    let raceDistances = lines[1]
        .split(separator: " ")
        .map { String($0) }
        .compactMap { Int($0)} 
    
    var races = [Race]()
    for i in 0 ..< raceTimes.count {
      races.append(Race(time: raceTimes[i], recordDistance: raceDistances[i]))
    }

    return races
}

func winningOptionsCountForRaces(_ input: String) -> [Int] {
    let races = interpretInput_part1(input)

    return races.map { $0.winningOptionsCount }
}

func numberOfWaysToBeatRecord(_ input: String) -> Int {
    let optionsCount = winningOptionsCountForRaces(input)
    return optionsCount.reduce(1, *)
}

func interpretInput_part2(_ input: String) -> Race {
    let lines = input.split(separator: "\n").map {String($0) }
    let numbers = lines
    .map {
        $0.filter { $0.isNumber }
    }
    .compactMap { Int($0) }
    
    return Race(time: numbers[0], recordDistance: numbers[1])
}