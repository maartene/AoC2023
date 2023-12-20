import XCTest
@testable import day20

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

protocol Module {
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
        []
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
    
}
