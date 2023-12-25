import XCTest
@testable import day25

struct Connection: Equatable, Hashable {
    let left: String
    let right: String
    
    init(left: String, right: String) {
        let sortedInput = [left, right].sorted()
        self.left = sortedInput[0]
        self.right = sortedInput[1]
    }
    
    func contains(_ component: String) -> Bool {
        return component == left || component == right
    }
}

func createConnectionFromString(_ inputString: String) -> Set<Connection> {
    let splits = inputString.split(separator: ":").map { String($0) }
    let left = splits[0]
    let rights = splits[1].split(separator: " ").map { String($0) }
    var result = Set<Connection>()
    for right in rights {
        result.insert(Connection(left: left, right: right))
    }
    return result
}

func ring(for connections: Set<Connection>, removing: Set<Connection>) -> Set<Connection> {
//    var connections = connections
//    for c in removing {
//        connections.remove(c)
//    }
    
    var visited = removing
    var unvisited = Set<Connection>()
    unvisited.insert(connections.first!)
    while unvisited.isEmpty == false {
        let currentConnection = unvisited.removeFirst()
        visited.insert(currentConnection)
        let newConnections = connections.filter {
            visited.contains($0) == false && ($0.contains(currentConnection.left) || $0.contains(currentConnection.right))
        }
        unvisited = unvisited.union(newConnections)
    }
    
    return visited
}

func countGroupSizes(_ inputString: String) -> [Int] {
    // first lets create connections for the input value
    let lines = inputString.split(separator: "\n").map { String($0) }
    var connections = Set<Connection>()
    for line in lines {
        connections = connections.union(createConnectionFromString(line))
    }
    

    
    return []
}

func createConnections(_ inputString: String) -> Set<Connection> {
    let lines = inputString.split(separator: "\n").map { String($0) }
    var connections = Set<Connection>()
    for line in lines {
        connections = connections.union(createConnectionFromString(line))
    }
    return connections
}

func getRingSize(for ring: Set<Connection>) -> Int {
    let count = ring.reduce(into: Set<String>()) { result, connection in
        result.insert(connection.left)
        result.insert(connection.right)
    }.count
    
    return count
}

func removeConnections(for connections: Set<Connection>) -> Int {
    
    
    let componentCount = connections.reduce(into: Set<String>()) { result, connection in
        result.insert(connection.left)
        result.insert(connection.right)
    }.count
    
    var progress = 0
    for c1 in connections {
        print(progress)
        for c2 in connections {
            for c3 in connections {
                let removeSet = Set([c1, c2, c3])
                var ring = ring(for: connections, removing: removeSet)
                if ring.count < connections.count {
                    ring.remove(c1)
                    ring.remove(c2)
                    ring.remove(c3)
                    print("Found a ring! \(ring)")
                    return getRingSize(for: ring)
                }
            }
        }
        progress += 1
    }
    return componentCount
}

final class day25Tests: XCTestCase {
    let exampleInput =
    """
    jqt: rhn xhk nvd
    rsh: frs pzl lsr
    xhk: hfx
    cmg: qnr nvd lhk bvb
    rhn: xhk bvb hfx
    bvb: xhk hfx
    pzl: lsr hfx nvd
    qnr: nvd
    ntq: jqt hfx bvb xhk
    nvd: lhk
    lsr: lhk
    rzs: qnr cmg lsr rsh
    frs: qnr lhk lsr
    """
    
    lazy var exampleConnections = createConnections(exampleInput)
    
    func test_connections_JQTRHN_and_RHNJQT_are_equal() {
        let connection1 = Connection(left: "jqt", right: "rhn")
        let connection2 = Connection(left: "rhn", right: "jqt")
        
        XCTAssertEqual(connection1, connection2)
    }
    
    func test_connections_FRSLHK_and_LHKFRS_have_the_same_hashValue() {
        let connection1 = Connection(left: "frs", right: "lhk")
        let connection2 = Connection(left: "lhk", right: "frs")
        XCTAssertEqual(connection1.hashValue, connection2.hashValue)
    }
    
    func test_createConnectionsFromString() {
        let expected = [
            Connection(left: "rsh", right: "frs"),
            Connection(left: "rsh", right: "pzl"),
            Connection(left: "rsh", right: "lsr"),
        ]
        let result = createConnectionFromString("rsh: frs pzl lsr")
        
        
        XCTAssertEqual(result.count, expected.count)
        for expect in expected {
            XCTAssertTrue(result.contains(expect))
        }
    }
    
    func test_removeConnections_divides_exampleInput_into_two_groups() {
        let connectionsToRemove = Set([
            Connection(left: "hfx", right: "pzl"),
            Connection(left: "bvb", right: "cmg"),
            Connection(left: "nvd", right: "jqt"),
        ])
        
        let componentCount = exampleConnections.reduce(into: Set<String>()) { result, connection in
            result.insert(connection.left)
            result.insert(connection.right)
        }.count
        
        let ring = ring(for: exampleConnections, removing: connectionsToRemove)
        let ringSize = getRingSize(for: ring)
        XCTAssertEqual(ringSize * (componentCount - ringSize), 54)
    }
    
    func test_removeConnections_divides_input_into_two_groups() {
        let connections = createConnections(input)
        
        let connectionsToRemove = Set([
            Connection(left: "tqr", right: "grd"),
            Connection(left: "ngp", right: "bmd"),
            Connection(left: "tqh", right: "dlv"),
        ])
        
        let componentCount = connections.reduce(into: Set<String>()) { result, connection in
            result.insert(connection.left)
            result.insert(connection.right)
        }.count
        
        var ring = ring(for: connections, removing: connectionsToRemove)
        for c in connectionsToRemove {
            ring.remove(c)
        }
        
        let ringSize = getRingSize(for: ring)
        print(ringSize, ringSize * (componentCount - ringSize))
        XCTAssertEqual(ringSize * (componentCount - ringSize), 54)
    }
    
    func test_removeConnections_withExampleInput() {
        let componentCount = exampleConnections.reduce(into: Set<String>()) { result, connection in
            result.insert(connection.left)
            result.insert(connection.right)
        }.count
        
        let ringSize = removeConnections(for: exampleConnections)
        XCTAssertEqual(ringSize * (componentCount - ringSize), 54)
    }
    
//    func test_part1() {
//        let connections = createConnections(input)
//        
//        let componentCount = connections.reduce(into: Set<String>()) { result, connection in
//            result.insert(connection.left)
//            result.insert(connection.right)
//        }.count
//        
//        let ringSize = removeConnections(for: connections)
//        
//        print(ringSize, ringSize * (componentCount - ringSize))
//    }
    
//    func test_convertToDot() throws {
//        let lines = input.split(separator: "\n").map { String($0) }
//        var result = [String]()
//        for line in lines {
//            var dotLine = ""
//            let splits = line.split(separator: ":").map { String($0) }
//            dotLine += splits[0]
//            dotLine += " -> "
//            dotLine += "{ "
//            dotLine += splits[1]
//            dotLine += " }"
//            result.append(dotLine)
//        }
//        
//        let resultString = result.joined(separator: "\n")
//        if let data = resultString.data(using: .utf8) {
//            let url = URL(fileURLWithPath: "/tmp/input.dot")
//            try data.write(to: url)
//        } else {
//            XCTFail("Failed to create data")
//        }
//        
//        
//    }
    
//    func test_analyze_Input() {
//        let lines = input.split(separator: "\n").map { String($0) }
//        var connections = Set<Connection>()
//        for line in lines {
//            connections = connections.union(createConnectionFromString(line))
//        }
//        print("Connections: ",connections.count)
//        
//        var components = Set<String>()
//        for connection in connections {
//            components.insert(connection.left)
//            components.insert(connection.right)
//        }
//        
//        print("Components: ", components.count)
//        
//        let componentsWithOneConnection = components.filter { component in
//            connections.filter { connection in
//                connection.contains(component)
//            }.count == 1
//        }
//        print("Components with one connection: ", componentsWithOneConnection.count)
//    }
}
