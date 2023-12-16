import XCTest
@testable import day16

final class day16Tests: XCTestCase {
    let exampleInput =
    #"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """#
    
    lazy var contraption = Contraption(exampleInput)
    
    func test_beamContinuesInDirection() {
        let startPositions = [
            Beam(0,0, Direction.right),
            Beam(0,2, Direction.down),
            Beam(1,3, Direction.up),
            Beam(1,3, Direction.left)
            ]
        
        let expected = [
            [Beam(1, 0, Direction.right)],
            [Beam(0, 3, Direction.down)],
            [Beam(1, 2, Direction.up)],
            [Beam(0, 3, Direction.left)]
            ]
            
        for i in 0 ..< expected.count {
            XCTAssertEqual(contraption.nextPositionFor(beam: startPositions[i]), expected[i])
        }
        
    }
    
    func test_beamCannotContinueInDirection_AtBorder() {
        let startPositions = [
            Beam(9,0, Direction.right),
            Beam(8,9, Direction.down),
            Beam(3,0, Direction.up),
            Beam(0,3, Direction.left)
            ]
        
        for position in startPositions {
            XCTAssertEqual(contraption.nextPositionFor(beam: position)[0], position)
        }
    }
        
    func test_beamSplitsAtSplitter_whenHittingFlatSide() {
        let startPositions = [
            Beam(5, 2, Direction.right),
            Beam(5, 2, Direction.left),
            ]
        
        let expected = [
            [Beam(5, 1, Direction.up), Beam(5, 3, Direction.down)],
            [Beam(5, 1, Direction.up), Beam(5, 3, Direction.down)]
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_beamDoesntSplitAtSplitter_whenHittingPointySide() {
        let startPositions = [
            Beam(5, 2, Direction.down),
            Beam(5, 2, Direction.up),
            ]
        
        let expected = [
            [Beam(5, 3, Direction.down)],
            [Beam(5, 1, Direction.up)]
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_beamSplit_doesntReturnOutOfBoundsBeams() {
        let startPositions = [
            Beam(1, 0, Direction.left),
            Beam(1, 0, Direction.right),
            ]
        
        let expected = [
            [Beam(1, 1, Direction.down)],
            [Beam(1, 1, Direction.down)],
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_beamSplitsAtDashSplitter_whenHittingFlatSide() {
        let startPositions = [
            Beam(6, 2, Direction.up),
            Beam(6, 2, Direction.down),
            ]
        
        let expected = [
            [Beam(5, 2, Direction.left), Beam(7, 2, Direction.right)],
            [Beam(5, 2, Direction.left), Beam(7, 2, Direction.right)]
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_beamDoesntSplitAtDashSplitter_whenHittingPointySide() {
        let startPositions = [
            Beam(6, 2, Direction.left),
            Beam(6, 2, Direction.right),
            ]
        
        let expected = [
            [Beam(5, 2, Direction.left)],
            [Beam(7, 2, Direction.right)],
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    // If the beam encounters a mirror (/ or \), the beam is reflected 90 degrees depending on the angle of the mirror. For instance, a rightward-moving beam that encounters a / mirror would continue upward in the mirror's column, while a rightward-moving beam that encounters a \ mirror would continue downward from the mirror's column.
    func test_forwardSlashMirror() {
        // / mirror
        let startPositions = [
            Beam(4, 6, Direction.right),
            Beam(4, 6, Direction.down),
            Beam(4, 6, Direction.up),
            Beam(4, 6, Direction.left),
            ]
        
        let expected = [
            [Beam(4, 5, Direction.up)],
            [Beam(3, 6, Direction.left)],
            [Beam(5, 6, Direction.right)],
            [Beam(4, 7, Direction.down)],
            
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_backSlashMirror() {
        // / mirror
        let startPositions = [
            Beam(4, 1, Direction.right),
            Beam(4, 1, Direction.down),
            Beam(4, 1, Direction.up),
            Beam(4, 1, Direction.left),
            ]
        
        let expected = [
            [Beam(4, 2, Direction.down)],
            [Beam(5, 1, Direction.right)],
            [Beam(3, 1, Direction.left)],
            [Beam(4, 0, Direction.up)],
            
        ]
        
        for (i, startPosition) in startPositions.enumerated() {
            let result = contraption.nextPositionFor(beam: startPosition)
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_energizedTilesCount_withExampleInput() {
        let result = contraption.energizedTilesCount(startBeam: Beam(0, 0, .right))
        XCTAssertEqual(result, 46)
    }
    
    func test_part1() {
        let contraption = Contraption(input)
        let result = contraption.energizedTilesCount(startBeam: Beam(0, 0, .right))
        XCTAssertEqual(result, 7798)
    }
    
    // MARK: Part 2
    func test_maximumEnergizedCount() {
        let result = contraption.calculateMaximumEnergizedCount()
        XCTAssertEqual(result, 51)
    }
    
    func test_part2() {
        let contraption = Contraption(input)
        let result = contraption.calculateMaximumEnergizedCount()
        XCTAssertEqual(result, 8026)
    }
}
