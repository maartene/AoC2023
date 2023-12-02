import Foundation

struct Game {
    static let COLORS = ["red", "green", "blue"]
    let id: Int
    let attempts: [[String: Int]]
    
    init(_ input: String) {
        let gameStoneSplits = input.split(separator: ":")
        id = Int(String(gameStoneSplits[0].dropFirst(5)))!
        
        let attemptStrings = String(gameStoneSplits[1]).split(separator: ";")
        
        var attempts = [[String: Int]]()
        for attemptString in attemptStrings {
            let stoneStrings = String(attemptString).split(separator: ",")
            attempts.append([:])
            for stoneString in stoneStrings {
                let stoneComboString = String(stoneString).split(separator: " ")
                let numberString = String(stoneComboString[0])
                attempts[attempts.count - 1][String(stoneComboString[1])] = Int(numberString)
            }
        }
        
        self.attempts = attempts
    }

    func gameIsPossible(with cubeSet: [String: Int]) -> Bool {
        for attempt in attempts {
            for cubeCombo in attempt {
                guard let count = cubeSet[cubeCombo.key] else {
                    return false
                }
                
                guard count >= cubeCombo.value else {
                    return false
                }
            }
        }
        
        return true
    }
    
    var minimumCubeSet: [String: Int] {
        var result = [String: Int]()
        for color in Self.COLORS {
            let attemptColors = attempts.compactMap { $0[color] }
            if let minColor = attemptColors.max() {
                result[color] = minColor
            }
        }
        return result
    }
    
    var minimalCubeSetPower: Int {
        minimumCubeSet
            .map {$0.value}
            .reduce(1, *)
    }
}

func sumPossibleIDs(input: String, cubeSet: [String: Int]) -> Int {
    let games = input.split(separator: "\n")
        .map { Game(String($0)) }
    
    let possibleGames = games.filter {
        $0.gameIsPossible(with: cubeSet)
    }
    
    return possibleGames
        .map { $0.id }
        .reduce(0, +)
}

func sumCubeSetPowers(input: String, cubeSet: [String: Int]) -> Int {
    let games = input.split(separator: "\n")
        .map { Game(String($0)) }
    
    return games
        .map { $0.minimalCubeSetPower }
        .reduce(0, +)
}
