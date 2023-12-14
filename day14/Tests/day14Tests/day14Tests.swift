import XCTest
@testable import day14

final class day14Tests: XCTestCase {
    let exampleInput =
    """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    
    let tiltedNorthExample =
    """
    OOOO.#.O..
    OO..#....#
    OO..O##..O
    O..#.OO...
    ........#.
    ..#....#.#
    ..O..#.O.O
    ..O.......
    #....###..
    #....#....
    """
    
    lazy var exampleInputMatrix = createMatrix(exampleInput)
    
    lazy var tiltedNorthExampleMatrix = createMatrix(tiltedNorthExample)
    
    
    
    func test_calculateTotalNorthLoad_with_tiltedNorthExample() {
        let result = calculateTotalNorthLoad(tiltedNorthExampleMatrix)
        XCTAssertEqual(result, 136)
    }
    
    func test_tiltNorthColumn_withExampleInput_col1() {
        let column: [Character] = [".", ".", ".", "O", "O", ".", ".", ".", ".", "O"]
        let expected: [Character] = ["O", "O", "O", ".", ".", ".", ".", ".", ".", "."]
        let result = tiltNorthColumn(column)
        XCTAssertEqual(result, expected)
    }
    
    func test_tiltNorthColumn_withExampleInput_col8() {
        let column: [Character] = [".", ".", ".", ".", "O", "#", ".", "O", "#", "."]
        let expected: [Character] = ["O", ".", ".", ".", ".", "#", "O", ".", "#", "."]
        let result = tiltNorthColumn(column)
        XCTAssertEqual(result, expected)
    }
    
    func test_tileNorth_withExampleInput() {
        let result = tiltNorth(exampleInputMatrix)
        XCTAssertEqual(result, tiltedNorthExampleMatrix)
    }
    
    func test_calculateTotalNorthLoad_with_exampleInput() {
        let tiltedNorth = tiltNorth(exampleInputMatrix)
        let result = calculateTotalNorthLoad(tiltedNorth)
        XCTAssertEqual(result, 136)
    }
    
    func test_part1() {
        let matrix = createMatrix(input)
        let tiltedMatrix = tiltNorth(matrix)
        let result = calculateTotalNorthLoad(tiltedMatrix)
        XCTAssertEqual(result, 103333)
    }
    
    
    // MARK: Part 2
    func test_squareMatrix_withExampleInput() {
        let height = exampleInputMatrix.count
        let width = exampleInputMatrix.first?.count ?? 0
        XCTAssertEqual(width, height)
    }
    
    func test_squareMatrix_withInput() {
        let matrix = createMatrix(input)
        let height = matrix.count
        let width = matrix.first?.count ?? 0
        XCTAssertEqual(width, height)
    }
    
    func test_rotateMatrix_withSimpleMatrix() {
        let matrix: [[Character]] = [
            ["1","2"],
            ["3","4"]
        ]
        
        let expected: [[Character]] = [
            ["3", "1"],
            ["4", "2"]
        ]
        
        XCTAssertEqual(rotateMatrixCW(matrix), expected)
    }
    
    let expectedAfterOneCycle =
    """
    .....#....
    ....#...O#
    ...OO##...
    .OO#......
    .....OOO#.
    .O#...O#.#
    ....O#....
    ......OOOO
    #...O###..
    #..OO#....
    """
    
    let expectedAfterTwoCycles =
    """
    .....#....
    ....#...O#
    .....##...
    ..O#......
    .....OOO#.
    .O#...O#.#
    ....O#...O
    .......OOO
    #..OO###..
    #.OOO#...O
    """
    
    let expectedAfterThreeCycles =
    """
    .....#....
    ....#...O#
    .....##...
    ..O#......
    .....OOO#.
    .O#...O#.#
    ....O#...O
    .......OOO
    #...O###.O
    #.OOO#...O
    """
    
    func test_cycleMatrix_withExampleMatrix_once() {
        let expected = createMatrix(expectedAfterOneCycle)
        let result = cycleMatrix(exampleInputMatrix)
        XCTAssertEqual(result, expected)
    }
    
    func test_cycleMatrix_withExampleMatrix_twice() {
        let expected = createMatrix(expectedAfterTwoCycles)
        var result = exampleInputMatrix
        for _ in 0 ..< 2 {
            result = cycleMatrix(result)
        }
        XCTAssertEqual(result, expected)
    }
    
    func test_cycleMatrix_withExampleMatrix_trice() {
        let expected = createMatrix(expectedAfterThreeCycles)
        var result = exampleInputMatrix
        for _ in 0 ..< 3 {
            result = cycleMatrix(result)
        }
        XCTAssertEqual(result, expected)
    }
    
    func test_calculateNorthLoad_whenCycling_forExampleInput() {
        let matrix = cycleMany(exampleInputMatrix, count: 1_000_000_000)
        let result = calculateTotalNorthLoad(matrix)
        XCTAssertEqual(result, 64)
    }
    
    func test_part2() {
        let matrix = createMatrix(input)
        let cycledMatrix = cycleMany(matrix, count: 1_000_000_000)
        let result = calculateTotalNorthLoad(cycledMatrix)
        XCTAssertEqual(result, 97241)
    }
}

func printMatrix(_ matrix: [[Character]]) {
    for row in matrix {
        print(row.map { String($0) }.joined(separator: ","))
    }
}
