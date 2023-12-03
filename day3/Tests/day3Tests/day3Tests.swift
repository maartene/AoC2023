import XCTest
@testable import day3

typealias Coord = (x: Int, y: Int)

struct PartNumber {
    let value: Int
    let start: Coord
    let end: Coord
}

func getAllNumbers(_ input: String) -> [PartNumber] {
    let characterArray = input.split(separator: "\n")
        .map { String($0) }
        .map { line in
        line.split(separator: "")
            .map { String($0) }
            .map { Character($0) }
    }
    
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
    
    let characterArray = input.split(separator: "\n")
        .map { String($0) }
        .map { line in
        line.split(separator: "")
            .map { String($0) }
            .map { Character($0) }
    }
    
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
    
    if numbersAroundGear.count != 2 {
        fatalError("Really?")
    }
    
    return numbersAroundGear[0].value * numbersAroundGear[1].value
}

func getGearRatios(_ input: String) -> [Int] {
    let numbers = getAllNumbers(input)
    
    let characterArray = input.split(separator: "\n")
        .map { String($0) }
        .map { line in
        line.split(separator: "")
            .map { String($0) }
            .map { Character($0) }
    }
    
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

final class day3Tests: XCTestCase {
    let exampleInput =
    """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
        
    // MARK: Part 1
    func test_calculateMissingEnginePart_withExampleInput() {
        XCTAssertEqual(calculateMissingEnginePart(exampleInput), 4361)
    }
    
    func test_getAllNumbers() {
        let expectedNumbers = [467, 114, 35, 633, 617, 58, 592, 755, 664, 598].sorted()
        let foundNumbers = getAllNumbers(exampleInput).map { $0.value }
            .sorted()
        XCTAssertEqual(foundNumbers, expectedNumbers)
    }
    
    func test_numbersThatArePartNumbers_withExampleInput() {
        let expectedNumbersThatArePartNumbers = [467,35, 633, 617, 592, 755, 664, 598].sorted()
        let partNumbers = numbersThatArePartNumbers(exampleInput)
            .map { $0.value }
            .sorted()
        XCTAssertEqual(partNumbers, expectedNumbersThatArePartNumbers)
        
    }
    
    let exampleInput2 =
    """
    ................................................965..583........389.................307.................512......................395.....387
    ........................#....374...382....250...*..........737*....*896.395...........*....................$.........................#......
    ..494.........532-...474......*.......#....*...................522......*..........%...........................%...+................269.....
    .....*..#................506..143........375......77.....155...........400.518...64....773...718..797........694....972.603.....*...........
    ....479.795...............*..........800...........*.$.......264*636.......@..............&..*...*.......499...............*...5.20.........
    """
    
    func test_numbersThatArePartNumbers_withExampleInput2() {
        let expectedNumbersThatArePartNumbers = [965, 389, 307, 512, 374, 382, 250, 737, 896, 395, 494, 532, 474, 522, 269, 506, 143, 375, 77, 400, 518, 64, 773, 718, 797, 694, 972, 603, 479, 795, 264, 636, 5, 20].sorted()
        let partNumbers = numbersThatArePartNumbers(exampleInput2)
            .map { $0.value }
            .sorted()
        XCTAssertEqual(partNumbers, expectedNumbersThatArePartNumbers)
    }
    
    func test_part1() {
        let missingPartNumber = calculateMissingEnginePart(input)
        print(missingPartNumber)
        XCTAssertEqual(missingPartNumber, 539713)
    }
    
    // MARK: Part 2
    func test_gearRatios_withExampleInput() {
        let expectedGearRatios = [16345, 451490].sorted()
        XCTAssertEqual(getGearRatios(exampleInput).sorted(), expectedGearRatios)
    }
    
    func test_calculateGearRatio_withExampleInput() {
        let gearRatio = calculateGearRatio(exampleInput) 
        XCTAssertEqual(gearRatio, 467835)
    }
    
    func test_part2() {
        let gearRatio = calculateGearRatio(input)
        XCTAssertEqual(gearRatio, 84159075)
    }
}
