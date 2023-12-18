import Foundation

struct DigPlan {
    
    let vertices: [Vector2D]
    let circumference: Int
    
    init(_ inputString: String, useHex: Bool) {
        let lines = inputString.split(separator: "\n").map { String($0) }
        var cursor = Vector2D(x: 0, y: 0)
        var circumference = 0
        var vertices = [Vector2D.zero]
        for line in lines {
            let splits = line.split(separator: " ").map { String($0) }
            
            let hexStringValues = splits[2].map { String($0) }
            let hexString = hexStringValues[2...6].joined()
            
            let value = useHex ? Int(hexString, radix: 16)! : Int(splits[1])!
            let direction = useHex ? hexStringValues[7] : splits[0]
            
            circumference += value
            
            switch direction {
            case "0", "R": // right
                cursor = cursor + Vector2D(x: value, y: 0)
            case "2", "L": // left
                cursor = cursor + Vector2D(x: -value, y: 0)
            case "3", "U": // up
                cursor = cursor + Vector2D(x: 0, y: -value)
            case "1", "D": // down
                cursor = cursor + Vector2D(x: 0, y: value)
            default:
                fatalError("Unknown token \(direction)")
                break
            }
            vertices.append(cursor)
            
        }
                
        self.vertices = vertices
        self.circumference = circumference
        
    }
    
    var insideCount: Int {
        var sum = 0
        for i in 0 ..< vertices.count {
            //sum += 1
            sum += vertices[i].x * vertices[(i + 1) % vertices.count].y -
            vertices[i].y * vertices[(i + 1) % vertices.count].x
        }
        return abs(sum / 2) + abs(circumference / 2) + 1
    }
    
}
