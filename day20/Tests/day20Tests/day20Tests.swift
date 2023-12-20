import XCTest
@testable import day20

class PulseSystem {
    let modules: [String: Module]
    
    init(_ inputString: String) {
        let lines = inputString.split(separator: "\n").map { String($0) }
        let modules = lines.reduce(into: [String:Module]()) { result, line in
            let module = makeModule(line)
            result[module.name] = module
        }
        //modules.append(Output())
        self.modules = modules
    }
    
    
    
    func pushButton() {
        var pulses = [Pulse(value: .low, targetModuleName: "broadcaster")]
        
        while pulses.isEmpty == false {
            // get the oldest Pulse and remove it from the 'queue'
            let pulse = pulses[0]
            pulses = Array(pulses.dropFirst())
            
            //print("\(pulse.value) -> \(pulse.targetModuleName)")
            
            if pulse.value == .low {
                lowPulses += 1
            } else {
                highPulses += 1
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
    
    let value: PulseValue
    let targetModuleName: String
    
    init(value: PulseValue, targetModuleName: String) {
        self.value = value
        self.targetModuleName = targetModuleName
    }
    
    static func low(_ targetModuleName: String) -> Pulse {
        Pulse(value: .low, targetModuleName: targetModuleName)
    }
    
    static func high(_ targetModuleName: String) -> Pulse {
        Pulse(value: .high, targetModuleName: targetModuleName)
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
            Pulse(value: pulse.value, targetModuleName: $0)
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
            Pulse(value: state ? .high : .low, targetModuleName: $0)
        }
    }
    
    var description: String {
        name + " " + targetModuleNames.joined(separator: " ") + "\(state)"
    }
}

class Conjunction: Module {
    let name: String
    let targetModuleNames: [String]
    
    var lastReceivedPulses = [Pulse]()
    
    init(name: String, targetModuleNames: [String]) {
        self.name = name
        self.targetModuleNames = targetModuleNames
    }
    
    func lastReceivedPulseValueFor(_ moduleName: String) -> Pulse.PulseValue {
        lastReceivedPulses.first { $0.targetModuleName == moduleName }?.value ?? .low
    }
    
    func receive(_ pulse: Pulse) -> [Pulse] {
        // update lastReceivedPulses
        if let existingIndex = lastReceivedPulses.firstIndex(where: { $0.targetModuleName == pulse.targetModuleName }) {
            lastReceivedPulses[existingIndex] = pulse
        } else {
            lastReceivedPulses.append(pulse)
        }
        
        let allHigh = lastReceivedPulses.reduce(true) { result, pulse in
            result && (pulse.value == .high)
        }
        
        if allHigh {
            return targetModuleNames.map {
                Pulse(value: .low, targetModuleName: $0)
            }
        } else {
            return targetModuleNames.map {
                Pulse(value: .high, targetModuleName: $0)
            }
        }
    }
    
    var description: String {
        name + " " + lastReceivedPulses.description
    }
}

class Output: Module {
    let name = "output"
    let targetModuleNames: [String] = []
    
    func receive(_ pulse: Pulse) -> [Pulse] {
        return []
    }
    
    var description: String {
        name
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
    case "o":
        return Output()
    default:
        fatalError("Unexected token \(splits[0])")
    }
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
        let pulse = Pulse.low("broadcaster")
        let result = broadcaster.receive(pulse)
        
        let expected = [
            Pulse.low("a"),
            Pulse.low("b"),
            Pulse.low("c"),
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
        let result = flipflop.receive(Pulse.high("ff"))
        XCTAssertEqual(result, [])
        XCTAssertEqual(flipflop.state, false)
    }
    
    func test_flipflop_becomesOn_whenOff_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: [])
        _ = flipflop.receive(Pulse.low("ff"))
        XCTAssertEqual(flipflop.state, true)
    }
    
    func test_flipflop_sendsLowPulse_whenOff_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: ["foo"])
        let result = flipflop.receive(Pulse.low("ff"))
        XCTAssertEqual(result, [Pulse(value: .high, targetModuleName: "foo")])
    }
    
    func test_flipflop_becomesOff_whenOn_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: [])
        flipflop.state = true
        _ = flipflop.receive(Pulse.low("ff"))
        XCTAssertEqual(flipflop.state, false)
    }
    
    func test_flipflop_sendsHighPulse_whenOn_andReceivesLowPulse() {
        let flipflop = Flipflop(name: "ff", targetModuleNames: ["foo"])
        flipflop.state = true
        let result = flipflop.receive(Pulse.low("ff"))
        XCTAssertEqual(result, [Pulse(value: .low, targetModuleName: "foo")])
    }
    
    // Conjunction
    func test_conjunction_defaultsToLowPulse_forLastReceivedPulse() {
        let conjunction = Conjunction(name: "c", targetModuleNames: [])
        XCTAssertEqual(conjunction.lastReceivedPulseValueFor("b"), .low)
    }
    
    //Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected input modules; they initially default to remembering a low pulse for each input. When a pulse is received, the conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.
    
    func test_conjunction_invertsIncomingSignal() {
        let conjunction = Conjunction(name: "c", targetModuleNames: ["bar", "baz"])
        var result = conjunction.receive(Pulse(value: .low, targetModuleName: "foo"))
        XCTAssertEqual(result[0].value, .high)
        result = conjunction.receive(Pulse(value: .high, targetModuleName: "foo"))
        XCTAssertEqual(result[0].value, .low)
    }
    
    func test_conjunction_returnsLow_ifAllHighPulses() {
        let conjunction = Conjunction(name: "c", targetModuleNames: ["bar", "baz"])
        conjunction.lastReceivedPulses = [Pulse(value: .high, targetModuleName: "a"), Pulse(value: .high, targetModuleName: "b"), Pulse(value: .low, targetModuleName: "d")]
        let result = conjunction.receive(Pulse(value: .high, targetModuleName: "d"))
        XCTAssertEqual(result[0].value, .low)
    }
    
    func test_conjunction_returnsHigh_ForMixedSignals() {
        let conjunction = Conjunction(name: "c", targetModuleNames: ["bar", "baz"])
        conjunction.lastReceivedPulses = [Pulse(value: .high, targetModuleName: "a"), Pulse(value: .low, targetModuleName: "b")]
        let result = conjunction.receive(Pulse(value: .high, targetModuleName: "d"))
        XCTAssertEqual(result[0].value, .high)
    }
    
    func test_afterExampleSequence_allFlipFlopsAreOff() {
        let pulseSystem = PulseSystem(exampleInput)
        pulseSystem.pushButton()
        
        let flipflops = pulseSystem.modules.compactMap { $0 as? Flipflop }
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
        
//    func test_pushButton_exampleInput2_output() {
//        let expected: [Pulse.PulseValue] = [.low, .high, .high, .high, .low]
//        let pulseSystem = PulseSystem(exampleInput2)
//        //pulseSystem.modules.append(Output())
//        
//        let output = pulseSystem.modules["output"]! as! Output
//        
//        for expect in expected {
//            pulseSystem.pushButton()
//            XCTAssertEqual(output.state, expect)
//        }
//    }
    
    func test_pushButton_exampleInput2_state() {
        let pulseSystem = PulseSystem(exampleInput2)
        let expected = pulseSystem.modules.description

        for _ in 0 ..< 4 {
            pulseSystem.pushButton()
        }
        XCTAssertEqual(pulseSystem.modules.description, expected)
    }
    
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
        
        for i in 0 ..< 1000 {
            print("Push \(i)")
            pulseSystem.pushButton()
        }
        
        print(pulseSystem.lowPulses, pulseSystem.highPulses, pulseSystem.lowPulses * pulseSystem.highPulses)
    }
}
