//
//  Concentration.swift
//  Stanford
//
//  Created by Daniel Marco S. Rafanan on May/7/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [ConcentrationCard]()
    
    private var indexOfOneCard : Int? {
        get{
            return cards.indices.filter {
                cards[$0].isFaceUp
            }.oneAndOnly
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    
    var flipCount = 0
    
    var points = 0
    
    var indexSet = Set<Int>()
    
    var identifierSet = Set<Int>()
    
    var numberOfPairs: Int
    
    var pairsMatched = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched && indexOfOneCard != index {
            flipCount += 1
            if let matchedIndex = indexOfOneCard{
                cards[index].isFaceUp = true
                if cards[index].identifier == cards[matchedIndex].identifier {
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    points += 2
                    pairsMatched += 1
                    if pairsMatched == numberOfPairs{
                        cards[index].isFaceUp = false
                        cards[matchedIndex].isFaceUp = false
                    }
                }else{
                    if(indexSet.contains(index)){
                        points -= 1
                    }else{
                        indexSet.insert(index)
                    }
                    if(indexSet.contains(matchedIndex)){
                        points -= 1
                    }else{
                        indexSet.insert(matchedIndex)
                    }
                }
            }else{
                indexOfOneCard = index
            }
        }
    }
    init(numberOfPairs: Int){
        self.numberOfPairs = numberOfPairs
        for _ in 1...numberOfPairs{
            let card = ConcentrationCard()
            self.cards += [card,card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
