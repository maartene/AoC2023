import XCTest
@testable import day4

final class day4Tests: XCTestCase {
    let exampleInput =
    """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """
    
    func test_createCard() {
        let card = Card(cardString: "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
        XCTAssertEqual(card.winningNumbers, [41, 48, 83, 86, 17])
        XCTAssertEqual(card.ownNumbers, [83, 86, 6, 31, 17, 9, 48, 53])
    }
    
    // MARK: Part 1
    func test_calculatePoints_withExampleInput() {
        let expectedPoints = [8, 2, 2, 1, 0, 0]
        
        let calculatedPoints = exampleInput.split(separator: "\n")
            .map { String($0) }
            .map { calculatePointsForCard($0) }
        
        XCTAssertEqual(calculatedPoints, expectedPoints)
    }
    
    func test_calculateTotalPoints_withExampleInput() {
        XCTAssertEqual(calculateTotalPoints(exampleInput), 13)
    }
    
    func test_part1() {
        let points = calculateTotalPoints(input)
        XCTAssertEqual(points, 25231)
    }
    
    // MARK: Part 2
    func test_createCard_id() {
        let card = Card(cardString: "Card 42:  1 21 53 59 44 | 69 82 63 72 16 21 14  1")
        XCTAssertEqual(card.id, 42)
    }
    
    func test_matchingNumberCount_withExampleInput() {
        let expectedCount = [4, 2, 2, 1, 0, 0]
        
        let cards = exampleInput.split(separator: "\n")
            .map { String($0) }
            .map { Card(cardString: $0) }
        
        for i in 0 ..< cards.count {
            XCTAssertEqual(cards[i].matchingNumberCount, expectedCount[i])
        }
    }
    
    func test_calculateTotalNumberOfScratchCards_withExampleInput() {
        XCTAssertEqual(calculateTotalNumberOfScratchCards(exampleInput), 30)
    }
    
    // WARNING: This test runs about 2 minutes!!!
    func test_part2() {
        let calculatedTotal = calculateTotalNumberOfScratchCards(input)
        XCTAssertEqual(calculatedTotal, 9721255)
    }
}
