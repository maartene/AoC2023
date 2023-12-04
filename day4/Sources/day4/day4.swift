import Foundation

struct Card {
    let id: Int
    let winningNumbers: [Int]
    let ownNumbers: [Int]
    
    init(cardString: String) {
        let descriptionContentSplit = cardString.split(separator: ":")
            .map { String($0) }
        
        guard descriptionContentSplit.count == 2 else {
            fatalError("There should be two splits")
        }
        
        id = Int(descriptionContentSplit[0].trimmingCharacters(in: .letters)
            .trimmingCharacters(in: .whitespaces))!
        
        let winningAndOwnNumbers = descriptionContentSplit[1].split(separator: "|")
            .map { String($0) }
        
        winningNumbers = winningAndOwnNumbers[0].split(separator: " ")
            .map { String($0) }
            .map { Int($0)! }
        
        ownNumbers = winningAndOwnNumbers[1].split(separator: " ")
            .map { String($0) }
            .map { Int($0)! }
    }
    
    var matchingNumberCount: Int {
        let winningSet = Set(winningNumbers)
        let ownSet = Set(ownNumbers)
        let overlap = winningSet.intersection(ownSet)
        return overlap.count
    }
    
    var score: Int {
        let subscore = (0 ..< matchingNumberCount).reduce(1) { result, _ in result * 2 }
        return subscore / 2
    }
}

// MARK: Part 1
func calculatePointsForCard(_ cardString: String) -> Int {
    Card(cardString: cardString).score
}

func calculateTotalPoints(_ input: String) -> Int {
    let calculatedPoints = input.split(separator: "\n")
        .map { String($0) }
        .map { calculatePointsForCard($0) }
    
    return calculatedPoints.reduce(0, +)
}

// MARK: Part 2
func calculateTotalNumberOfScratchCards(_ input: String) -> Int {
    var cards = input.split(separator: "\n")
        .map { String($0) }
        .map { Card(cardString: $0) }
    
    let maxCardID = cards.max(by: { $0.id < $1.id })!.id
    
    var cardCopyDictionary = [Int: Card]()
    for card in cards {
        cardCopyDictionary[card.id] = card
    }
    
    for cardID in 0 ..< maxCardID {
        let cardsToCopy = cards.filter { $0.id == cardID }
        for card in cardsToCopy {
            for di in 0 ..< card.matchingNumberCount {
                if let copy = cardCopyDictionary[cardID + di + 1] {
                    cards.append(copy)
                }
            }
        }
        print(cards.count, cardID)
    }
    
    return cards.count
}
