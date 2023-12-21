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
            return tiles[$0] == "."
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
        /// Source: https://github.com/keriati/aoc/blob/master/2023/day21.ts
        
        let gardenGridDiameter = targetStepCount / width - 1
        
        let oddGardens = ((gardenGridDiameter / 2) * 2 + 1) * ((gardenGridDiameter / 2) * 2 + 1)
        let evenGardens = (((gardenGridDiameter + 1) / 2) * 2) * (((gardenGridDiameter + 1) / 2) * 2)
        
        print("Setting up odd/even plots")
        let oddGardenPlots = getTileCountWithinSteps(width * 2 + 1)
        let evenGardenPlots = getTileCountWithinSteps(width * 2)
        
        print("Setting up cross plots")
        let northPlots = getTileCountWithinSteps(width - 1, customStartPosition: Vector2D(x: startPosition.x, y: width - 1))
        let eastPlots = getTileCountWithinSteps(width - 1, customStartPosition: Vector2D(x: 0, y: startPosition.y))
        let southPlots = getTileCountWithinSteps(width - 1, customStartPosition: Vector2D(x: startPosition.x, y: 0))
        let westPlots = getTileCountWithinSteps(width - 1, customStartPosition: Vector2D(x: width - 1, y: startPosition.y))

        let smallSteps = (width / 2) - 1
        
        print("Setting up small diagonals")
        let NEPlotsSM = getTileCountWithinSteps(smallSteps, customStartPosition: Vector2D(x: 0, y: width - 1))
        let NWPlotsSM = getTileCountWithinSteps(smallSteps, customStartPosition: Vector2D(x: width - 1, y: width - 1))
        let SEPlotsSM = getTileCountWithinSteps(smallSteps, customStartPosition: .zero)
        let SWPlotsSM = getTileCountWithinSteps(smallSteps, customStartPosition: Vector2D(x: width - 1, y: 0))
        
        let largeSteps = ((width * 3) / 2) - 1
        
        print("Setting up large diagonals")
        let NEPlotsLG = getTileCountWithinSteps(largeSteps, customStartPosition: Vector2D( x: 0, y: width - 1))
        let NWPlotsLG = getTileCountWithinSteps(largeSteps, customStartPosition: Vector2D(x: width - 1, y: width - 1))
        let SEPlotsLG = getTileCountWithinSteps(largeSteps, customStartPosition: .zero)
        let SWPlotsLG = getTileCountWithinSteps(largeSteps, customStartPosition: Vector2D(x: width - 1, y: 0))
        
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
