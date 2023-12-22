import XCTest
@testable import day22

final class day22Tests: XCTestCase {
    
    
    let exampleInput =
    """
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
    """
    
    lazy var bricks = exampleInput.split(separator: "\n").map { String($0) }
        .map { Brick($0) }
    
    func test_createBricksBasedOnInput_withExampleInput() {
        let expected = [
            Brick(start: Vector3D(x: 1, y: 0, z: 1), end: Vector3D(x: 1, y: 2, z: 1)),
            Brick(start: Vector3D(x: 0, y: 0, z: 2), end: Vector3D(x: 2, y: 0, z: 2)),
            Brick(start: Vector3D(x: 0, y: 2, z: 3), end: Vector3D(x: 2, y: 2, z: 3)),
            Brick(start: Vector3D(x: 0, y: 0, z: 4), end: Vector3D(x: 0, y: 2, z: 4)),
            Brick(start: Vector3D(x: 2, y: 0, z: 5), end: Vector3D(x: 2, y: 2, z: 5)),
            Brick(start: Vector3D(x: 0, y: 1, z: 6), end: Vector3D(x: 2, y: 1, z: 6)),
            Brick(start: Vector3D(x: 1, y: 1, z: 8), end: Vector3D(x: 1, y: 1, z: 9)),
        ]
        
        XCTAssertEqual(bricks.count, expected.count)
        for i in 0 ..< expected.count {
            XCTAssertEqual(bricks[i], expected[i])
        }
    }
    
    func test_bricksHaveSize() {
        let expected = [2, 2, 2, 2, 2, 2, 1]
        
        for (i, expect) in expected.enumerated() {
            XCTAssertEqual(bricks[i].size, expect, "for brick \(bricks[i])")
        }
    }
    
    func test_bricks_overlap() {
        let brick1 = Brick(start: Vector3D(x: 0, y: 0, z: 0), end: Vector3D(x: 0, y: 0, z: 2))
        let brick2 = Brick(start: Vector3D(x: -1, y: 0, z: 1), end: Vector3D(x: 1, y: 0, z: 1))
        XCTAssertTrue(brick1.overlapsWith(brick2))
    }
    
    func test_bricks_dontOverlap() {
        let brick1 = Brick(start: Vector3D(x: 0, y: 0, z: 0), end: Vector3D(x: 0, y: 0, z: 2))
        let brick2 = Brick(start: Vector3D(x: -1, y: 1, z: 1), end: Vector3D(x: 1, y: 1, z: 1))
        XCTAssertFalse(brick1.overlapsWith(brick2))
    }
    
    func test_brick_isSupportingBrick() {
        let brick1 = Brick(start: Vector3D(x: 0, y: 0, z: 0), end: Vector3D(x: 0, y: 1, z: 0))
        let brick2 = Brick(start: Vector3D(x: 0, y: 1, z: 1), end: Vector3D(x: 1, y: 1, z: 1))
        
        XCTAssertTrue(brick1.isSupportingBrick(brick2))
    }
    
    func test_brick_isNotSupportingBrick() {
        let brick1 = Brick(start: Vector3D(x: 0, y: 0, z: 0), end: Vector3D(x: 0, y: 1, z: 0))
        let brick2 = Brick(start: Vector3D(x: 0, y: 2, z: 1), end: Vector3D(x: 1, y: 2, z: 1))
        
        XCTAssertFalse(brick1.isSupportingBrick(brick2))
        
        let brick3 = Brick(start: Vector3D(x: -2, y: 1, z: 1), end: Vector3D(x: -1, y: 1, z: 1))
        
        XCTAssertFalse(brick1.isSupportingBrick(brick3))
    }
    
    func test_brickStack_create() {
        let brickStack = BrickStack(exampleInput)
        
        let expectedXZ =
        """
         x
        012
        .G. 9
        .G. 8
        ... 7
        FFF 6
        ..E 5 z
        D.. 4
        CCC 3
        BBB 2
        .A. 1
        --- 0
        """
        
        let expectedYZ =
        """
         y
        012
        .G. 9
        .G. 8
        ... 7
        .F. 6
        EEE 5 z
        DDD 4
        ..C 3
        B.. 2
        AAA 1
        --- 0
        """
        
        XCTAssertEqual(brickStack.xzDescription, expectedXZ)
        
        XCTAssertEqual(brickStack.yzDescription, expectedYZ)
    }
    
    func test_stack_falls() {
        let stack = BrickStack(exampleInput)
        
        stack.settle()
        
        let expectedXZ =
        """
         x
        012
        .G. 6
        .G. 5
        FFF 4
        D.E 3 z
        ??? 2
        .A. 1
        --- 0
        """
        
        let expectedYZ =
        """
         y
        012
        .G. 6
        .G. 5
        .F. 4
        ??? 3 z
        B.C 2
        AAA 1
        --- 0
        """
        
        XCTAssertEqual(stack.xzDescription, expectedXZ)
        XCTAssertEqual(stack.yzDescription, expectedYZ)
    }
    
    func test_input_endBelowStart() {
        let bricks = input.split(separator: "\n").map {
            Brick(String($0))
        }
        
        let strangeBricks = bricks.filter { $0.start.z > $0.end.z }
        
        XCTAssertEqual(strangeBricks, [])
    }
    
    func test_bricksCanBeDisintegrated_withExampleInput() {
        let stack = BrickStack(exampleInput)
        stack.settle()
        let previousBricks = stack.bricks
        
        let cases = [
            0: false,
            1: true,
            2: true,
            3: true,
            4: true,
            5: false,
            6: true
        ]
        
        for expect in cases {
            XCTAssertEqual(stack.canBrickBeDisintegrated(expect.key), expect.value)
        }
        
        XCTAssertEqual(stack.bricks, previousBricks)
    }
    
    func test_countBricksThatCanBeDisintegrated_withExampleInput() {
        let stack = BrickStack(exampleInput)
        stack.settle()
        
        let result = stack.countBricksThatCanSafelyDisintegrated()
        XCTAssertEqual(result, 5)
    }
    
    func test_part1() {
        let stack = BrickStack(input)
        stack.settle()
        let result = stack.countBricksThatCanSafelyDisintegrated()
        XCTAssertEqual(result, 405)
    }
    
    // part 2
    func test_chainReaction_withExampleInput() {
        let cases = [
            0: 6,
            5: 1
        ]
        
        let stack = BrickStack(exampleInput)
        stack.settle()
        
        for expected in cases {
            let result = stack.countChainReaction(brickKey: expected.key)
            XCTAssertEqual(result, expected.value, "for brick: \(expected.key)")
        }
    }
    
    func test_sumOfchainReactions_withExampleInput() {
        let stack = BrickStack(exampleInput)
        stack.settle()
        
        let result = stack.sumOfchainReactions()
        XCTAssertEqual(result, 7)
    }
    
    func test_part2() {
        let stack = BrickStack(input)
        stack.settle()
        
        let result = stack.sumOfchainReactions()
        print(result)
        XCTAssertEqual(result, 61297)
    }
}

