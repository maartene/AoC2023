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
        targetPosition = Vector2D(x: endX, y: height - 1)
        
        self.tiles = tiles
    }
    
    func getNeighboursFor(_ node: Vector2D) -> [Vector2D] {
        switch tiles[node] {
        case ".":
            return node.neighbours.filter { tiles[$0, default: "#"] != "#" }
        case ">":
            let right = node + Vector2D(x: 1, y: 0)
            if tiles[right, default: "#"] != "#" {
                return [right]
            } else {
                return []
            }
        case "<":
            let left = node + Vector2D(x: -1, y: 0)
            if tiles[left, default: "#"] != "#" {
                return [left]
            } else {
                return []
            }
        case "^":
            let up = node + Vector2D(x: 0, y: -1)
            if tiles[up, default: "#"] != "#" {
                return [up]
            } else {
                return []
            }
        case "v":
            let down = node + Vector2D(x: 0, y: 1)
            if tiles[down, default: "#"] != "#" {
                return [down]
            } else {
                return []
            }
        default:
            return []
        }
    }
    
    func maxDijkstra(target: Vector2D) -> [Vector2D: Int] {
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
                if alt > dist[neighbour, default: Int.min] {
                    dist[neighbour] = alt
                }
            }
            
            unvisited.remove(currentNode)
            visited.insert(currentNode)
            
            if let newNode = unvisited.max(by: { dist[$0, default: Int.min] < dist[$1, default: Int.min] }) {
                currentNode = newNode
            }
        }
        return dist
    }
    
    func minDijkstra(target: Vector2D) -> [Vector2D: Int] {
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
        let dijkstra = maxDijkstra(target: startPosition)
        //printDijkstra(tiles: dijkstra, colCount: width, rowCount: height)
        
        return dijkstra[targetPosition]!
    }
    
    // MARK: Part 2
    static func createMapWithoutSlopes(_ inputString: String) -> Map {
        var changedString = inputString.replacingOccurrences(of: ">", with: ".")
        changedString = changedString.replacingOccurrences(of: "<", with: ".")
        changedString = changedString.replacingOccurrences(of: "^", with: ".")
        changedString = changedString.replacingOccurrences(of: "v", with: ".")
        
        return Map(changedString)
    }

    func longestPath_dfs() -> Int {
        // convert tiles to grid
        var grid: [[Character]] = Array(repeating: Array(repeating: " ", count: width), count: height)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let coord = Vector2D(x: x, y: y)
                if let value = tiles[coord] {
                    grid[y][x] = value
                } else {
                    grid[y][x] = "#"
                }
            }
        }

        let rows = height
        let cols = width
        var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
        var longest = 0

        func dfs(i: Int, j: Int, length: Int) {
            if i < 0 || i >= rows || j < 0 || j >= cols || visited[i][j] || grid[i][j] == "#" {
                return
            }

            if targetPosition.y == i && targetPosition.x == j {
                longest = max(longest, length)
                return
            }

            visited[i][j] = true

            // Visit neighbors
            dfs(i: i + 1, j: j, length: length + 1)
            dfs(i: i - 1, j: j, length: length + 1)
            dfs(i: i, j: j + 1, length: length + 1)
            dfs(i: i, j: j - 1, length: length + 1)

            visited[i][j] = false
        }

        //dfs(i: startPosition.y, j: startPosition.x, length: 0)
        dfs(i: startPosition.y, j: startPosition.x, length: 0)
        
        return longest
    }
    
    func simplifyGraph() {
        var nodes = tiles.filter { $0.value == "." && getNeighboursFor($0.key).count > 2 }.map { $0.key }
        
        var edges = [(start: Vector2D, end: Vector2D, length: Int)]()
        
        for node in nodes {
            let dijkstra = minDijkstra(target: node)
            let validNeighboursCount = getNeighboursFor(node).count
            let sortedOtherNodes = nodes.filter { $0 != node }
                .sorted(by: { dijkstra[$0, default: Int.max] < dijkstra[$1, default: Int.max] })
            
            for otherNode in sortedOtherNodes[0 ..< validNeighboursCount] {
                if let length = dijkstra[otherNode] {
                    edges.append((start: node, end: otherNode, length: length))
                }
            }
        }
        
        nodes.append(startPosition)
        nodes.append(targetPosition)
        
        let dijkstra = minDijkstra(target: startPosition)
        let sortedOtherNodes = nodes.filter { $0 != startPosition }
            .sorted(by: { dijkstra[$0, default: Int.max] < dijkstra[$1, default: Int.max] })
        let otherNode = sortedOtherNodes[0]
        edges.append((start: startPosition, end: otherNode, length: dijkstra[otherNode]!))
        
        
//        print(nodes, nodes.count)
//        print(edges, edges.count)
        
        print(edges.filter({ $0.start == nodes[0] }))
        print(edges.filter({ $0.start == nodes[1] }))
        
        
        func longestPath_simplified() -> Int {
            // convert tiles to grid
            var visited = Set<Vector2D>()
            var longest = 0

            func dfs(node: Vector2D, length: Int) {
                if visited.contains(node) {
                    return
                }

                if node == targetPosition {
                    
                    longest = max(longest, length)
                    print("Found position with length \(length). Longest: \(longest)")
                    return
                }

                visited.insert(node)

                // Visit neighbors
                for neighbour in edges.filter({ $0.start == node }) {
                    dfs(node: neighbour.end, length: length + neighbour.length)
                }

                visited.remove(node)
            }

            //dfs(i: startPosition.y, j: startPosition.x, length: 0)
            dfs(node: startPosition, length: 0)
//            dfs(i: startPosition.y, j: startPosition.x, length: 0)
            
            return longest
        }
        
        let result = longestPath_simplified()
        print("Longest path simplified: \(result)")
    }
}

func printDijkstra(tiles: [Vector2D: Int], colCount: Int, rowCount: Int) {
    for y in 0 ..< rowCount {
        var row = "|"
        for x in 0 ..< colCount {
            let coord = Vector2D(x: x, y: y)
            if let value = tiles[coord] {
                if value > 100 {
                    row += "##|"
                } else {
                    row += String(format: "%02d", value) + "|"
                }
            } else {
                row += "  |"
            }
        }
        print(row)
    }
}

func findMaxium(_ inputString: String, passCount: Int = 20) async -> Int {
    async let maximum0 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum1 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum2 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum3 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum4 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum5 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum6 = findMaximumWorker(inputString, passCount: passCount)
    async let maximum7 = findMaximumWorker(inputString, passCount: passCount)
    
    return max(await maximum0,
               await maximum1,
               await maximum2,
               await maximum3,
               await maximum4,
               await maximum5,
               await maximum6,
               await maximum7)
}

@Sendable func findMaximumWorker(_ inputString: String, passCount: Int) async -> Int {
    var maximum = 0
    for i in  0 ..< passCount {
        if i % 100 == 0 { print("Pass \(i) of \(passCount)") }
        let map = Map(inputString)
        let result = map.longestPath()
        maximum = max(maximum, result)
    }
    return maximum
}
