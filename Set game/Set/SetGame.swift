import Foundation

class SetGame {
    var cards = [Card]()
    
    var cardsInDeck = [Card]()
    
    var selectedCard = [Card]()
    
    var points = 0
    
    var matchingOnLastChooseCard = false
    
    var isASet = false
    
    func chooseCard(atCardIndex index:Int){
        isASet = false
        matchingOnLastChooseCard = false
        let card = cards[index]
        //deselect
        if selectedCard.contains(card) {
            selectedCard.remove(at: selectedCard.firstIndex(of: card)!)
            points -= 1
            //select
        } else {
            selectedCard.append(card)
        }
        if selectedCard.count == 3{
            areSelectedCardsASet()
        }
    }
    func areSelectedCardsASet(){
        var matchedMap = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]]
        for card in selectedCard {
            matchedMap[0][card.colorNumber] += 1
            matchedMap[1][card.number] += 1
            matchedMap[2][card.shapeNumber] += 1
            matchedMap[3][card.textureNumber] += 1
        }
        
        let matchedMapContainsTwo = matchedMap.contains{ arrayOfInt in
            return arrayOfInt.contains(2)
        }
        matchingOnLastChooseCard = true
        //!is a set
        isASet = matchedMapContainsTwo
        
        points = matchedMapContainsTwo ? points - 5 : points + 3
    }
    func removeCardsThatIsASet(){
        for card in selectedCard{
            cards.remove(at: cards.firstIndex(of: card)!)
        }
    }
    
    func returnSelectedCardIndices() -> [Int]{
        var indices = [Int]()
        for i in cards.indices{
            for j in selectedCard.indices{
                if cards[i] == selectedCard[j]{
                    indices.append(i)
                }
            }
        }
        return indices
    }
    
    func removeSelectedAndSetCards(){
        if isASet{
            removeCardsThatIsASet()
        }
        removeSelectedCards()

    }
    func removeSelectedCards(){
            selectedCard.removeAll()
    }
    init(){
        func cardAttributeGetter(){
            var arr1 = [0,0,0,0]
            var temp1 = [Int]()
            cardAttributeGetterHelper(arr: &arr1,temp: &temp1)
            cardsInDeck.shuffle()
        }
        
        func cardAttributeGetterHelper( arr:inout [Int], temp:inout [Int]){
            if arr.isEmpty {
                let newCard = Card()
                newCard.number = temp[0]
                newCard.shapeNumber = temp[1]
                newCard.colorNumber = temp[2]
                newCard.textureNumber = temp[3]
                cardsInDeck += [newCard]
            } else {
                for i in 0...2{
                    let intTemp = arr.remove(at: 0)
                    temp.append(i)
                    cardAttributeGetterHelper(arr: &arr, temp: &temp)
                    arr.insert(intTemp, at: 0)
                    temp.removeLast()
                }
            }
        }
        cardAttributeGetter()
    }
}
