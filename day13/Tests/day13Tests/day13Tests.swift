import XCTest
@testable import day13

func compareColumn(_ col1: Int, _ col2: Int, in matrix: [[Bool]]) -> Bool {
    let width = matrix.first?.count ?? 0
    guard col1 >= 0 && col1 < width && col2 >= 0 && col2 < width else {
        return true
    }
    
    for y in 0 ..< matrix.count {
        if matrix[y][col1] != matrix[y][col2] {
            return false
        }
    }
    return true
}

func isVerticalMirror(col: Int, in matrix: [[Bool]]) -> Bool {
    let width = matrix.first?.count ?? 0
        
    var result = true
    for i in 0 ..< width {
        let colToCheck1 = col - i
        let colToCheck2 = col + 1 + i
        //let compareResult =
        //print("Checking columns: \(colToCheck1) \(colToCheck2)")
        
        result = compareColumn(colToCheck1, colToCheck2, in: matrix) && result
    }
    return result
}

/// returns `nil` if no vertical reflection is found
func findVerticalReflection(_ matrix: [[Bool]]) -> Int? {
    var reflectionAfterColumn: Int?
    let width = matrix.first?.count ?? 0
    var col = 0
    while reflectionAfterColumn == nil && col < width - 1 {
        //print("trying column :\(col)")
        if isVerticalMirror(col: col, in: matrix) {
            reflectionAfterColumn = col
        }
        col += 1
    }
    return reflectionAfterColumn
}

func compareRow(_ row1: Int, _ row2: Int, in matrix: [[Bool]]) -> Bool {
    let height = matrix.count
    guard row1 >= 0 && row1 < height && row2 >= 0 && row2 < height else {
        return true
    }
    
    for x in 0 ..< matrix[0].count {
        if matrix[row1][x] != matrix[row2][x] {
            return false
        }
    }
    return true
}

func isHorizontalMirror(row: Int, in matrix: [[Bool]]) -> Bool {
    let height = matrix.count
        
    var result = true
    for i in 0 ..< height {
        let rowToCheck1 = row - i
        let rowToCheck2 = row + 1 + i
        //let compareResult =
        //print("Checking columns: \(rowToCheck1) \(rowToCheck2)")
        
        result = compareRow(rowToCheck1, rowToCheck2, in: matrix) && result
    }
    return result
}


func findHorizontalReflection(_ matrix: [[Bool]]) -> Int? {
    var reflectionAfterRow: Int?
    let height = matrix.count
    var row = 0
    while reflectionAfterRow == nil && row < height - 1 {
        //print("trying row :\(row)")
        if isHorizontalMirror(row: row, in: matrix) {
            reflectionAfterRow = row
        }
        row += 1
    }
    return reflectionAfterRow
}

func calculateCheckSum(_ input: String) -> Int {
    var lines = input.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
    var boardStrings = [String]()
    var i = 0
    while lines.count > 0 {
        //print(lines)
        if let endOfBoardIndex = lines.firstIndex(of: "") {
            
            boardStrings.append(lines[0 ..< endOfBoardIndex].joined(separator: "\n"))
            lines = Array(lines.dropFirst(endOfBoardIndex))
            lines = Array(lines.dropFirst())
        } else {
            boardStrings.append(lines.joined(separator: "\n"))
            lines = []
        }
        
    }
    
    //print(boardStrings.count, boardStrings)
    
    let boards = boardStrings.map { boardString in
        boardString.split(separator: "\n").map { String($0) }
            .map { line in
                line.map { $0 == "#" }
            }
    }
    
    let verticalMirrors = boards.compactMap {
        findVerticalReflection($0)
    }.map { ($0 + 1) * 1 }
    
    let horizontalMirrors = boards.compactMap {
        findHorizontalReflection($0)
    }.map { ($0 + 1) * 100 }
    
    return verticalMirrors.reduce(0, +) + horizontalMirrors.reduce(0, +)
}


final class day13Tests: XCTestCase {
    let exampleInput1 =
    """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """
    
    let exampleInput2 =
    """
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """
    
    let exampleInput =
    """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """
    
    lazy var matrixExample1 = exampleInput1.split(separator: "\n").map { String($0) }
        .map { line in
            line.map { $0 == "#" }
        }
    
    lazy var matrixExample2 = exampleInput2.split(separator: "\n").map { String($0) }
        .map { line in
            line.map { $0 == "#" }
        }
    
    func test_isVerticalReflection_withExampleInput_with5_returnsTrue() {
        let result = isVerticalMirror(col: 4, in: matrixExample1)
        XCTAssertTrue(result)
    }
    
    func test_isVerticalReflection_withExampleInput_with6_returnsFalse() {
        let result = isVerticalMirror(col: 5, in: matrixExample1)
        XCTAssertFalse(result)
    }
    
    func test_isVerticalReflection_withExampleInput_with0_returnsFalse() {
        let result = isVerticalMirror(col: 0, in: matrixExample1)
        XCTAssertFalse(result)
    }
    
    func test_findVerticalReflection_withExampleInput1() {
        let result = findVerticalReflection(matrixExample1)
        XCTAssertEqual(result, 4)
    }
    
    func test_findVerticalReflection_withExampleInput2_returnsNil() {
        let result = findVerticalReflection(matrixExample2)
        XCTAssertNil(result)
    }
    
    func test_findHorizontalReflection_withExampleInput2() {
        let result = findHorizontalReflection(matrixExample2)
        XCTAssertEqual(result, 3)
    }
    
    func test_findHorizontalReflection_withExampleInput1_returnsNil() {
        let result = findHorizontalReflection(matrixExample1)
        XCTAssertNil(result)
    }
    
    func test_calculateCheckSum_withExampleInput() {
        let result = calculateCheckSum(exampleInput)
        XCTAssertEqual(result, 405)
    }
    
    func test_part1() {
        let result = calculateCheckSum(input)
        XCTAssertEqual(result, 30802)
    }
}
