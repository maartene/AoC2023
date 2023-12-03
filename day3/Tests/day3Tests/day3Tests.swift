import XCTest
@testable import day3

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
