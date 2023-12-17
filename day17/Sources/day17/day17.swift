import Foundation

enum Direction: CaseIterable {
    case left
    case up
    case right
    case down

    var opposite: Direction {
        switch self {
        case .left: return .right
        case .up: return .down
        case .right: return .left
        case .down: return .up
        }
    }

    var vector2d: Vector2D {
        switch self {
        case .left: return Vector2D(x: -1, y: 0)
        case .up: return Vector2D(x: 0, y: -1)
        case .right: return Vector2D(x: 1, y: 0)
        case .down: return Vector2D(x: 0, y: 1)
        }
    }
}

struct Input: Hashable {
    let position: Vector2D
    let previousPosition: Vector2D?
    let straightCount: Int
}

struct Input2: Hashable {
    let position: Vector2D
    let direction: Direction?
    let chainLength: Int
}

class Factory {
    let matrix: [Vector2D: Int]
    let width: Int
    let height: Int
    
    init(_ inputString: String) {
        let costs = inputString.split(separator: "\n").map { String($0) }
            .map { line in
                line.compactMap { Int(String($0)) }
            }
        
        height = costs.count
        width = costs.first?.count ?? 0
        
        var matrixCosts = [Vector2D: Int]()
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                matrixCosts[Vector2D(x: x, y: y)] = costs[y][x]
            }
        }
        
        self.matrix = matrixCosts
    }
    
    func getNeighbours(_ node: Input) -> [Input] {
        let neighbours = node.position.neighbours
        
        //print(node)
        
        let neighboursAsInput = neighbours.map {
            var nodeCount = 0
            if let previousPosition = node.previousPosition {
                let direction = node.position - previousPosition
                if node.position + direction == $0 {
                    nodeCount = node.straightCount + 1
                }
            }
            
            return Input(position: $0, previousPosition: node.position, straightCount: nodeCount)
        }
        
        let validNeighbours = neighboursAsInput.filter { neighbour in
            neighbour.position.x >= 0 && neighbour.position.x < width && neighbour.position.y >= 0 && neighbour.position.y < height && neighbour.straightCount < 3 && node.previousPosition != neighbour.position
        }
        
        return validNeighbours
    }
    
    func dijkstra2(target: Vector2D) -> [Input: Int] {
            var unvisited = Set<Input>()
            var visited = Set<Input>()
            var dist = [Input: Int]()
                    
            let targetInput = Input(position: target, previousPosition: nil, straightCount: 0)
            unvisited.insert(targetInput)
            dist[targetInput] = 0
            var currentNode = targetInput
            while unvisited.isEmpty == false {
                let neighbours = getNeighbours(currentNode)
                for neighbour in neighbours {
                    if visited.contains(neighbour) == false {
                        unvisited.insert(neighbour)
                    }
                    let alt = dist[currentNode]! + matrix[neighbour.position]!
                    if alt < dist[neighbour, default: Int.max] {
                        dist[neighbour] = alt
                    }
                }
                
                unvisited.remove(currentNode)
                visited.insert(currentNode)

                if let newNode = unvisited.min(by: { dist[$0, default: Int.max] < dist[$1, default: Int.max] }) {
                    currentNode = newNode
                }
                
                //print(unvisited.count)
            }
        return dist
        }
    
    
    // MARK: Part 2
    func dijkstra2_ultraCrucible(target: Vector2D) -> [Input: Int] {
            var unvisited = Set<Input>()
            var visited = Set<Input>()
            var dist = [Input: Int]()
                    
            let targetInput = Input(position: target, previousPosition: nil, straightCount: 0)
            unvisited.insert(targetInput)
            dist[targetInput] = 0
            var currentNode = targetInput
            while unvisited.isEmpty == false {
                let neighbours = getNeighbours_ultra(currentNode)
                for neighbour in neighbours {
                    if visited.contains(neighbour) == false {
                        unvisited.insert(neighbour)
                    }
                    let alt = dist[currentNode]! + matrix[neighbour.position]!
                    if alt < dist[neighbour, default: Int.max] {
                        dist[neighbour] = alt
                    }
                }
                
                unvisited.remove(currentNode)
                visited.insert(currentNode)

                if let newNode = unvisited.min(by: { dist[$0, default: Int.max] < dist[$1, default: Int.max] }) {
                    currentNode = newNode
                }
                
                //print(unvisited.count)
            }
        return dist
        }
    
    func getNeighbours_ultra_2(_ state: Input2) -> [Input2] {
        var result = [Input2]()
        let chainRange = 4 ... 10
        for dir in Direction.allCases {
            if let direction = state.direction {
                if direction == dir.opposite {
                    continue
                }
                if direction == dir && state.chainLength == chainRange.upperBound {
                    continue
                }
                if direction != dir && state.chainLength < chainRange.lowerBound {
                    continue
                }
            }
            let position = state.position + dir.vector2d
            if position.x < 0 || position.x >= width || position.y < 0 || position.y >= height {
                continue
            }
            let chainLength = dir == state.direction ? state.chainLength + 1 : 1
            result.append(Input2(position: position, direction: dir, chainLength: chainLength))
        }
        return result
    }

    func getNeighbours_ultra(_ node: Input) -> [Input] {
        //print(node)
        let neighbours = node.position.neighbours
        
        guard let previousPosition = node.previousPosition else {
            return neighbours.map {
                Input(position: $0, previousPosition: node.position, straightCount: 0)
            }.filter { neighbour in
                neighbour.position.x >= 0 && neighbour.position.x < width && neighbour.position.y >= 0 && neighbour.position.y < height
            }
        }
        
        let direction = node.position - previousPosition
        
        let neighboursAsInput = neighbours.map {
            var nodeCount = 0
            if node.position + direction == $0 {
                nodeCount = node.straightCount + 1
            }
            
            return Input(position: $0, previousPosition: node.position, straightCount: nodeCount)
        }
        
        let validNeighbours = neighboursAsInput.filter { neighbour in
            neighbour.position.x >= 0 && neighbour.position.x < width && neighbour.position.y >= 0 && neighbour.position.y < height && neighbour.straightCount < 10 && node.previousPosition != neighbour.position
        }
    
        let validIncludingTurns = validNeighbours.filter { neighbour in
            node.straightCount >= 3 || neighbour.position == node.position + direction
        }
        
        return validIncludingTurns
    }

    func dijkstra2_ultraCrucible_2(target: Vector2D) -> [Input2: Int] {
            var unvisited = Set<Input2>()
            var visited = Set<Input2>()
            var dist = [Input2: Int]()
                    
            let targetInput = Input2(position: target, direction: nil, chainLength: 0)
            unvisited.insert(targetInput)
            dist[targetInput] = 0
            var currentNode = targetInput
            while unvisited.isEmpty == false {
                let neighbours = getNeighbours_ultra_2(currentNode)
                for neighbour in neighbours {
                    if visited.contains(neighbour) == false {
                        unvisited.insert(neighbour)
                    }
                    let alt = dist[currentNode]! + matrix[neighbour.position]!
                    if alt < dist[neighbour, default: Int.max] {
                        dist[neighbour] = alt
                    }
                }
                
                unvisited.remove(currentNode)
                visited.insert(currentNode)

                if let newNode = unvisited.min(by: { dist[$0, default: Int.max] < dist[$1, default: Int.max] }) {
                    currentNode = newNode
                }
                
                //print(unvisited.count)
            }
        return dist
        }
}

