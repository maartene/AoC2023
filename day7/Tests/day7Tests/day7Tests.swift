import XCTest
@testable import day7

final class day7Tests: XCTestCase {
    let exampleInput = 
    """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    func test_handType_forKTJJT() {
        let hand = Hand("KTJJT 2210")
        XCTAssertEqual(hand.handType, .twoPair)
    }

    func test_handType() {
        let expected: [String: HandType] = [
            "TTTTT 0": .fiveOfAKind,
            "QAQQQ 0": .fourOfAKind,
            "32T3K 0": .onePair,
            "T55J5 0": .threeOfAKind,
            "44664 0": .fullHouse,
            "KK677 0": .twoPair,
            "KTJJT 0": .twoPair,
            "QQQJA 0": .threeOfAKind,
            "2345Q 0": .highCard,
        ]

        for pair in expected {
            XCTAssertEqual(Hand(pair.key).handType, pair.value)
        }
    }

    func test_handType_withExampleInput() {
        let expected: [HandType] = [.onePair, .threeOfAKind, .twoPair, .twoPair, .threeOfAKind]

        let hands = inputToHands(exampleInput)
        for i in 0 ..< hands.count {
            XCTAssertEqual(hands[i].handType, expected[i], "\(hands[i].handType) is not equal to \(expected[i]) for \(hands[i].cardString)")
        }
    }

    func test_rankHands_withExampleInput() {
        let expected = [1, 4, 3, 2, 5]
        
        let hands = inputToHands(exampleInput)
        //print(hands)

        let result = rankHands(hands)
        XCTAssertEqual(result.count, expected.count)
        for i in 0 ..< expected.count {
            XCTAssertEqual(result[i], expected[i])
        }
    }

    func test_totalBid_withExampleInput() {
        let result = totalBid(exampleInput)
        XCTAssertEqual(result, 6440)
    }

    func test_part1() {
        let result = totalBid(input)
        XCTAssertEqual(result, 248217452)
    }

    // MARK: Part 2
    func test_handType_part2_T55J5() {
        let hand = Hand("T55J5 684")
        XCTAssertEqual(hand.handType_part2, .fourOfAKind)
    }

    func test_handType_part2_withExampleInput() {
        let expected: [HandType] = [.onePair, .fourOfAKind, .twoPair, .fourOfAKind, .fourOfAKind]
        let hands = inputToHands(exampleInput)
        XCTAssertEqual(expected.count, hands.count)

        for i in 0 ..< expected.count {
            XCTAssertEqual(hands[i].handType_part2, expected[i], "\(hands[i].handType_part2) is not equal to \(expected[i]) for \(hands[i].cardString)")
        }

    }

    func test_ranking_part2_withExampleInput() {
        let expected = [1, 3, 2, 5, 4]
        let hands = inputToHands(exampleInput)
        let result = rankHands_part2(hands)

        XCTAssertEqual(result, expected)

    }

    func test_totalBid_part2_withExampleInput() {
        let result = totalBid_part2(exampleInput)
        XCTAssertEqual(result, 5905)
    }

    func test_handType_JJJJJ() {
        let hand = Hand("JJJJJ 684")
        XCTAssertEqual(hand.handType_part2, .fiveOfAKind)
    }

    func test_handType_AA44J() {
        let hand = Hand("AA44J 684")
        XCTAssertEqual(hand.handType_part2, .fullHouse)
    }

    func test_handType_AAJ4J() {
        let hand = Hand("AAJ4J 684")
        XCTAssertEqual(hand.handType_part2, .fourOfAKind)
    }

    func test_handType_AAJJJ() {
        let hand = Hand("AAJJJ 684")
        XCTAssertEqual(hand.handType_part2, .fiveOfAKind)
    }

    func test_ranking_part2() {
        let hands = [
            Hand("AAJJJ 684"), Hand("AA44J 684"), Hand("AAJ4J 684")
        ]

        let expected = [3, 1, 2]
        XCTAssertEqual(rankHands_part2(hands), expected)
    }

    func test_onePair() {
        let hand = Hand("23J45 123")
        XCTAssertEqual(hand.handType_part2, .onePair)
    }

    func test_part2() {
        let result = totalBid_part2(input)
        print(result)
        XCTAssertEqual(result, 245576185)
    }
}
