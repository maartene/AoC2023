import XCTest
@testable import day18

struct DigPlan: CustomStringConvertible {
    let tiles: [Vector2D: Character]
    
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int
    
    init(_ inputString: String) {
        var minX = Int.max
        var maxX = Int.min
        var minY = Int.max
        var maxY = Int.min
        
        var tiles: [Vector2D: Character] = [.zero: "#"]
        
        let lines = inputString.split(separator: "\n").map { String($0) }
        var currentPosition = Vector2D.zero
        for line in lines {
            let splits = line.split(separator: " ").map { String($0) }
            let direction = splits[0]
            let count = Int(splits[1])!
            
            for _ in 0 ..< count {
                switch direction {
                case "R":
                    currentPosition = currentPosition + Vector2D(x: 1, y: 0)
                    tiles[currentPosition] = "#"
                case "L":
                    currentPosition = currentPosition + Vector2D(x: -1, y: 0)
                    tiles[currentPosition] = "#"
                case "U":
                    currentPosition = currentPosition + Vector2D(x: 0, y: -1)
                    tiles[currentPosition] = "#"
                case "D":
                    currentPosition = currentPosition + Vector2D(x: 0, y: 1)
                    tiles[currentPosition] = "#"
                default:
                    // ignore for now
                    fatalError("Found unexpected token \(direction)")
                }
                
                minX = min(minX, currentPosition.x)
                maxX = max(maxX, currentPosition.x)
                minY = min(minY, currentPosition.y)
                maxY = max(maxY, currentPosition.y)
            }
            
        }
        
        self.tiles = tiles
        
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
        
    }
    
    var description: String {
        var lines = [String]()
        for y in minY ... maxY {
            var line = ""
            for x in minX ... maxX {
                line += String(tiles[Vector2D(x: x, y: y), default: "."])
            }
            lines.append(line)
        }
        return lines.joined(separator: "\n")
    }
    
    var outlineCount: Int {
        tiles.count
    }
    
    func calculateInsideCount() -> Int {
        var toCheck = Set([Vector2D(x: 1, y: 1)])
        var checked = Set<Vector2D>()
        
        while toCheck.isEmpty == false {
        let currentCoord = toCheck.first!
            
        let neighbours = currentCoord.neighbours
            
        for neighbour in neighbours {
            if tiles.keys.contains(neighbour) == false && checked.contains(neighbour) == false {
                     toCheck.insert(neighbour)
                 }
             }
            
             toCheck.remove(currentCoord)
             checked.insert(currentCoord)
         }
        
        return outlineCount + checked.count
    }
}

final class day18Tests: XCTestCase {
    let exampleInput =
    """
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """
    
    func test_countOutline() {
        let outline =
        """
        #######
        #.....#
        ###...#
        ..#...#
        ..#...#
        ###.###
        #...#..
        ##..###
        .#....#
        .######
        """
        
        let lavaCount = outline.filter { $0 == "#" }.count
        
        XCTAssertEqual(lavaCount, 38)
    }
    
    func test_countInside() {
        let inside =
        """
        #######
        #######
        #######
        ..#####
        ..#####
        #######
        #####..
        #######
        .######
        .######
        """
        
        let lavaCount = inside.filter { $0 == "#" }.count
        
        XCTAssertEqual(lavaCount, 62)
        
    }
    
    func test_2DMap_withExampleInput() {
        let expected =
        """
        #######
        #.....#
        ###...#
        ..#...#
        ..#...#
        ###.###
        #...#..
        ##..###
        .#....#
        .######
        """
        
        let result = DigPlan(exampleInput).description
        
        XCTAssertEqual(result, expected)
    }
    
    func test_digPlan_outlineCount_withExampleInput() {
        let digPlan = DigPlan(exampleInput)
        XCTAssertEqual(digPlan.outlineCount, 38)
    }
    
    func test_digPlan_insideCount_withExampleInput() {
        let digPlan = DigPlan(exampleInput)
        XCTAssertEqual(digPlan.calculateInsideCount(), 62)
    }
    
    func test_digPlan_input() {
        let digPlan = DigPlan(input)
        print(digPlan) // 50,72 seems inside
    }
}
