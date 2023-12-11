import Foundation

struct Universe {
    let cells: [[String]]
    let galaxies: [Int: Vector2D]
    let colCount: Int
    let rowCount: Int
    let rowsToExpand: [Int]
    let colsToExpand: [Int]
    
    init(_ input: String) {
        let cells = input.split(separator: "\n").map { String($0) }
            .map { line in
                line.split(separator: "").map { String($0) }
            }
        
        self.init(cells: cells)
    }
    
    init(cells: [[String]]) {
        self.cells = cells
        
        rowCount = cells.count
        colCount = cells[0].count
        
        var galaxyID = 1
        var foundGalaxies = [Int: Vector2D]()
        for y in 0 ..< rowCount {
            for x in 0 ..< colCount {
                if cells[y][x] == "#" {
                    foundGalaxies[galaxyID] = Vector2D(x: x, y: y)
                    galaxyID += 1
                }
            }
        }
        self.galaxies = foundGalaxies

        rowsToExpand = Self.findRowsToExpand(cells: cells)
        colsToExpand = Self.findColsToExpand(cells: cells)

    }
    
    static func findRowsToExpand(cells: [[String]]) -> [Int] {
        var rowsToExpand = [Int]()
        for (index, row) in cells.enumerated() {
            if row.contains("#") == false {
                rowsToExpand.append(index)
            }
        }
        
        return rowsToExpand
    }

    static func findColsToExpand(cells: [[String]]) -> [Int] {
        var colsToExpand = [Int]()
        for col in 0 ..< cells[0].count {
            var empty = true
            for row in 0 ..< cells.count {
                empty = cells[row][col] == "." && empty
            }
            
            if empty {
                colsToExpand.append(col)
            }
        }
        
        return colsToExpand
    }
        
    func sumOfShortestPathsBetweenAllGalaxies(expandMultiplier: Int) -> Int {
        var galaxiesToCheck = Set(galaxies.map { $0.key })
        
        var shortestPathSum = 0
        while galaxiesToCheck.isEmpty == false {
            let currentGalaxy = galaxiesToCheck.first!
            galaxiesToCheck.remove(currentGalaxy)
                        
            let shortestPathsForGalaxy = findShortestPathLength(from: currentGalaxy, to: Array(galaxiesToCheck), expandMultiplier: expandMultiplier)
            let shortestPathSumForGalaxy = shortestPathsForGalaxy.reduce(0, +)
            shortestPathSum += shortestPathSumForGalaxy
        }
        
        return shortestPathSum
    }
    
    func findShortestPathLength(from: Int, to: [Int], expandMultiplier: Int) -> [Int] {
        let fromLocation = galaxies[from]!
        let targets = to.compactMap { galaxies[$0] }
        
        return targets.map { target in
            let minX = min(target.x, fromLocation.x)
            let minY = min(target.y, fromLocation.y)
            let maxX = max(target.x, fromLocation.x)
            let maxY = max(target.y, fromLocation.y)
            
            let rowsToExpandCount = rowsToExpand.filter { (minY ... maxY).contains($0) }.count
            
            let colsToExpandCount = colsToExpand.filter { (minX ... maxX).contains($0) }.count
            
            return maxX - minX - colsToExpandCount + colsToExpandCount * expandMultiplier + maxY - minY - rowsToExpandCount + rowsToExpandCount * expandMultiplier
        }
        
    }
}

extension Universe: CustomStringConvertible {
    var description: String {
        var rowLines = [String]()
        for row in cells {
            var line = ""
            for col in row {
                line += col
            }
            rowLines.append(line)
        }
        return rowLines.joined(separator: "\n")
    }
}
