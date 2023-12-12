import Foundation

func pow2(_ exponent: Int) -> Int {
    var result = 1
    for _ in 0 ..< exponent {
        result *= 2
    }
    return result
}

func calculatePermutations(_ inputString: String, continuousGroups: [Int]) throws -> Int {
    // naive approach
    let inputArray = inputString.split(separator: "").map { String($0) }
    
    let questionMarkCount = inputArray.filter( { $0 == "?" } ).count
    
    var regexString = "^(\\.*)"
    for i in 0 ..< continuousGroups.count {
        for _ in 0 ..< continuousGroups[i] {
            regexString += "#"
        }
        regexString += i == continuousGroups.count - 1 ? "(\\.*)\\Z" : "(\\.+)"
    }
    
    // and filter the ones that fit regular expression
    let regex = try Regex(regexString)
    
    var possibleCases = 0
    for i in 0 ..< pow2(questionMarkCount) {
        var possibleCase = inputArray
        let binaryString = String(String(i, radix: 2).reversed()).padding(toLength: questionMarkCount, withPad: "0", startingAt: 0)
        let binaryStringArray = binaryString.split(separator: "").map { String($0) }
        var qmIndex = 0
        for j in 0 ..< inputArray.count {
            if inputArray[j] == "?" {
                if qmIndex < binaryStringArray.count && binaryStringArray[qmIndex] == "1" {
                    possibleCase[j] = "#"
                } else {
                    possibleCase[j] = "."
                }
                qmIndex += 1
            }
        }
        if possibleCase.joined().contains(regex) {
            possibleCases += 1
        }
    }
    
    return possibleCases
}

func countPermutations(_ input: String) throws -> [Int] {
    let lines = input.split(separator: "\n").map { String($0) }
    
    var result = [Int]()
    for i in 0 ..< lines.count {
        let line = lines[i]
        let lineSplits = line.split(separator: " ").map { String($0) }
        let inputString = lineSplits[0]
        let groups = lineSplits[1].split(separator: ",").compactMap {
            Int(String($0))
        }
        result.append(try calculatePermutations(inputString, continuousGroups: groups))
        print("\(Double(result.count) / Double(lines.count) * 100)%")
    }

    return result
}

func sumCountPermutations(_ input: String) throws -> Int {
    let counts = try countPermutations(input)

    return counts.reduce(0, +)
}

func countArrangements2(line: String, counts: [Int]) -> Int {
    let line = Array(line.utf8)
    let n = line.count
    let m = counts.count
    var dp = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1), count: n + 1)

    dp[n][m][0] = 1
    dp[n][m - 1][counts[m - 1]] = 1

    for pos in stride(from: n - 1, through: 0, by: -1) {
        for (group, maxCount) in counts.enumerated() {
            for count in 0...maxCount {
                for c in [UInt8(ascii: "."), UInt8(ascii: "#")] {
                    if line[pos] == c || line[pos] == UInt8(ascii: "?") {
                        if c == UInt8(ascii: ".") && count == 0 {
                            dp[pos][group][count] += dp[pos + 1][group][0]
                        } else if c == UInt8(ascii: ".") && group < m && counts[group] == count {
                            dp[pos][group][count] += dp[pos + 1][group + 1][0]
                        } else if c == UInt8(ascii: "#") {
                            dp[pos][group][count] += dp[pos + 1][group][count + 1]
                        }
                    }
                }
            }
        }
        if line[pos] == UInt8(ascii: ".") || line[pos] == UInt8(ascii: "?") {
            dp[pos][m][0] += dp[pos + 1][m][0]
        }
    }

    return dp[0][0][0]
}
