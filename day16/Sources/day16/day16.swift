import Foundation

enum Direction {
    case left
    case up
    case right
    case down
}

struct Beam {
    let x: Int
    let y: Int
    let direction: Direction
    
    init(_ x: Int, _ y: Int, _ direction: Direction) {
        self.x = x
        self.y = y
        self.direction = direction
    }
}

extension Beam: Equatable { }
extension Beam: Hashable { }

class Contraption {
    let matrix: [[Character]]
    let height: Int
    let width: Int
    
    init(_ inputString: String) {
        matrix = inputString.split(separator: "\n").map { String($0)
                .map { $0 }
        }
            
        height = matrix.count
        width = matrix.first?.count ?? 0
    }
    
    func nextPositionFor(beam: Beam) -> [Beam] {
        let character = matrix[beam.y][beam.x]
        switch character {
        case ".":
            return [processDot(for: beam)]
        case "|":
            return processVerticalBar(for: beam)
        case "-":
            return processHorizontalBar(for: beam)
        case "/":
            return [processForwardSlash(for: beam)]
        case "\\":
            return [processBackwardSlash(for: beam)]
        default:
            fatalError("Unexpected token: \(character)")
        }
        
    }
    
    func processDot(for beam: Beam) -> Beam {
        switch beam.direction {
        case .right:
            return beam.x < width - 1 ? Beam(beam.x + 1, beam.y, beam.direction) : beam
        case .down:
            return beam.y < height - 1 ? Beam(beam.x, beam.y + 1, beam.direction) : beam
        case .up:
            return beam.y > 0 ? Beam(beam.x, beam.y - 1, beam.direction) : beam
        case .left:
            return beam.x > 0 ? Beam(beam.x - 1, beam.y, beam.direction) : beam
        }
    }
    
    func processVerticalBar(for beam: Beam) -> [Beam] {
        var result = [Beam]()
        
        guard [.left, .right].contains(beam.direction) else {
            return [processDot(for: beam)]
        }
        
        result.append(Beam(beam.x, beam.y - 1, .up))
        result.append(Beam(beam.x, beam.y + 1, .down))
        
        return result.filter {
            $0.x >= 0 && $0.x < width && $0.y >= 0 && $0.y < height
        }
    }
    
    func processHorizontalBar(for beam: Beam) -> [Beam] {
        var result = [Beam]()
        
        guard [.up, .down].contains(beam.direction) else {
            return [processDot(for: beam)]
        }
        
        result.append(Beam(beam.x - 1, beam.y, .left))
        result.append(Beam(beam.x + 1, beam.y, .right))
        
        return result.filter {
            $0.x >= 0 && $0.x < width && $0.y >= 0 && $0.y < height
        }
    }
    
    func processForwardSlash(for beam: Beam) -> Beam {
        let result: Beam
        switch beam.direction {
        case .right:
            result = Beam(beam.x, beam.y - 1, .up)
        case .down:
            result = Beam(beam.x - 1, beam.y, .left)
        case .up:
            result = Beam(beam.x + 1, beam.y, .right)
        case .left:
            result = Beam(beam.x, beam.y + 1, .down)
        }
        
        if result.x >= 0 && result.x < width && result.y >= 0 && result.y < height {
            return result
        } else {
            return beam
        }
    }
    
    func processBackwardSlash(for beam: Beam) -> Beam {
        let result: Beam
        
        switch beam.direction {
        case .right:
            result = Beam(beam.x, beam.y + 1, .down)
        case .down:
            result = Beam(beam.x + 1, beam.y, .right)
        case .up:
            result = Beam(beam.x - 1, beam.y, .left)
        case .left:
            result = Beam(beam.x, beam.y - 1, .up)
        }
        
        if result.x >= 0 && result.x < width && result.y >= 0 && result.y < height {
            return result
        } else {
            return beam
        }
    }
    
    func energizedTilesCount(startBeam: Beam) -> Int {
        struct Coord: Hashable {
            let x: Int
            let y: Int
        }
        
        var beams = Set([startBeam])
        var energizedTiles = Set<Beam>()
        
        while beams.isEmpty == false {
            let beam = beams.removeFirst()
            energizedTiles.insert(beam)
            for newBeam in nextPositionFor(beam: beam) {
                if energizedTiles.contains(newBeam) == false { beams.insert(newBeam) }
            }
        }
        
        let coords = energizedTiles.reduce(into: Set<Coord>()) { $0.insert(Coord(x: $1.x, y: $1.y)) }
        return coords.count
    }
    
    func calculateMaximumEnergizedCount() -> Int {
        var startBeams = [Beam]()
        for x in 0 ..< width {
            startBeams.append(Beam(x, 0, .down))
            startBeams.append(Beam(x, height - 1, .up))
        }
        
        for y in 0 ..< height {
            startBeams.append(Beam(0, y, .right))
            startBeams.append(Beam(width - 1, y, .left))
        }
        
        var maximum = 0
        for startBeam in startBeams {
            let energizedCount = energizedTilesCount(startBeam: startBeam)
            if energizedCount > maximum {
                maximum = energizedCount
            }
        }
        
        return maximum
    }
}
