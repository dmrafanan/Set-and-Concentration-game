//
//  Card.swift
//  Stanford
//
//  Created by Daniel Marco S. Rafanan on May/7/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation

struct ConcentrationCard: Hashable
{
    static func == (lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    var isMatched = false
    var isFaceUp = false
    var identifier: Int
    
    private static var uniqueIdentifierCount = 0
    private static func getUniqueIdentifier() -> Int
    {
        uniqueIdentifierCount += 1
        return uniqueIdentifierCount
    }
    
    init(){
        identifier = ConcentrationCard.getUniqueIdentifier()
    }
}
