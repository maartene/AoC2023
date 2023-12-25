import Foundation

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
    var connections = connections
    for c in removing {
        connections.remove(c)
    }
    
    var visited = Set<Connection>()
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

func createConnections(_ inputString: String) -> Set<Connection> {
    let lines = inputString.split(separator: "\n").map { String($0) }
    var connections = Set<Connection>()
    for line in lines {
        connections = connections.union(createConnectionFromString(line))
    }
        
    return connections
}

func componentsInConnectionsCount(for connections: Set<Connection>) -> Int {
    let count = connections.reduce(into: Set<String>()) { result, connection in
        result.insert(connection.left)
        result.insert(connection.right)
    }.count
    
    return count
}

func removeConnections(for connections: Set<Connection>) -> Int {
    let componentCount = componentsInConnectionsCount(for: connections)
    
    for c1 in connections {
        for c2 in connections {
            for c3 in connections {
                let removeSet = Set([c1, c2, c3])
                let ring = ring(for: connections, removing: removeSet)
                if ring.count < connections.count - 3 {
                    return componentsInConnectionsCount(for: ring)
                }
            }
        }
    }
    return componentCount
}

func calculateRingCountMultiple(for connections: Set<Connection>, removing connectionsToRemove: Set<Connection>) -> Int {
    let componentCount = componentsInConnectionsCount(for: connections)
    
    let ring = ring(for: connections, removing: connectionsToRemove)
    let ringSize = componentsInConnectionsCount(for: ring)
    return ringSize * (componentCount - ringSize)
}
