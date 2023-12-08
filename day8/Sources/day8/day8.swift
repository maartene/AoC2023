import Foundation

struct StepEntry {
    let left: String
    let right: String
    
    init(_ input: String) {
        let words = input.split(separator: " ").map { String($0) }
        left = words[0].filter { $0.isLetter || $0.isNumber }
        right = words[1].filter { $0.isLetter || $0.isNumber }
    }
}

func createSequenceAndStepEntries(_ input: String) -> (sequence: [Character], stepEnties: [String: StepEntry]) {
    let lines = input.split(separator: "\n").map { String($0) }
    let sequence = lines[0].map { $0 }
    
    var stepEntries = [String: StepEntry]()
    for line in lines.dropFirst() {
        let words = line.split(separator: "=").map { String($0) }
        stepEntries[words[0].filter({ $0.isLetter || $0.isNumber } )] = StepEntry(words[1])
    }
    
    return (sequence, stepEntries)
}

func stepsToReachZZZ(_ input: String, for startingStep: String = "AAA", searchForEndZOnly: Bool = false) -> Int {
    let parsedInput = createSequenceAndStepEntries(input)
    let sequence = parsedInput.sequence
    let stepEntries = parsedInput.stepEnties
        
    let endStates = searchForEndZOnly ? stepEntries.filter({ $0.key.last! == "Z" }).keys.map({ $0 as! String }) : ["ZZZ"]
    
    var sequenceIndex = 0
    var currentStepKey = startingStep
    while endStates.contains(currentStepKey) == false {
        let currentStep = stepEntries[currentStepKey]!
        let next = sequence[sequenceIndex % sequence.count] == "R" ? currentStep.right : currentStep.left
        currentStepKey = next
        sequenceIndex += 1
    }
    
    return sequenceIndex
    
}

// MARK: Part 2
func ghostly_stepsToReachZZZ(_ input: String) -> Int {
    func gcd(_ num1: Int, _ num2: Int) -> Int {
        var a = num1
        var b = num2
        while b != 0 {
            let t = b
            b = a % b
            a = t
        }
        return a
    }
    
    func lcm(of numbers: [Int]) -> Int {
        var result = numbers.first ?? 1
        for number in numbers {
            result = (result * number) / gcd(result, number)
        }
        return result
    }
    
    let stepEntries = createSequenceAndStepEntries(input).stepEnties
    
    let startingStepEntries = stepEntries.filter { pair in
        pair.key.last! == "A"
    }.keys.map { String($0) }
    
    //print(startingStepEntries)
    
    let numbers = startingStepEntries.map { entry in
        stepsToReachZZZ(input, for: entry, searchForEndZOnly: true)
    }
        
    return lcm(of: numbers)
}
