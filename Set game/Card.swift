//
//  Card.swift
//  Set game
//
//  Created by Daniel Marco S. Rafanan on Jun/3/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation

class Card:Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        if lhs.colorNumber == rhs.colorNumber && lhs.number == rhs.number && lhs.shapeNumber == rhs.shapeNumber && lhs.textureNumber == rhs.textureNumber{
            return true
        }else{
            return false
        }
    }
    
    
    //nil if the last choose card did not yield a matching result
    var number = 0
    var shapeNumber = 0
    var colorNumber = 0
    var textureNumber = 0
    func texture() -> TextureEnum {
        switch textureNumber {
        case 0:
            return .filled
        case 1:
            return .hollow
        case 2:
            return .striped
        default:
            return .filled
        }
    }
    func color() -> ColorEnum{
        switch colorNumber {
        case 0:
            return .green
        case 1:
            return .brown
        case 2:
            return .red
        default:
            return .green
        }
    }
    func shape() -> ShapeEnum {
        switch shapeNumber{
        case 0:
            return .circle
        case 1:
            return .squiggle
        case 2:
            return .diamond
        default:
            return .circle
        }
    }
    
}
enum TextureEnum{
    case striped
    case filled
    case hollow
}

enum ColorEnum{
    case red
    case green
    case brown
}


enum ShapeEnum{
    case diamond
    case squiggle
    case circle
}
