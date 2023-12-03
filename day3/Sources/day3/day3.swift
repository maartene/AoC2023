import Foundation

typealias Coord = (x: Int, y: Int)

struct PartNumber {
    let value: Int
    let start: Coord
    let end: Coord
}

func toCharacterArray(_ input: String) -> [[Character]] {
    input.split(separator: "\n")
        .map { String($0) }
        .map { line in
        line.split(separator: "")
            .map { String($0) }
            .map { Character($0) }
    }
}

func getAllNumbers(_ input: String) -> [PartNumber] {
    let characterArray = toCharacterArray(input)
    
    var numbers = [PartNumber]()
    
    var y = 0
    while y < characterArray.count {
        var x = 0
        while x  < characterArray[y].count {
            var numberString = ""
            var dx = 0
            while x + dx < characterArray[y].count && characterArray[y][x + dx].isNumber {
                numberString += String(characterArray[y][x + dx])
                dx += 1
            }
            if let number = Int(numberString) {
                let partNumber = PartNumber(value: number, start: (x, y), end: (x + dx, y))
                print(partNumber)
                numbers.append(partNumber)
                
            }
            x += max(1, dx)
        }
        y += 1
    }
    
    return numbers
}

// MARK: Part 1
func calculateMissingEnginePart(_ input: String) -> Int {
    let partNumbers = numbersThatArePartNumbers(input).map { $0.value }
    return partNumbers.reduce(0, +)
}


func numbersThatArePartNumbers(_ input: String) -> [PartNumber] {
    func matchNumber(number: PartNumber, in inputMap: [[Character]]) -> Bool {
        for y in number.start.y - 1 ... number.end.y + 1 {
            for x in number.start.x - 1 ... number.end.x {
                if y >= 0 && y < inputMap.count && x >= 0 && x < inputMap[y].count && inputMap[y][x].isNumber == false && inputMap[y][x] != "." {
                    // Its a symbol!
                    return true
                }
            }
        }
                
        return false
    }
    
    let characterArray = toCharacterArray(input)
    
    let numbers = getAllNumbers(input)
    
    let partNumbers = numbers.filter { matchNumber(number: $0, in: characterArray) }
    return Array(partNumbers)
}

// MARK: Part 2
func gearRatio(_ gear: Coord, with numbers: [PartNumber]) -> Int? {
    let numbersAroundGear = numbers.filter { number in
        gear.x >= number.start.x - 1 && gear.x <= number.end.x && gear.y >= number.start.y - 1 && gear.y <= number.end.y + 1
    }
    
    guard numbersAroundGear.count > 1 else {
        return nil
    }
        
    return numbersAroundGear[0].value * numbersAroundGear[1].value
}

func getGearRatios(_ input: String) -> [Int] {
    let numbers = getAllNumbers(input)
    
    let characterArray = toCharacterArray(input)
    
    var gears = [Coord]()
    for y in 0 ..< characterArray.count {
        for x in 0 ..< characterArray[y].count {
            if characterArray[y][x] == "*" {
                gears.append((x,y))
            }
        }
    }
    
    return gears.compactMap { gearRatio($0, with: numbers) }
}

func calculateGearRatio(_ input: String) -> Int {
    let gearRatios = getGearRatios(input)
    return gearRatios.reduce(0, +)
}
