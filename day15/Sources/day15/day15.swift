import Foundation
import Collections

// MARK: Part 1

func asciiHash(_ string: String) -> Int {
    // Determine the ASCII code for the current character of the string.
    
    let asciiArray = string.compactMap { $0.asciiValue }
    
    var hashValue = 0
    for value in asciiArray {
        // Increase the current value by the ASCII code you just determined.
        hashValue += Int(value)
    
        // Set the current value to itself multiplied by 17.
        hashValue *= 17
        
        // Set the current value to the remainder of dividing itself by 256.
        hashValue = hashValue % 256
    }
    
    return hashValue
}

func hashString(_ input: String) -> Int {
    let hashes = input.split(separator: ",").map { asciiHash(String($0)) }
    return sumNumbers(hashes)
}

func sumNumbers(_ numbers: [Int]) -> Int {
    numbers.reduce(0, +)
}

// MARK: Part 2
class LensBoxContainer {
    var boxes: [OrderedDictionary<String, Int>]
    
    init() {
        boxes = []
        for _ in 0 ..< 256 {
            boxes.append([:])
        }
    }
    
    func interpret(_ commands: Array<String>.SubSequence) {
        for command in commands {
            interpret(command)
        }
    }
    
    func interpret(_ commands: [String]) {
        for command in commands {
            interpret(command)
        }
    }
    
    func interpret(_ commandString: String) {
        let assignCommand = commandString.split(separator: "=")
        
        let dashCommand = commandString.split(separator: "-")
        
        if assignCommand.count == 2 {
            let label = String(assignCommand[0])
            let boxNumber = asciiHash(label)
            let focalLength = Int(assignCommand[1])!
            boxes[boxNumber][label] = focalLength
        } else if dashCommand.count == 1 {
            let label = String(dashCommand[0])
            let boxNumber = asciiHash(label)
            boxes[boxNumber].removeValue(forKey: label)
        }
        
        
    }
    
    func getLensPower(_ label: String) -> Int {
        let boxNumber = asciiHash(label)
        let slotNumber: Int = boxes[boxNumber].elements.firstIndex { $0.key == label }!
        let focalLength = boxes[boxNumber][label]!
        
        return (boxNumber + 1) * (slotNumber + 1) * focalLength
        
    }
    
    var totalFocalPower: Int {
        let filledBoxes = boxes.filter { $0.isEmpty == false }
        
        var result = 0
        for filledBox in filledBoxes {
            for lens in filledBox {
                result += getLensPower(lens.key)
            }
        }
        
        return result
    }
}
