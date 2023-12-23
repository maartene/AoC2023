import Foundation


struct Map {
    let tiles: [Vector2D: Character]
    let width: Int
    let height: Int
    let startPosition: Vector2D
    let targetPosition: Vector2D
    
    init(_ inputString: String) {
        let inputTiles: [[Character]] = inputString.split(separator: "\n").map { String($0) }
            .map { line in
                line.map { $0 }
            }
        
        height = inputTiles.count
        width = inputTiles.first?.count ?? 0
        
        var tiles = [Vector2D: Character]()
        for y in 0 ..< height {
            for x in 0 ..< width {
                tiles[Vector2D(x: x, y: y)] = inputTiles[y][x]
            }
        }
        
        let startX = inputTiles[0].firstIndex(of: ".")!
        startPosition = Vector2D(x: startX, y: 0)
        
        let endX = inputTiles[height - 1].firstIndex(of: ".")!
        targetPosition = Vector2D(x: endX, y: 0)
        
        self.tiles = tiles
    }
    
    func getNeighboursFor(_ node: Vector2D) -> [Vector2D] {
        return node.neighbours
            .filter { tiles.keys.contains($0) }
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
    
    func longestPath() -> Int {
        let dijkstra = dijkstra2(target: startPosition)
        return dijkstra[targetPosition]!
    }
    
}
