import Foundation


func createMatrix(_ input: String) -> [[Character]] {
    return input.split(separator: "\n").map { String($0)
    }.map { line in
        line.split(separator: "").map { Character(String($0))}
    }
}

func tiltNorthColumn(_ column: [Character] ) -> [Character] {
    var updatedColumn = column
    
    // split the column
    
    for row in 0 ..< column.count {
        if updatedColumn[row] == "O" {
            // move up
            var up = row - 1
            while up >= 0 && updatedColumn[up] == "." {
                updatedColumn[up + 1] = "."
                updatedColumn[up] = "O"
                up -= 1
            }
        }
    }
    
    return updatedColumn
}

func tiltNorth(_ matrix: [[Character]]) -> [[Character]] {
    var tiltedMatrix = matrix
    let height = matrix.count
    let width = matrix.first?.count ?? 0
    
    for col in 0 ..< width {
        
        let column = matrix.map { $0[col] }
        let tiltedColumn = tiltNorthColumn(column)
        for y in 0 ..< height {
            tiltedMatrix[y][col] = tiltedColumn[y]
        }
    }
    
    
    
    return tiltedMatrix
}

func calculateTotalNorthLoad(_ matrix: [[Character]]) -> Int {
    let height = matrix.count
    let width = matrix.first?.count ?? 0
    var load = 0
    for col in 0 ..< width {
        for row in 0 ..< height {
            if matrix[row][col] == "O" {
                load += height - row
            }
        }
    }

    return load
}
