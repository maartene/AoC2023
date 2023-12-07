import XCTest
@testable import day7

enum HandType: Int, CaseIterable {
    case highCard
    case onePair
    case twoPair
    case threeOfAKind
    case fullHouse
    case fourOfAKind
    case fiveOfAKind
}

struct Hand {

    let cardString: String
    let cards: [Character]
    var rank = 0
    let bid: Int

    init(_ cardString: String) {
        let words = cardString.split(separator: " ").map { String($0) }
        self.cardString = words[0]
        bid = Int(words[1])!
        cards = cardString.map { $0 }
    }

    var handType: HandType {
        var cardOccuranceMap = [Character: Int]()
        for card in cards {
            if let occurance = cardOccuranceMap[card] {
                cardOccuranceMap[card] = occurance + 1
            } else {
                cardOccuranceMap[card] = 1
            }
        }
        if cardOccuranceMap.values.contains(5) {
            return .fiveOfAKind
        }
        else if cardOccuranceMap.values.contains(4) {
            return .fourOfAKind
        } else if cardOccuranceMap.values.contains(3) {
            if cardOccuranceMap.values.contains(2) {
                return .fullHouse
            } else {
                return .threeOfAKind
            }
        } else if cardOccuranceMap.values.filter( {$0 == 2} ).count == 2 {
            return .twoPair
        } else if cardOccuranceMap.values.filter( {$0 == 2} ).count == 1 {
            return .onePair
        } 

        return .highCard
    }
}

func rankHands(_ hands: [Hand]) -> [Int] {
    var sortedHands = hands
    sortedHands.sort { h1, h2 in
        if h1.handType != h2.handType {
            return h1.handType.rawValue < h2.handType.rawValue
        }

        var i = 0

        while h1.cards[i] == h2.cards[i] && i < h1.cards.count {
            i += 1
        }

        if h1.cards[i] != h2.cards[i] {
            return h1.cards[i] > h2.cards[i]
        }

        return true
    }
    
    for i in 0 ..< sortedHands.count {
        sortedHands[i].rank = 1 + i
    }

    var cardStringIntMap = [String: Int]()
    for hand in sortedHands {
        cardStringIntMap[hand.cardString] = hand.rank
    }



    let result = hands.map {
        cardStringIntMap[$0.cardString]!
    }
    //print(result)
    return result
}

func inputToHands(_ input: String) -> [Hand] {
    return input.split(separator: "\n")
        .map { String($0) }
        .map { Hand($0) }
}

func totalBid(_ input: String) -> Int {
    let hands = inputToHands(input)
    let ranks = rankHands(hands)
    let bids = hands.map { $0.bid }
    var rankTimesBids = [Int]()
    for i in 0 ..< ranks.count {
        rankTimesBids.append(ranks[i] * bids[i])
    }   
    return rankTimesBids.reduce(0, +)
}

final class day7Tests: XCTestCase {
    let exampleInput = 
    """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

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
        print(hands)

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
}
