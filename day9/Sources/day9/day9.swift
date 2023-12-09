import Foundation

func differences(_ sequence: [Int]) -> [Int] {
    var result = [Int]()
    for i in 0 ..< sequence.count - 1 {
        result.append(sequence[i + 1] - sequence[i])
    }
    return result
}

func allZeroes(_ sequence: [Int]) -> Bool {
    sequence.filter { $0 != 0 }.count == 0
}
 
func predictNext(_ sequence: [Int]) -> Int {
    var sequences = [sequence]
    
    while allZeroes(sequences.last!) == false {
        sequences.append(differences(sequences.last!))
    }
    
    for i in 0 ..< sequences.count {
        sequences[i].append(0)
    }
        
    for i in 1 ... sequences.count - 1 {
        let index = sequences.count - i
        let sequenceBottom = sequences[index]
        var sequenceTop = sequences[index - 1]
        sequenceTop[sequenceTop.count - 1] = sequenceBottom.last! + sequenceTop[sequenceTop.count - 2]
        
        sequences[index - 1] = sequenceTop
    }
        
    return sequences[0].last!
}

func inputToSequences(_ input: String) -> [[Int]] {
    let lines = input.split(separator: "\n").map { String($0) }
    return lines.map { line in
        line.split(separator: " ")
            .map { String($0) }
            .compactMap { Int($0) }
    }
}

func sumPredictedNumbers(_ input: String) -> Int {
    let sequences = inputToSequences(input)
    let predictedNumbers = sequences.map { predictNext($0) }
    return predictedNumbers.reduce(0, +)
}

// MARK: Part 2
func predictPrevious(_ sequence: [Int]) -> Int {
    var sequences = [sequence]
    
    while allZeroes(sequences.last!) == false {
        sequences.append(differences(sequences.last!))
    }
    
    for i in 0 ..< sequences.count {
        sequences[i].insert(0, at: 0)
    }
        
    for i in 1 ... sequences.count - 1 {
        let index = sequences.count - i
        let sequenceBottom = sequences[index]
        var sequenceTop = sequences[index - 1]
        sequenceTop[0] = sequenceTop[1] - sequenceBottom[0]
        
        sequences[index - 1] = sequenceTop
    }
        
    return sequences[0][0]
}

func sumPredictedPreviousNumbers(_ input: String) -> Int {
    let sequences = inputToSequences(input)
    let predictedNumbers = sequences.map { predictPrevious($0) }
    return predictedNumbers.reduce(0, +)
}

