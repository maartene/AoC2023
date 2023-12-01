import Foundation

func calculateCalibrationFactor(_ input: String) -> Int {
    let lines = input
        .split(separator: "\n").map { String($0) }
    return lines.map { calculateCalibrationFactorForLine($0) }.reduce(0, +)
}

func calculateCalibrationFactorForLine(_ input: String) -> Int {
    let replacementMap = [
        "one": "one1one",
        "two": "two2two",
        "three": "three3three",
        "four": "four4four",
        "five": "five5five",
        "six": "six6six",
        "seven": "seven7seven",
        "eight": "eight8eight",
        "nine": "nine9nine",
        "zero": "zero0zero"
    ]
    
    var mappedString = input
    for replacement in replacementMap {
        mappedString = mappedString.replacingOccurrences(of: replacement.key, with: replacement.value)
    }

    let characters = mappedString.map { Character(String($0)) }
    let digits = characters.compactMap{ Int(String($0)) }
    
    guard digits.count > 0 else {
        return 0
    }
    
    let firstDigit = String(digits.first!)
    let lastDigit = String(digits.last!)

    return Int(firstDigit + lastDigit)!
}
