import XCTest
@testable import day7

func getValueForCard_part1(_ card: Character) -> Int {
    switch card {
    case "T":
        return 10
    case "J":
        return 11
    case "Q":
        return 12
    case "K":
        return 13
    case "A":
        return 14
    default:
        return Int(String(card))!
    }
}

func getValueForCard_part2(_ card: Character) -> Int {
    switch card {
    case "T":
        return 10
    case "J":
        return 1
    case "Q":
        return 12
    case "K":
        return 13
    case "A":
        return 14
    default:
        return Int(String(card))!
    }
}

enum HandType: Int {
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
        cards = self.cardString.map { $0 }
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

        let cardOccurances = cardOccuranceMap.values.map { $0 as! Int }
        let occurances = Array(cardOccurances.sorted().reversed())

        if occurances == [5] {
            return .fiveOfAKind
        } else if occurances == [4,1] {
            return .fourOfAKind
        } else if occurances == [3,2] {
            return .fullHouse
        } else if occurances == [3,1,1] {
            return .threeOfAKind
        } else if occurances == [2,2,1] {
            return .twoPair
        } else if occurances == [2,1,1,1] {
            return .onePair
        }

        return .highCard
    }

    var handType_part2: HandType {
        var cardOccuranceMap = [Character: Int]()
        let jokerCount = cards.filter { $0 == "J"}.count

        for card in cards.filter({$0 != "J"}) {
            if let occurance = cardOccuranceMap[card] {
                cardOccuranceMap[card] = occurance + 1
            } else {
                cardOccuranceMap[card] = 1
            }
        }

        if jokerCount == 5 {
            return .fiveOfAKind
        }
        
        let cardOccurances = cardOccuranceMap.values.map { $0 as! Int }
        var occurances = Array(cardOccurances.sorted().reversed())
        occurances[0] = occurances[0] + jokerCount

        if occurances == [5] {
            return .fiveOfAKind
        } else if occurances == [4,1] {
            return .fourOfAKind
        } else if occurances == [3,2] {
            return .fullHouse
        } else if occurances == [3,1,1] {
            return .threeOfAKind
        } else if occurances == [2,2,1] {
            return .twoPair
        } else if occurances == [2,1,1,1] {
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
            return getValueForCard_part1(h1.cards[i]) < getValueForCard_part1(h2.cards[i])
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

func rankHands_part2(_ hands: [Hand]) -> [Int] {
    var sortedHands = hands
    sortedHands.sort { h1, h2 in
        if h1.handType_part2 != h2.handType_part2 {
            return h1.handType_part2.rawValue < h2.handType_part2.rawValue
        }

        var i = 0

        while h1.cards[i] == h2.cards[i] && i < h1.cards.count {
            i += 1
        }

        if h1.cards[i] != h2.cards[i] {
            return getValueForCard_part2(h1.cards[i]) < getValueForCard_part2(h2.cards[i])
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

func totalBid_part2(_ input: String) -> Int {
    let hands = inputToHands(input)
    let ranks = rankHands_part2(hands)
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
