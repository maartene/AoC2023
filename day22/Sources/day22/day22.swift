import Foundation

class BrickStack {
    var size: Vector3D
    var bricks: [Int: Brick]
    var movedBricksSet = Set<Int>()
    
    init(_ inputString: String) {
        let rawBricks = inputString.split(separator: "\n").map { String($0) }
            .map { Brick($0) }
        
        var bricks = [Int: Brick]()
        for (index, brick) in rawBricks.enumerated() {
            bricks[index] = brick
        }
        
        self.bricks = bricks
        
        let maxStartX = bricks.values.map { $0.start.x }.max()!
        let maxStartY = bricks.values.map { $0.start.y }.max()!
        let maxStartZ = bricks.values.map { $0.start.z }.max()!
        
        let maxEndX = bricks.values.map { $0.end.x }.max()!
        let maxEndY = bricks.values.map { $0.end.y }.max()!
        let maxEndZ = bricks.values.map { $0.end.z }.max()!
        
        let sizeX = max(maxStartX, maxEndX)
        let sizeY = max(maxStartY, maxEndY)
        let sizeZ = max(maxStartZ, maxEndZ)
        
        size = Vector3D(x: sizeX, y: sizeY, z: sizeZ)
    }
    
    var xzDescription: String {
        var result = ""
        let height = size.z + 1
        let width = size.x + 1
        
        // x
        result += String.init(repeating: " ", count: width / 2) + "x\n"
        
        // 012
        for x in 0 ..< width {
            result += "\(x)"
        }
        result += "\n"
        
        // rows
        for dz in 1 ..< height {
            let z = height - dz
            var line = ""
            for x in 0 ..< width {
                let bricksAtXZ = bricks.filter { ($0.value.start.x ... $0.value.end.x).contains(x) && ($0.value.start.z ... $0.value.end.z).contains(z) }
                switch bricksAtXZ.count {
                case 0:
                    line += "."
                case 1:
                    let A = Character("A").asciiValue!
                    if bricksAtXZ.first!.key < 255 {
                        let key = String(UnicodeScalar(A + UInt8(bricksAtXZ.first!.key)))
                        line += key
                    } else {
                        line += "*"
                    }
                    
                default:
                    line += "?"
                }
            }
            line += " \(z)"
            if z == height / 2 {
                line += " z"
            }
            result += line + "\n"
        }
        
        result += String.init(repeating: "-", count: width) + " 0"
        
        //print(result)
        
        return result
    }
    
    var yzDescription: String {
        var result = ""
        let height = size.z + 1
        let depth = size.y + 1
        
        // x
        result += String.init(repeating: " ", count: depth / 2) + "y\n"
        
        // 012
        for y in 0 ..< depth {
            result += "\(y)"
        }
        result += "\n"
        
        // rows
        for dz in 1 ..< height {
            let z = height - dz
            var line = ""
            for y in 0 ..< depth {
                let bricksAtYZ = bricks.filter { ($0.value.start.y ... $0.value.end.y).contains(y) && ($0.value.start.z ... $0.value.end.z).contains(z) }
                switch bricksAtYZ.count {
                case 0:
                    line += "."
                case 1:
                    let A = Character("A").asciiValue!
                    if bricksAtYZ.first!.key < 255 {
                        let key = String(UnicodeScalar(A + UInt8(bricksAtYZ.first!.key)))
                        line += key
                    } else {
                        line += "*"
                    }
                default:
                    line += "?"
                }
            }
            line += " \(z)"
            if z == height / 2 {
                line += " z"
            }
            result += line + "\n"
        }
        
        result += String.init(repeating: "-", count: depth) + " 0"
        
        //print(result)
        
        return result
    }
    
    func settle(overrideStartAtZ: Int = 2) {
        var shouldSettle = true
        var startAtZ = overrideStartAtZ
        while shouldSettle {
            //print(startAtZ)
            let result = settle1Step(startAtZ: startAtZ)
            shouldSettle = result.0
            startAtZ = max(overrideStartAtZ, result.1 - 1)
        }
        
        let maxZ = bricks.values.map { $0.end.z }.max()!
        size = Vector3D(x: size.x, y: size.y, z: maxZ)
    }
    
    func settle1Step(startAtZ: Int) -> (Bool, Int) {
        var maxZ = startAtZ
        for z in startAtZ ... size.z {
            maxZ = max(z, maxZ)
            if let brick = findBrickToMoveAt(z: z) {
                bricks[brick.key] = Brick(start: brick.value.start + Vector3D.down, end: brick.value.end + Vector3D.down)
                movedBricksSet.insert(brick.key)
                return (true, maxZ)
            }
        }
        
        return (false, maxZ)
    }
    
    func findBrickToMoveAt(z: Int) -> (key: Int, value: Brick)? {
        for brickAtZ in bricks.filter({ $0.value.start.z == z }) {
            if brickCanMoveDown(brickAtZ) {
                return brickAtZ
            }
        }
        return nil
    }
    
    func brickCanMoveDown(_ brick: (key: Int, value: Brick)) -> Bool {
        guard brick.value.start.z > 1 else {
            return false
        }
        
        let oneDown = Brick(start: brick.value.start + Vector3D.down, end: brick.value.end + Vector3D.down)
        for otherBlock in bricks.filter({ $0.key != brick.key &&
            ($0.value.start.z ... $0.value.end.z).contains(oneDown.start.z)
        }) {
            if otherBlock.value.overlapsWith(oneDown) {
                return false
            }
        }
        
        return true
    }
    
    func canBrickBeDisintegrated(_ blockKey: Int) -> Bool {
        let backupBricks = bricks
        bricks.removeValue(forKey: blockKey)
        
        let result = settle1Step(startAtZ: 2).0 == false
        
        bricks = backupBricks
        
        return result
    }
    
    func countBricksThatCanSafelyDisintegrated() -> Int {
        var progress = 0
        var count = 0
        for key in bricks.keys {
            progress += 1
            print("\(progress) of \(bricks.count)")
            if canBrickBeDisintegrated(key) {
                count += 1
            }
        }
        return count
    }
    
    func countChainReaction(brickKey: Int) -> Int {
        let backupBricks = bricks
        let backupSize = size
        movedBricksSet.removeAll()
        let brick = bricks[brickKey]!
        bricks.removeValue(forKey: brickKey)
        
        settle(overrideStartAtZ: brick.start.z)
        
        bricks = backupBricks
        size = backupSize
        
        return movedBricksSet.count
    }
    
    func sumOfchainReactions() -> Int {
        var progress = 0
        var sum = 0
        for key in bricks.keys {
            progress += 1
            print("\(progress) of \(bricks.count)")
            sum += countChainReaction(brickKey: key)
        }
        return sum
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
extension Brick: Hashable { }

extension Vector3D {
    static var down: Vector3D {
        Vector3D(x: 0, y: 0, z: -1)
    }
}
