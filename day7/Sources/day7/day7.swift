import Foundation 

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