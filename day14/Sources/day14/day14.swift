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

// MARK: Part 2

func rotateMatrixCW(_ matrix: [[Character]]) -> [[Character]] {
    var a = matrix
    let height = matrix.count
    let width = matrix.first?.count ?? 0
    let N = height
    
    // Traverse each cycle
    for i in 0 ..< N / 2 {
        for j in i ..< N - i - 1 {
            // Swap elements of each cycle
            // in clockwise direction
            let temp = a[i][j]
            a[i][j] = a[N - 1 - j][i]
            a[N - 1 - j][i] = a[N - 1 - i][N - 1 - j]
            a[N - 1 - i][N - 1 - j] = a[j][N - 1 - i]
            a[j][N - 1 - i] = temp
        }
    }
    
    return a
}

func cycleMatrix(_ matrix: [[Character]]) -> [[Character]] {
    var updatedMatrix = matrix
    for _ in 0 ..< 4 {
        updatedMatrix = tiltNorth(updatedMatrix)
        updatedMatrix = rotateMatrixCW(updatedMatrix)
    }
    
    return updatedMatrix
}

func cycleMany(_ inputMatrix: [[Character]], count: Int) -> [[Character]] {
    var matrices = [[[Character]]]()
    var matrix = inputMatrix
    
    while matrices.contains(matrix) == false {
        matrices.append(matrix)
        matrix = cycleMatrix(matrix)
    }
    
    print("Recurrance after \(matrices.count) cyles")
    
    let jumpBack = matrices.firstIndex(of: matrix)!
    
    matrices = Array(matrices.dropFirst(jumpBack))
    
    return matrices[(count - jumpBack) % matrices.count]
}
