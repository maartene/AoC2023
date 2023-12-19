import Foundation


struct Part {
    let properties: [Character: Int]
    
    init(properties: [Character: Int] = ["x": 0, "m": 0, "a": 0, "s": 0]) {
        self.properties = properties
    }
    
    init(_ partString: String) {
        // {x=787,m=2655,a=1222,s=2876}
        var properties = [Character: Int]()
        var partString = String(partString.dropLast())
        partString = String(partString.dropFirst())
        let parts = partString.split(separator: ",").map { String($0) }
        for part in parts {
            let propertySplits = part.split(separator: "=").map { String($0) }
            properties[Character(propertySplits[0])] = Int(propertySplits[1])!
        }
        
        self.properties = properties
    }
    
    var ratingsValue: Int {
        properties.values.reduce(0, +)
    }
}

struct Rule: Equatable {
    enum Result: Equatable {
        case accepted
        case rejected
        case redirect(String)
        case pass
    }
    
    let property: Character?
    let comparator: Character?
    let treshold: Int?
    
    let redirect: String
    
    init(property: Character?, comparator: Character?, treshold: Int?, redirect: String) {
        self.property = property
        self.comparator = comparator
        self.treshold = treshold
        self.redirect = redirect
    }
    
    init(_ ruleString: String) {
        
        if ruleString.contains(":") {
            var ruleString = ruleString
            
            if ruleString.first == "{" {
                ruleString = String(ruleString.dropFirst())
            }
            
            let conditionRedirectSplit = ruleString.split(separator: ":").map { String($0) }
            let comparatorSplit = conditionRedirectSplit[0]
                .split(whereSeparator: { $0 == "<" || $0 == ">" }).map { String($0) }
            property = Character(comparatorSplit[0])
            treshold = Int(comparatorSplit[1])
            comparator = conditionRedirectSplit[0].contains(">") ? ">" : "<"
            redirect = conditionRedirectSplit[1]
        } else {
            property = nil
            comparator = nil
            treshold = nil
            var ruleString = ruleString
            if ruleString.last == "}" {
                ruleString = String(ruleString.dropLast())
            }
            redirect = ruleString
        }
    }
    
    var ruleString: String {
        var result = ""
        if let property, let comparator, let treshold {
            result += "\(property)\(comparator)\(treshold):\(redirect)"
        } else {
            result += redirect
        }
        return result
    }

    
    func matches(_ part: Part) -> Bool {
        guard let property, let comparator, let treshold else {
            return true
        }
        
        if comparator == ">" {
            return part.properties[property]! > treshold
        } else { // comparator must be "<"
            return part.properties[property]! < treshold
        }
    }
    
    func evaluate(_ part: Part) -> Result {
        guard matches(part) else {
            return .pass
        }
        
        if redirect == "A" {
            return .accepted
        } else if redirect == "R" {
            return .rejected
        } else {
            return .redirect(redirect)
        }
        
    }
}

struct Workflow: Equatable {
    let name: String
    let rules: [Rule]
    
    init(name: String, rules: [Rule]) {
        self.name = name
        self.rules = rules
    }

    init(_ workflowString: String) {
        do {
            let nameRegex = try Regex(#"^[a-z]+"#)
            let nameMatch = try nameRegex.firstMatch(in: workflowString)!
            name = String(workflowString[nameMatch.range])
            
            let rulesRegex = try Regex(#"{.*}$"#)
            let rulesMatch = try rulesRegex.firstMatch(in: workflowString)!
            let rules = String(workflowString[rulesMatch.range])
                .split(separator: ",").map { Rule(String($0)) }
            self.rules = rules
        } catch {
            fatalError("Error '\(error)' creating workflow from '\(workflowString)'")
        }
        
    }
    
    func evaluate(_ part: Part) -> Rule.Result {
        for rule in rules {
            let ruleResult = rule.evaluate(part)
            if ruleResult != .pass {
                return ruleResult
            }
        }
        fatalError("The final rule in a workflow should always match")
    }
}

func extractWorkflows(_ inputString: String) -> [Workflow] {
    let regex = try! Regex(#"^[a-z]+{.*}$"#)
    
    let lines = inputString.split(separator: "\n").map { String($0) }
    return lines.filter { $0.contains(regex) }
        .map { Workflow($0) }
    
}

func extractParts(_ inputString: String) -> [Part] {
    let regex = try! Regex(#"^{.*}$"#)
    
    let lines = inputString.split(separator: "\n").map { String($0) }
    return lines.filter { $0.contains(regex) }
        .map { Part($0) }
}

func processPart(_ part: Part, in workflows: [Workflow]) -> Bool {
    var result = Rule.Result.pass
    var workflow = workflows.first { $0.name == "in" }!
    while result != .accepted && result != .rejected {
        result = workflow.evaluate(part)
        if case .redirect(let string) = result {
            workflow = workflows.first { $0.name == string }!
        }
    }
    
    return result == .accepted
}

// MARK: Part 2

func getAcceptedPartsSum(_ inputString: String) -> Int {
    let workflows = extractWorkflows(inputString)
    let parts = extractParts(inputString)
    
    let ratings = parts
        .filter { processPart($0, in: workflows) }
        .map { $0.ratingsValue }
    
    return ratings.reduce(0, +)
}

func rangesOverlap(_ r1: ClosedRange<Int>, _ r2: ClosedRange<Int>) -> ClosedRange<Int> {
    if r1.overlaps(r2) {
        return (max(r1.lowerBound, r2.lowerBound) ... min(r1.upperBound, r2.upperBound))
    } else {
        return (0...0)
    }
}

extension Rule {
    func successRanges(ranges: [Character: ClosedRange<Int>]) -> [Character: ClosedRange<Int>] {
        if let property, let comparator, let treshold {
            var updatedRange = ranges[property]!
            if comparator == ">" {
                let ownRange = (treshold + 1 ... 4000)
                updatedRange = rangesOverlap(ownRange, updatedRange)
            } else {
                let ownRange = (0 ... treshold - 1)
                updatedRange = rangesOverlap(ownRange, updatedRange)
            }
            var updatedRanges = ranges
            updatedRanges[property] = updatedRange
            return updatedRanges
        } else {
            return ranges
        }
    }
    
    func failureRanges(ranges: [Character: ClosedRange<Int>]) -> [Character: ClosedRange<Int>] {
        if let property, let comparator, let treshold {
            var updatedRange = ranges[property]!
            if comparator == ">" {
                let ownRange = (1 ... treshold)
                updatedRange = rangesOverlap(ownRange, updatedRange)
            } else { // <
                let ownRange = (treshold ... 4000)
                updatedRange = rangesOverlap(ownRange, updatedRange)
            }
            var updatedRanges = ranges
            updatedRanges[property] = updatedRange
            return updatedRanges
        } else {
            return ranges
        }
    }
}

extension Workflow {
    func split() -> [Workflow] {
        guard name != "in" else {
            return [
                Workflow(name: "in", rules: [
                    Rule(property: rules[0].property, comparator: rules[0].comparator, treshold: rules[0].treshold, redirect: rules[0].redirect + "1"),
                    Rule(property: rules[1].property, comparator: rules[1].comparator, treshold: rules[1].treshold, redirect: rules[1].redirect + "1"),
                ])
            ]
        }
        // "px{a<2006:qkq,m>2090:A,rfg}"
        
        var result = [Workflow]()
        for i in 0 ..< rules.count - 1 {
            if i == rules.count - 2 {
                let rule = rules[i]
                let redirectRule1 = ["A", "R"].contains(rule.redirect) ? rule.redirect : rule.redirect + "1"
                let rule1 = Rule(property: rule.property, comparator: rule.comparator, treshold: rule.treshold, redirect: redirectRule1)
                let nextRule = rules[i+1]
                let redirectRule2 = ["A", "R"].contains(nextRule.redirect) ? nextRule.redirect : nextRule.redirect + "1"
                let rule2 = Rule(property: nil, comparator: nil, treshold: nil, redirect: redirectRule2)
                let workflow = Workflow(name: name + String(i + 1), rules: [rule1, rule2])
                result.append(workflow)
            } else {
                let redirectRule1 = ["A", "R"].contains(rules[i].redirect) ? rules[i].redirect : rules[i].redirect + "1"
                let rule1 = Rule(property: rules[i].property, comparator: rules[i].comparator, treshold: rules[i].treshold, redirect: redirectRule1)
                let rule2 = Rule(property: nil, comparator: nil, treshold: nil, redirect: name + String(i + 2))
                let workflow = Workflow(name: name + String(i + 1), rules: [rule1, rule2])
                result.append(workflow)
            }
        }

        return result
    }
    
    var workflowString: String {
        var result = "\(name){"
        result += rules.map { $0.ruleString }.joined(separator: ",")
        result += "}"
        return result
    }
}

func getSum(_ inputString: String) -> Int {
    func calculateValueForRule(_ ruleName: String, in workflows: [Workflow], ranges: [Character: ClosedRange<Int>]) -> Int {
        if ruleName == "A" {
            var result = 1
            for range in ranges.values {
                result = range.count * result
            }
            return result
        } else if ruleName == "R" {
            return 0
        }
        
        let workflow = workflows.first(where: { $0.name == ruleName })!
        let rule1 = workflow.rules[0]
        let rule2 = workflow.rules[1]
        
        let successRanges = rule1.successRanges(ranges: ranges)
        
        let failureRanges = rule1.failureRanges(ranges: ranges)
        
        return calculateValueForRule(rule1.redirect, in: workflows, ranges: successRanges) +
        calculateValueForRule(rule2.redirect, in: workflows, ranges: failureRanges)
    }
    
    let workflows = extractWorkflows(inputString)
    let expandedWorkflows = workflows.flatMap { $0.split() }
    
    let ranges: [Character: ClosedRange<Int>] = [
        "x": (1...4000),
        "m": (1...4000),
        "a": (1...4000),
        "s": (1...4000),
    ]
    
    return calculateValueForRule("in", in: expandedWorkflows, ranges: ranges)
}



