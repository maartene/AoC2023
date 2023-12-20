import XCTest
@testable import day20

class PulseSystem {
    let modules: [String: Module]
    var spy: String?
    var spyFound = false
    
    init(_ inputString: String, spy: String? = nil) {
        let lines = inputString.split(separator: "\n").map { String($0) }
        
        self.spy = spy
        
        let nonConjunctions = lines.filter { $0.first != "&" }
        var modules = nonConjunctions.reduce(into: [String:Module]()) { result, line in
            let module = makeModule(line)
            result[module.name] = module
        }
        
        let conjunctions = lines.filter { $0.first == "&" }
            .map { makeModule($0) }
        
        for conjunction in conjunctions {
            modules[conjunction.name] = conjunction
        }
        
        // pre-populate incoming connections
        for module in conjunctions {
            if let conjunction = module as? Conjunction {
                let incomingModules = modules.filter { $0.value.targetModuleNames.contains(conjunction.name) }
                    .map { $0.key }
                for incomingModuleName in incomingModules {
                    conjunction.lastReceivedPulses.append(Pulse(origin: incomingModuleName, value: .low, targetModuleName: conjunction.name))
                }
            }
        }
        
        //modules.append(Output())
        self.modules = modules
    }
    
    
    func pushButton() {
        var pulses = [Pulse(origin: "button", value: .low, targetModuleName: "broadcaster")]
        
        while pulses.isEmpty == false && spyFound == false {
            // get the oldest Pulse and remove it from the 'queue'
            let pulse = pulses[0]
            pulses = Array(pulses.dropFirst())
            
            //print("\(pulse.value) -> \(pulse.targetModuleName)")
            
            if pulse.value == .low {
                lowPulses += 1
            } else {
                highPulses += 1
            }
            
//            if pulse.targetModuleName == "rx" && pulse.value == .low {
//                rx = true
//            }
            
            if let spy, pulse.targetModuleName == spy && pulse.value == .low {
                spyFound = true
            }
            
            if let module = modules[pulse.targetModuleName] {
                //print(module.name)
                let newPulses = module.receive(pulse)
                pulses.append(contentsOf: newPulses)
            }
        }
    }
    
    var lowPulses = 0
    var highPulses = 0
}

struct Pulse: Equatable {
    enum PulseValue {
        case low
        case high
    }
    
    let origin: String
    let value: PulseValue
    let targetModuleName: String
    
    init(origin: String, value: PulseValue, targetModuleName: String) {
        self.origin = origin
        self.value = value
        self.targetModuleName = targetModuleName
    }
}

protocol Module: CustomStringConvertible {
    var name: String { get }
    var targetModuleNames: [String] { get }
    
    func receive(_ pulse: Pulse) -> [Pulse]
}

class Broadcaster: Module {
    let name: String
    let targetModuleNames: [String]
    
    init(name: String, targetModuleNames: [String]) {
        self.name = name
        self.targetModuleNames = targetModuleNames
    }
    
    func receive(_ pulse: Pulse) -> [Pulse] {
        targetModuleNames.map {
            Pulse(origin: name, value: pulse.value, targetModuleName: $0)
        }
    }
    
    var description: String {
        name + " " + targetModuleNames.joined(separator: " ")
    }
}

class Flipflop: Module {
    let name: String
    let targetModuleNames: [String]
    var state = false
    
    init(name: String, targetModuleNames: [String]) {
        self.name = name
        self.targetModuleNames = targetModuleNames
    }
    
    func receive(_ pulse: Pulse) -> [Pulse] {
        guard pulse.value == .low else {
            return []
        }
        
        state.toggle()
        
        return targetModuleNames.map {
            Pulse(origin: name, value: state ? .high : .low, targetModuleName: $0)
        }
    }
    
    var description: String {
        name + " " + targetModuleNames.joined(separator: " ") + " \(state)"
    }
}

class Conjunction: Module {
    let name: String
    let targetModuleNames: [String]
    
    var lastReceivedPulses = [Pulse]()
    
    init(name: String, targetModuleNames: [String], incomingModuleNames: [String] = []) {
        self.name = name
        self.targetModuleNames = targetModuleNames
        
        for incomingModuleName in incomingModuleNames {
            lastReceivedPulses.append(Pulse(origin: incomingModuleName, value: .low, targetModuleName: name))
        }
    }
    
    func lastReceivedPulseValueFor(_ moduleName: String) -> Pulse.PulseValue {
        lastReceivedPulses.first { $0.targetModuleName == moduleName }?.value ?? .low
    }
    
    func receive(_ pulse: Pulse) -> [Pulse] {
        // update lastReceivedPulses
        if let existingIndex = lastReceivedPulses.firstIndex(where: { $0.origin == pulse.origin }) {
            lastReceivedPulses[existingIndex] = pulse
        }
        
        let allHigh = lastReceivedPulses.reduce(true) { result, pulse in
            result && (pulse.value == .high)
        }
        
        if allHigh {
            return targetModuleNames.map {
                Pulse(origin: name, value: .low, targetModuleName: $0)
            }
        } else {
            return targetModuleNames.map {
                Pulse(origin: name, value: .high, targetModuleName: $0)
            }
        }
    }
    
    var description: String {
        name + " " + lastReceivedPulses.description
    }
}

func makeModule(_ inputString: String) -> Module {
    let splits = inputString.split(separator: " -> ")
    
    let targetModuleNames = splits[1].split(separator: ",")
        .map { String($0) }
        .map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    
    let moduleName = String(splits[0].dropFirst())
    
    switch splits[0].first {
    // Broadcaster
    case "b":
        let targetModuleNames = splits[1].split(separator: ",")
            .map { String($0) }
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        return Broadcaster(name: "broadcaster", targetModuleNames: targetModuleNames)
    case "%":
        return Flipflop(name: moduleName, targetModuleNames: targetModuleNames)
    case "&":
        return Conjunction(name: moduleName, targetModuleNames: targetModuleNames)
    default:
        return Empty()
    }
}

class Empty: Module {
    let name = "Empty"
    
    let targetModuleNames = [String]()
    
    func receive(_ pulse: Pulse) -> [Pulse] {
        []
    }
    
    let description = "Empty"
    
    
}

// MARK: Part 2
func countUntilRXLow(_ inputString: String) -> Int {
    func countUntilSpy(_ spy: String, inputString: String) -> Int {
        let pulseSystem = PulseSystem(inputString, spy: spy)
        var count = 0
        while pulseSystem.spyFound == false {
            count += 1
            pulseSystem.pushButton()
        }
        return count
    }
    
    let keys = ["bt", "fv", "rd", "pr"]
    let counts = keys.map { countUntilSpy($0, inputString: inputString)}
    
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
    
    return lcm(of: counts)
}

final class day20Tests: XCTestCase {
    let exampleInput =
    """
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
    """
    
    func test_broadcaster_sendsLowPulse_toModules_abc() {
        let modules = [
            "a", "b", "c"
        ]
        
        let broadcaster = Broadcaster(name: "broadcaster", targetModuleNames: modules)
        let pulse = Pulse(origin: "button", value: .low, targetModuleName: "broadcaster")
        let result = broadcaster.receive(pulse)
        
        let expected = [
            Pulse(origin: "broadcaster", value: .low, targetModuleName: "a"),
            Pulse(origin: "broadcaster", value: .low, targetModuleName: "b"),
            Pulse(origin: "broadcaster", value: .low, targetModuleName: "c"),
        ]
        
        XCTAssertEqual(result, expected)
    }
    
    func test_makeModule_broadcaster() {
        let broadcaster = makeModule("broadcaster -> a, b, c")
        
        XCTAssertTrue(broadcaster is Broadcaster)
        XCTAssertEqual(broadcaster.targetModuleNames, ["a", "b", "c"])
    }
    
    func test_makeModule_flipflop() {
        let flipflop = makeModule("%a -> inv, con")
        XCTAssertTrue(flipflop is Flipflop)
        XCTAssertEqual(flipflop.name, "a")
        XCTAssertEqual(flipflop.targetModuleNames, ["inv", "con"])
    }
    
    func test_makeModule_conjunction() {
        let conjunction = makeModule("&inv -> a")
        XCTAssertTrue(conjunction is Conjunction)
        XCTAssertEqual(conjunction.name, "inv")
        XCTAssertEqual(conjunction.targetModuleNames, ["a"])
    }
    
    // Flip-flop
    
    func test_flipflop_ignoresHighPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: [])
        let result = flipflop.receive(Pulse(origin: "", value: .high, targetModuleName: "ff"))
        XCTAssertEqual(result, [])
        XCTAssertEqual(flipflop.state, false)
    }
    
    func test_flipflop_becomesOn_whenOff_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: [])
        _ = flipflop.receive(Pulse(origin: "", value: .low, targetModuleName: "ff"))
        XCTAssertEqual(flipflop.state, true)
    }
    
    func test_flipflop_sendsLowPulse_whenOff_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: ["foo"])
        let result = flipflop.receive(Pulse(origin: "", value: .low, targetModuleName: "ff"))
        XCTAssertEqual(result, [Pulse(origin: "ff", value: .high, targetModuleName: "foo")])
    }
    
    func test_flipflop_becomesOff_whenOn_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: [])
        flipflop.state = true
        _ = flipflop.receive(Pulse(origin: "", value: .low, targetModuleName: "ff"))
        XCTAssertEqual(flipflop.state, false)
    }
    
    func test_flipflop_sendsHighPulse_whenOn_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: ["foo"])
        flipflop.state = true
        let result = flipflop.receive(Pulse(origin: "", value: .low, targetModuleName: "ff"))
        XCTAssertEqual(result, [Pulse(origin: "ff", value: .low, targetModuleName: "foo")])
    }
    
    // Conjunction
    func test_conjunction_defaultsToLowPulse_forLastReceivedPulse() {
        let conjunction = Conjunction(name: "c", targetModuleNames: [], incomingModuleNames: ["b"])
        XCTAssertEqual(conjunction.lastReceivedPulseValueFor("b"), .low)
    }
    
    //Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected input modules; they initially default to remembering a low pulse for each input. When a pulse is received, the conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.
    
    func test_conjunction_invertsIncomingSignal() {
        let conjunction = Conjunction(name: "c", targetModuleNames: ["bar", "baz"], incomingModuleNames: ["o"])
        var result = conjunction.receive(Pulse(origin: "o", value: .low, targetModuleName: "foo"))
        XCTAssertEqual(result[0].value, .high)
        result = conjunction.receive(Pulse(origin: "o",value: .high, targetModuleName: "foo"))
        XCTAssertEqual(result[0].value, .low)
    }
    
    func test_conjunction_returnsLow_ifAllHighPulses() {
        let conjunction = Conjunction(name: "c", targetModuleNames: ["bar", "baz"], incomingModuleNames: ["a", "b", "d"])
        conjunction.lastReceivedPulses = [Pulse(origin: "a",value: .high, targetModuleName: "c"), Pulse(origin: "b",value: .high, targetModuleName: "c"), Pulse(origin: "d",value: .low, targetModuleName: "c")]
        let result = conjunction.receive(Pulse(origin: "d",value: .high, targetModuleName: "c"))
        XCTAssertEqual(result[0].value, .low)
    }
    
    func test_conjunction_returnsHigh_ForMixedSignals() {
        let conjunction = Conjunction(name: "c", targetModuleNames: ["bar", "baz"], incomingModuleNames: ["a", "b", "d"])
        conjunction.lastReceivedPulses = [Pulse(origin: "a", value: .high, targetModuleName: "c"), Pulse(origin: "b", value: .low, targetModuleName: "c")]
        let result = conjunction.receive(Pulse(origin: "d", value: .high, targetModuleName: "c"))
        XCTAssertEqual(result[0].value, .high)
    }
    
    func test_afterExampleSequence_allFlipFlopsAreOff() {
        let pulseSystem = PulseSystem(exampleInput)
        pulseSystem.pushButton()
        
        let flipflops = pulseSystem.modules.values.compactMap { $0 as? Flipflop }
        for flipflop in flipflops {
            XCTAssertEqual(flipflop.state, false)
        }
    }
    
    let exampleInput2 =
    """
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
    output -> foo
    """
    
    func test_pulseSystem_pulseValueAfter1000presses_withExampleInput() {
        let pulseSystem = PulseSystem(exampleInput)
        
        for _ in 0 ..< 1000 {
            pulseSystem.pushButton()
        }
        
        XCTAssertEqual(pulseSystem.lowPulses, 8000)
        XCTAssertEqual(pulseSystem.highPulses, 4000)
    }
    
    func test_pulseSystem_pulseValueAfter1000presses_withExampleInput2() {
        let pulseSystem = PulseSystem(exampleInput2)
        
        for _ in 0 ..< 1000 {
            pulseSystem.pushButton()
        }
        
        XCTAssertEqual(pulseSystem.lowPulses, 4250)
        XCTAssertEqual(pulseSystem.highPulses, 2750)
    }
    
    func test_part1() {
        let pulseSystem = PulseSystem(input)
        
        for _ in 0 ..< 1000 {
            pulseSystem.pushButton()
        } 
        
        XCTAssertEqual(pulseSystem.lowPulses, 17150)
        XCTAssertEqual(pulseSystem.highPulses, 45997)
        XCTAssertEqual(pulseSystem.lowPulses * pulseSystem.highPulses, 788848550 )
    }
    
    func test_part2() {
        let result = countUntilRXLow(input)
        XCTAssertEqual(result, 228_300_182_686_739)
        
    }
}
