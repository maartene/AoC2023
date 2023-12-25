import XCTest
@testable import day25

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
        
        let result = calculateRingCountMultiple(for: exampleConnections, removing: connectionsToRemove)
        XCTAssertEqual(result, 54)
    }
    
    func test_removeConnections_divides_input_into_two_groups() {
        let connections = createConnections(input)
        
        // I found these by visualizing the input in Graphviz/Curve.
        let connectionsToRemove = Set([
            Connection(left: "tqr", right: "grd"),
            Connection(left: "ngp", right: "bmd"),
            Connection(left: "tqh", right: "dlv"),
        ])
        
        let result = calculateRingCountMultiple(for: connections, removing: connectionsToRemove)
        XCTAssertEqual(result, 592171)
    }
    
    // No longer needed
    func test_removeConnections_withExampleInput() {
        let componentCount = componentsInConnectionsCount(for: exampleConnections)
        
        let ringSize = removeConnections(for: exampleConnections)
        XCTAssertEqual(ringSize * (componentCount - ringSize), 54)
    }
}
