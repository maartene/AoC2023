import Foundation

class MountainRange {
    let matrix: [[Bool]]
    
    var cacheCompareColumns = [Vector2D: Bool]()
    var cacheCompareRows = [Vector2D: Bool]()
    var cacheHitCount = 0
    
    let width: Int
    let height: Int
    
    init(_ inputString: String) {
        matrix = inputString.split(separator: "\n").map { String($0) }
                .map { line in
                    line.map { $0 == "#" }
                }
        
        width = matrix.first?.count ?? 0
        height = matrix.count
    }
    
    func compareColumn(_ col1: Int, _ col2: Int, flipLocation: Vector2D? = nil) -> Bool {
        guard col1 >= 0 && col1 < width && col2 >= 0 && col2 < width else {
            return true
        }
        
        var canUseCache = true
        if let flipLocation {
            canUseCache = col1 != flipLocation.x && col2 != flipLocation.x
        }
        
        if canUseCache, let cachedValue = cacheCompareColumns[Vector2D(x: col1, y: col2)] {
            cacheHitCount += 1
            return cachedValue
        }
        
        var result = true
        for y in 0 ..< matrix.count {
            let value1 = flipLocation?.x == col1 && flipLocation?.y == y ? !matrix[y][col1] : matrix[y][col1]
            let value2 = flipLocation?.x == col2 && flipLocation?.y == y ? !matrix[y][col2] : matrix[y][col2]
            if value1 != value2 {
                result = false
            }
        }
        
        if canUseCache {
            cacheCompareColumns[Vector2D(x: col1, y: col2)] = result
        }
        return result
    }

    func isVerticalMirror(col: Int, flipLocation: Vector2D? = nil) -> Bool {
        var result = true
        for i in 0 ..< width {
            let colToCheck1 = col - i
            let colToCheck2 = col + 1 + i
            //let compareResult =
            //print("Checking columns: \(colToCheck1) \(colToCheck2)")
            
            result = compareColumn(colToCheck1, colToCheck2, flipLocation: flipLocation) && result
        }
        return result
    }

    /// returns `nil` if no vertical reflection is found
    func findVerticalReflection(flipLocation: Vector2D? = nil, ignoreColumn: Int? = nil) -> Int? {
        var reflectionAfterColumn: Int?
        var col = 0
        while reflectionAfterColumn == nil && col < width - 1 {
            //print("trying column :\(col)")
            if col != ignoreColumn, isVerticalMirror(col: col, flipLocation: flipLocation) {
                reflectionAfterColumn = col
            }
            col += 1
        }
        return reflectionAfterColumn
    }

    func compareRow(_ row1: Int, _ row2: Int, flipLocation: Vector2D? = nil) -> Bool {
        guard row1 >= 0 && row1 < height && row2 >= 0 && row2 < height else {
            return true
        }
        
        var canUseCache = true
        if let flipLocation {
            canUseCache = row1 != flipLocation.y && row2 != flipLocation.y
        }
        
        if canUseCache, let cachedValue = cacheCompareRows[Vector2D(x: row1, y: row2)] {
            cacheHitCount += 1
            return cachedValue
        }
        
        var result = true
        for x in 0 ..< width {
            let value1 = flipLocation?.x == x && flipLocation?.y == row1 ? !matrix[row1][x] : matrix[row1][x]
            let value2 = flipLocation?.x == x && flipLocation?.y == row2 ? !matrix[row2][x] : matrix[row2][x]
            if value1 != value2 {
                result = false
            }
        }
        
        if canUseCache {
            cacheCompareRows[Vector2D(x: row1, y: row2)] = result
        }
        return result
    }

    func isHorizontalMirror(row: Int, flipLocation: Vector2D? = nil) -> Bool {
        var result = true
        for i in 0 ..< height {
            let rowToCheck1 = row - i
            let rowToCheck2 = row + 1 + i
            
            result = compareRow(rowToCheck1, rowToCheck2, flipLocation: flipLocation) && result
        }
        return result
    }

    func findHorizontalReflection(flipLocation: Vector2D? = nil, ignoreRow: Int? = nil) -> Int? {
        var reflectionAfterRow: Int?
        var row = 0
        while reflectionAfterRow == nil && row < height - 1 {
            //print("trying row :\(row)")
            if row != ignoreRow, isHorizontalMirror(row: row, flipLocation: flipLocation) {
                reflectionAfterRow = row
            }
            row += 1
        }
        return reflectionAfterRow
    }
}

func createMountainRangesFromInput(_ input: String) -> [MountainRange] {
    var lines = input.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
    var mountainRangeStrings = [String]()
    while lines.count > 0 {
        //print(lines)
        if let endOfMountainRangeIndex = lines.firstIndex(of: "") {
            
            mountainRangeStrings.append(lines[0 ..< endOfMountainRangeIndex].joined(separator: "\n"))
            lines = Array(lines.dropFirst(endOfMountainRangeIndex))
            lines = Array(lines.dropFirst())
        } else {
            mountainRangeStrings.append(lines.joined(separator: "\n"))
            lines = []
        }
        
    }
    
    return mountainRangeStrings.map { MountainRange($0) }
}

func calculateCheckSum(_ input: String) -> Int {
    let mountainRanges = createMountainRangesFromInput(input)
    
    let verticalMirrors = mountainRanges.compactMap {
        return $0.findVerticalReflection()
    }.map { ($0 + 1) * 1 }
    
    let horizontalMirrors = mountainRanges.compactMap {
        return $0.findHorizontalReflection()
    }.map { ($0 + 1) * 100 }
    
    print("Cached count: \(mountainRanges.reduce(0) { $0 + $1.cacheHitCount })")
    return verticalMirrors.reduce(0, +) + horizontalMirrors.reduce(0, +)
}


// MARK: Part 2
extension MountainRange {
    func findReflectionWithFlipping() -> (col: Int?, row: Int?) {
        var col: Int?
        var row: Int?
        
        let existingCol = findVerticalReflection()
        let existingRow = findHorizontalReflection()
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                if row == nil && col == nil, let r = findHorizontalReflection(flipLocation: Vector2D(x: x, y: y), ignoreRow: existingRow) {
                    row = r
                }
                
                if col == nil && row == nil, let c = findVerticalReflection(flipLocation: Vector2D(x: x, y: y), ignoreColumn: existingCol) {
                    col = c
                }
            }
        }
        
        //print(existingCol, existingRow, col, row)
        return (col, row)
    }
}

func calculateCheckSumWithFlipping(_ input: String) -> Int {
    let mountainRanges = createMountainRangesFromInput(input)
    
    var checksums = [Int]()
    for i in 0 ..< mountainRanges.count {
        let reflection = mountainRanges[i].findReflectionWithFlipping()
        var checksum = 0
        if let col = reflection.col {
            checksum += (col + 1)
        }
        if let row = reflection.row {
            checksum += (row + 1) * 100
        }
        checksums.append(checksum)
    }
    
    print("Cached count: \(mountainRanges.reduce(0) { $0 + $1.cacheHitCount })")
    return checksums.reduce(0, +)
}
