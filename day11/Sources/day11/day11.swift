import Foundation

struct Universe {
    let cells: [[String]]
    let galaxies: [Int: Vector2D]
    let colCount: Int
    let rowCount: Int
    
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
    }
    
    func findRowsToExpand() -> [Int] {
        var rowsToExpand = [Int]()
        for (index, row) in cells.enumerated() {
            if row.contains("#") == false {
                rowsToExpand.append(index)
            }
        }
        
        return rowsToExpand
    }

    func findColsToExpand() -> [Int] {
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

    func expandUniverse() -> Universe {
        let rowsToExpand = findRowsToExpand()
        let colsToExpand = findColsToExpand()
        
        var expandedCells = self.cells
        
        // expand rows
        for (index, row) in cells.enumerated().reversed() {
            if rowsToExpand.contains(index) {
                expandedCells.insert(row, at: index)
            }
        }
        
        // expand cols
        for colOffset in 0 ..< cells[0].count {
            let col = cells[0].count - 1 - colOffset
            if colsToExpand.contains(col) {
                for row in 0 ..< expandedCells.count {
                    expandedCells[row].insert(".", at: col)
                }
            }
        }
        
        return Universe(cells: expandedCells)
    }
    
    func findShortestPathLength(from: Int, to: [Int]) -> [Int] {
        let fromLocation = galaxies[from]!
        let targets = to.compactMap { galaxies[$0] }
        //let dijkstra = dijkstra2(target: fromLocation)
        
        return targets.map { target in
            abs(target.y - fromLocation.y) + abs(target.x - fromLocation.x)
        }
        
    }
        
    func sumOfShortestPathsBetweenAllGalaxies() -> Int {
        var galaxiesToCheck = Set(galaxies.map { $0.key })
        
        var shortestPathSum = 0
        while galaxiesToCheck.isEmpty == false {
            let currentGalaxy = galaxiesToCheck.first!
            //print("Checking galaxy: \(currentGalaxy)")
            galaxiesToCheck.remove(currentGalaxy)
                        
            let shortestPathsForGalaxy = findShortestPathLength(from: currentGalaxy, to: Array(galaxiesToCheck))
            let shortestPathSumForGalaxy = shortestPathsForGalaxy.reduce(0, +)
            shortestPathSum += shortestPathSumForGalaxy
        }
        
        return shortestPathSum
    }
    
    // MARK: Part 2
    
    func sumOfShortestPathsBetweenAllGalaxies_part2(expandMultiplier: Int) -> Int {
        var galaxiesToCheck = Set(galaxies.map { $0.key })
        
        var shortestPathSum = 0
        while galaxiesToCheck.isEmpty == false {
            let currentGalaxy = galaxiesToCheck.first!
            //print("Checking galaxy: \(currentGalaxy)")
            galaxiesToCheck.remove(currentGalaxy)
                        
            let shortestPathsForGalaxy = findShortestPathLength_part2(from: currentGalaxy, to: Array(galaxiesToCheck), expandMultiplier: expandMultiplier)
            let shortestPathSumForGalaxy = shortestPathsForGalaxy.reduce(0, +)
            shortestPathSum += shortestPathSumForGalaxy
        }
        
        return shortestPathSum
    }
    
    func findShortestPathLength_part2(from: Int, to: [Int], expandMultiplier: Int) -> [Int] {
        let fromLocation = galaxies[from]!
        let targets = to.compactMap { galaxies[$0] }
        //let dijkstra = dijkstra2(target: fromLocation)
        let rowsToExpand = findRowsToExpand()
        let colsToExpand = findColsToExpand()
        
        return targets.map { target in
            let minX = min(target.x, fromLocation.x)
            let minY = min(target.y, fromLocation.y)
            let maxX = max(target.x, fromLocation.x)
            let maxY = max(target.y, fromLocation.y)
            
            let rowsToExpandCount = rowsToExpand.filter { (minY ... maxY).contains($0) }.count
            
            let colsToExpandCount = colsToExpand.filter { (minX ... maxX).contains($0) }.count
            
            //let numberOfExpandedRows = rowsToExpand.filter { }
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
