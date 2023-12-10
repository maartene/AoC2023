import Foundation

struct Map {
    let startingPosition: Vector2D
    let nodes: [Vector2D: Character]
    let colCount: Int
    let rowCount: Int

    init(_ input: String) {
        let lines = input.split(separator: "\n").map { String($0) }
        var nodes = [Vector2D: Character]()
        for y in 0 ..< lines.count {
            let line = lines[y].split(separator: "").map { Character(String($0)) }
            for x in 0 ..< line.count {
                nodes[Vector2D(x: x, y: y)] = line[x]
            }
        }
        
        rowCount = lines.count
        colCount = lines[0].count
        
        self.nodes = nodes
        
        guard let sPosition = nodes.first(where: { $0.value == "S" })?.key else {
            fatalError("No S found in input")
        }
        
        startingPosition = sPosition
    }
    
    var startingPositionCharacter: Character {
        let east = Vector2D(x: startingPosition.x + 1, y: startingPosition.y)
        let west = Vector2D(x: startingPosition.x - 1, y: startingPosition.y)
        let north = Vector2D(x: startingPosition.x, y: startingPosition.y - 1)
        let south = Vector2D(x: startingPosition.x, y: startingPosition.y + 1)
        
        var connections = [Vector2D]()
        if "-J7".contains(nodes[east, default: "."]) {
            connections.append(east)
        }
        
        if "-LF".contains(nodes[west, default: "."]) {
            connections.append(west)
        }
        
        if "|7F".contains(nodes[north, default: "."]) {
            connections.append(north)
        }
        
        if "|LJ".contains(nodes[south, default: "."]) {
            connections.append(south)
        }
        
        if connections.contains(north) && connections.contains(south) {
            return "|"
        } else if connections.contains(east) && connections.contains(west) {
            return "-"
        } else if connections.contains(north) && connections.contains(east) {
            return "L"
        } else if connections.contains(north) && connections.contains(west) {
            return "J"
        } else if connections.contains(south) && connections.contains(west) {
            return "7"
        } else if connections.contains(south) && connections.contains(east) {
            return "F"
        } else {
            fatalError("Unable to determine starting position connection")
        }
        
    }
    
    func getCharacterAt(_ coord: Vector2D) -> Character {
        if nodes[coord] == "S" {
            return startingPositionCharacter
        }
        
        return nodes[coord, default: " "]
        
    }
    
    func getNeighboursFor(_ node: Vector2D) -> [Vector2D] {
        let east = Vector2D(x: node.x + 1, y: node.y)
        let west = Vector2D(x: node.x - 1, y: node.y)
        let north = Vector2D(x: node.x, y: node.y - 1)
        let south = Vector2D(x: node.x, y: node.y + 1)
        
        switch getCharacterAt(node) {
        case "|":
            return [north, south]
        case "-":
            return [east, west]
        case "L":
            return [north, east]
        case "J":
            return [north, west]
        case "7":
            return [south, west]
        case "F":
            return [south, east]
        default:
            return []
        }
    }
    
    func dijkstra2(target: Vector2D) -> [Vector2D: Int] {
        var unvisited = Set<Vector2D>()
        var visited = Set<Vector2D>()
        var dist = [Vector2D: Int]()
        
        
        unvisited.insert(target)
        dist[target] = 0
        var currentNode = target
        while unvisited.isEmpty == false {
            let neighbours = getNeighboursFor(currentNode)
            for neighbour in neighbours {
                if visited.contains(neighbour) == false {
                    unvisited.insert(neighbour)
                }
                let alt = dist[currentNode]! + 1
                if alt < dist[neighbour, default: Int.max] {
                    dist[neighbour] = alt
                }
            }
            
            unvisited.remove(currentNode)
            visited.insert(currentNode)
            
            if let newNode = unvisited.min(by: { dist[$0, default: Int.max] < dist[$1, default: Int.max] }) {
                currentNode = newNode
            }
        }
        return dist
    }
}

// MARK: Part 1

func getStepcount(_ input: String) -> Int {
    let map = Map(input)
    let dijkstra = map.dijkstra2(target: map.startingPosition)
    let stepCount: Int = dijkstra.values.max()!
    return stepCount
}

// MARK: Part 2
extension Map {
    init(nodes: [Vector2D: Character], colCount: Int, rowCount: Int, startingPosition: Vector2D) {
        self.nodes = nodes
        self.colCount = colCount
        self.rowCount = rowCount
        self.startingPosition = startingPosition
    }
    
    func substitutePath() -> Map {
        let path = dijkstra2(target: startingPosition)
        var updatedNodes = nodes
        
        for tile in nodes.keys {
            if path.keys.contains(tile) == false {
                updatedNodes[tile] = "."
            }
        }
        
        return Map(nodes: updatedNodes, colCount: colCount, rowCount: rowCount, startingPosition: startingPosition)
    }
    
    func findEnclosedTiles() -> [Vector2D] {
         //simple flood fill
         var toCheck = Set([Vector2D.zero])
         var checked = Set<Vector2D>()
        
         let path = dijkstra2(target: startingPosition)
        
         while toCheck.isEmpty == false {
             let currentCoord = toCheck.first!
            
             let neighbours = currentCoord.neighbours
            
             for neighbour in neighbours {
                 if nodes.keys.contains(neighbour) && path.keys.contains(neighbour) == false && checked.contains(neighbour) == false {
                     toCheck.insert(neighbour)
                 }
             }
            
             toCheck.remove(currentCoord)
             checked.insert(currentCoord)
         }
        
         // find all . in map
        let allDots = Set(nodes.filter { $0.value == "." }.keys)
         let notFilled = allDots.subtracting(checked)
        
         return Array(notFilled)
    }
    
    func scale3() -> Map {
        var updatedNodes = [Vector2D: Character]()
                
        for node in nodes {
            updatedNodes[node.key * 3] = node.value

            let east = Vector2D(x: node.key.x + 1, y: node.key.y)
            let south = Vector2D(x: node.key.x, y: node.key.y + 1)
            
            // scale east
            updatedNodes[Vector2D(x: 3 * node.key.x + 1, y: 3 * node.key.y)] =
            getNeighboursFor(node.key).contains(east) && getNeighboursFor(east).contains(node.key) ? "-" : ","
            updatedNodes[Vector2D(x: 3 * node.key.x + 2, y: 3 * node.key.y)] =
            getNeighboursFor(node.key).contains(east) && getNeighboursFor(east).contains(node.key) ? "-" : ","
                
            // scale south
            updatedNodes[Vector2D(x: 3 * node.key.x, y: 3 * node.key.y + 1)] = getNeighboursFor(node.key).contains(south) && getNeighboursFor(south).contains(node.key) ? "|" : ","
            updatedNodes[Vector2D(x: 3 * node.key.x, y: 3 * node.key.y + 2)] = getNeighboursFor(node.key).contains(south) && getNeighboursFor(south).contains(node.key) ? "|" : ","
                
            // fill in the rest
            updatedNodes[Vector2D(x: 3 * node.key.x + 1, y: 3 * node.key.y + 1)] = ","
            updatedNodes[Vector2D(x: 3 * node.key.x + 2, y: 3 * node.key.y + 2)] = ","
            updatedNodes[Vector2D(x: 3 * node.key.x + 1, y: 3 * node.key.y + 2)] = ","
            updatedNodes[Vector2D(x: 3 * node.key.x + 2, y: 3 * node.key.y + 1)] = ","
        }
        
        return Map(nodes: updatedNodes, colCount: colCount * 3, rowCount: rowCount * 3, startingPosition: startingPosition * 3)
    }
}

func findEnclosedTilesCount(_ input: String) -> Int {
    let map = Map(input)
    let substitutedMap = map.substitutePath()
    let map3x = substitutedMap.scale3()
    let result = map3x.findEnclosedTiles()
    return result.count
}
