//
//  ViewController.swift
//  Stanford
//
//  Created by Daniel Marco S. Rafanan on May/6/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairs: flipCards.count/2)
    
    @IBOutlet var flipCards: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = flipCards.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else{
            print("Card does not exsit")
        }
    }
    
    func updateViewFromModel(){
        pointsLabel.text = "Points: \(game.points)"
        if game.pairsMatched == game.numberOfPairs{
            FinishedLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            FinishedLabel.textColor = .white
        }
        for cardNumber in flipCards.indices {
            let button = flipCards[cardNumber]
            let card = game.cards[cardNumber]
            if  card.isFaceUp {
                button.setTitle(String(emoji(for: card)), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("   ", for: .normal)
                button.backgroundColor = card.isMatched ? UIColor.clear : UIColor.orange
            }
        }
    }
    
    @IBOutlet weak var FinishedLabel: UILabel!
    
    @IBOutlet weak var flipLabel: UILabel!{
        didSet{
            updateFlipLabel()
        }
    }
    
    func updateFlipLabel(){
        let attributes : [NSAttributedString.Key:Any] = [
            .strokeColor : UIColor.orange,
            .strokeWidth : 5.0
        ]
        flipLabel.attributedText = NSAttributedString.init(string: "Flips: \(game.flipCount)", attributes: attributes)
    }
    
    var emojiArrays =
    ["🐴🦉🐔🐞🐍🦑🦖🦈",
    "😂😘😍😇🤪😭😡😱",
    "🍎🍊🍌🍉🍇🍑🍆🥕"]
    
    lazy var emojiArray = emojiArrayValue()
    
    func emojiArrayValue() -> String{
        return emojiArrays[Int.random(in: emojiArrays.indices)]
    }
    
    var emojiIdentifier = [Int:Character]()
        
    func emoji(for card:ConcentrationCard) -> Character {
        if let emoji = emojiIdentifier[card.identifier]{
            return emoji
        }else{
            let emoji = emojiArray.remove(at: emojiArray.firstIndex(of: emojiArray.randomElement()!)!)
            emojiIdentifier[card.identifier] = emoji
            return emoji
        }
    }
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairs: flipCards.count / 2)
        updateViewFromModel()
        emojiArray = emojiArrayValue()
    }
}

