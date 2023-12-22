import Foundation

class BrickStack {
    init(_ inputString: String) {
        
    }
    
    var xzDescription: String {
        ""
    }
    
    var yzDescription: String {
        ""
    }
    
}

struct Brick {
    let start: Vector3D
    let end: Vector3D
    
    init(start: Vector3D, end: Vector3D) {
        self.start = start
        self.end = end
    }
    
    init(_ inputString: String) {
        let vectorStrings = inputString.split(separator: "~").map { String($0) }
        let startVector = vectorStrings[0].split(separator: ",").map { Int(String($0))! }
        let endVector = vectorStrings[1].split(separator: ",").map { Int(String($0))! }
        
        let start = Vector3D(x: startVector[0], y: startVector[1], z: startVector[2])
        let end = Vector3D(x: endVector[0], y: endVector[1], z: endVector[2])
        
        self.init(start: start, end: end)
    }
    
    var size: Int {
        abs(start.x - end.x + start.y - end.y + start.z - end.z)
    }
    
    func overlapsWith(_ brick: Brick) -> Bool {
        let xOverlap = (start.x ... end.x).overlaps(brick.start.x ... brick.end.x)
        let yOverlap = (start.y ... end.y).overlaps(brick.start.y ... brick.end.y)
        let zOverlap = (start.z ... end.z).overlaps(brick.start.z ... brick.end.z)
        
        return xOverlap && yOverlap && zOverlap
    }
    
    func isSupportingBrick(_ brick: Brick) -> Bool {
        let top = end.z + 1
        
        assert(overlapsWith(brick) == false)
        
        guard brick.start.z == top else {
            return false
        }
        
        let xOverlap = (start.x ... end.x).overlaps(brick.start.x ... brick.end.x)
        let yOverlap = (start.y ... end.y).overlaps(brick.start.y ... brick.end.y)
        
        return xOverlap && yOverlap
        
    }
}

extension Brick: Equatable { }
