import Foundation

struct Map {
    let tiles: [Vector2D: Character]
    let startPosition: Vector2D
    let width: Int
    let height: Int
    
    init(_ inputString: String) {
        let lines = inputString.split(separator: "\n").map { String($0) }
        
        height = lines.count
        width = lines.first?.count ?? 0
        var startPosition = Vector2D.zero
        var tiles = [Vector2D: Character]()
        for y in 0 ..< height {
            let line = lines[y]
            let lineArray = line.split(separator: "").map { Character(String($0)) }
            for x in 0 ..< width {
                if lineArray[x] == "S" {
                    startPosition = Vector2D(x: x, y: y)
                    tiles[Vector2D(x: x, y: y)] = "."
                } else {
                    tiles[Vector2D(x: x, y: y)] = lineArray[x]
                }
            }
        }
//
//        // multiply map
//        let multiplier = max(width / targetStepCount, height / targetStepCount) / 2
//        for i in -multiplier ... multiplier {
//            for tile in tiles {
//                tiles[Vector2D(x: tile.key.x + width * i, y: tile.key.y + height * i)]
//            }
//        }
        
        self.tiles = tiles
        self.startPosition = startPosition
    }
    
    func getTileCountWithinSteps(_ targetStepCount: Int, customStartPosition: Vector2D? = nil) -> Int {
        let startPosition = customStartPosition ?? self.startPosition
        let dijkstra = bfs(target: startPosition, with: targetStepCount)
        //printDijkstra(tiles: dijkstra, colCount: width, rowCount: height)
        return dijkstra.filter { $0.value == targetStepCount || ($0.value < targetStepCount && $0.value % 2 == targetStepCount % 2) }
            .count
    }
    
    func getNeighboursFor(_ currentNode: Vector2D, with targetStepCount: Int) -> [Vector2D] {
        currentNode.neighbours.filter {
            let multiplier = max(targetStepCount / width, targetStepCount / height) + 1
            let coord = Vector2D(x: (multiplier * width + $0.x) % width, y: (multiplier * height + $0.y) % height)
            
            let manhattanDistance = abs((startPosition.x - $0.x) + (startPosition.y - $0.y))
            guard manhattanDistance <= targetStepCount else {
                return false
            }
            
            return tiles[coord] == "."
        }
    }
    
    func bfs(target: Vector2D, with targetStepCount: Int) -> [Vector2D: Int] {
        var unvisited = [target]
        var unvisitedSet = Set([target])
        var visited = Set<Vector2D>()
        var dist = [Vector2D: Int]()
        
        
        dist[target] = 0
        var currentNode = target
        while unvisited.isEmpty == false {
            let neighbours = getNeighboursFor(currentNode, with: targetStepCount)
            for neighbour in neighbours {
                if visited.contains(neighbour) == false && unvisitedSet.contains(neighbour) == false {
                    unvisited.append(neighbour)
                    unvisitedSet.insert(neighbour)
                }
                let alt = dist[currentNode]! + 1
                if alt < dist[neighbour, default: Int.max] {
                    dist[neighbour] = alt
                }
            }
            
            unvisitedSet.remove(currentNode)
            currentNode = unvisited[0]
            unvisited.removeFirst()
            visited.insert(currentNode)
        }
        return dist
    }
    
    func getTileCountWithinStepsBig(_ targetStepCount: Int) -> Int {
        func getKey(_ x: Int, _ y: Int, _ z: Int) -> Int {
            (z * 1000 + x) * 1000 + y
        }
        
        func findPlots(_ x: Int, _ y: Int, _ maxSteps: Int) -> Int {
            var visited = Set<Int>()
            return findPlots(x, y, maxSteps, &visited)
        }
        
        func findPlots(_ x: Int, _ y: Int, _ maxSteps: Int, _ visited: inout Set<Int>, _ distance: Int = 0) -> Int {
            let key = getKey(x, y, distance)

            if (visited.contains(key)) { return 0 }
            visited.insert(key)

            if (distance == maxSteps) { return 1 }

            var plots = 0

            let neighbors = [
                (x - 1, y),
                (x + 1, y),
                (x, y - 1),
                (x, y + 1)
            ]

            neighbors.forEach {
                let nx = $0.0
                let ny = $0.1
                if (nx < 0 || ny < 0 || nx >= width || ny >= height) { return }

                if tiles[Vector2D(x: nx, y: ny)] == "." {
                    plots += findPlots(nx, ny, maxSteps, &visited, distance + 1)
                }
            }

          return plots;
        }
        
        /**
         * Alignment of the repeating gardens:
         *
         * O = Odd garden ( oddGardenPlots )
         * E = Even garden ( evenGardenPlots )
         * S = Small side garden ( NEPlotsSM, SWPlotsSM, NWPlotsSM, SEPlotsSM )
         * L = Large side garden ( NEPlotsLG, SWPlotsLG, NWPlotsLG, SEPlotsLG )
         * C = Center garden (Starting point)
         * North = North garden ( northPlots )
         * East = East garden ( eastPlots )
         * South = South garden ( southPlots )
         * West = West garden ( westPlots )
         *
         *                 North
         *                 S | S
         *               L - E - L
         *             S |   |   | S
         *           L - E - O - E - L
         *         S |   |   |   |   | S
         *    West - E - O - C - O - E - East
         *         S |   |   |   |   | S
         *           L - E - O - E - L
         *             S |   |   | S
         *               L - E - L
         *                 S | S
         *                 South
         */
        
        let gardenGridDiameter = targetStepCount / width - 1
        
        let oddGardens = ((gardenGridDiameter / 2) * 2 + 1) * ((gardenGridDiameter / 2) * 2 + 1)
        let evenGardens = (((gardenGridDiameter + 1) / 2) * 2) * (((gardenGridDiameter + 1) / 2) * 2)
        
        print("Setting up odd/even plots")
        //let oddGardenPlots = getTileCountWithinSteps(width * 2 + 1)
        //let evenGardenPlots = getTileCountWithinSteps(width * 2)
        let oddGardenPlots = findPlots(startPosition.x, startPosition.y, width * 2 + 1)
        let evenGardenPlots = findPlots(startPosition.x, startPosition.y, width * 2)
          
        
        print("Setting up cross plots")
        let northPlots = findPlots(startPosition.x, width - 1, width - 1);
        let eastPlots = findPlots(0, startPosition.y, width - 1);
        let southPlots = findPlots(startPosition.x, 0, width - 1);
        let westPlots = findPlots(width - 1, startPosition.y, width - 1);
          
        let smallSteps = (width / 2) - 1
        
        print("Setting up small diagonals")
        let NEPlotsSM = findPlots(0, width - 1, smallSteps);
        let NWPlotsSM = findPlots(width - 1, width - 1, smallSteps);
        let SEPlotsSM = findPlots(0, 0, smallSteps);
        let SWPlotsSM = findPlots(width - 1, 0, smallSteps);

        
        let largeSteps = ((width * 3) / 2) - 1
        
        print("Setting up large diagonals")
        let NEPlotsLG = findPlots(0, width - 1, largeSteps);
        let NWPlotsLG = findPlots(width - 1, width - 1, largeSteps);
        let SEPlotsLG = findPlots(0, 0, largeSteps);
        let SWPlotsLG = findPlots(width - 1, 0, largeSteps);

        
        let mainGardenPlots =
            oddGardens * oddGardenPlots + evenGardens * evenGardenPlots

        let smallSidePlots =
            (gardenGridDiameter + 1) * (SEPlotsSM + SWPlotsSM + NWPlotsSM + NEPlotsSM)
        
        let largeSidePlots =
            gardenGridDiameter * (SEPlotsLG + SWPlotsLG + NWPlotsLG + NEPlotsLG)
        
        return (
            mainGardenPlots +
            smallSidePlots +
            largeSidePlots +
            northPlots +
            eastPlots +
            southPlots +
            westPlots
          )
    }
}
