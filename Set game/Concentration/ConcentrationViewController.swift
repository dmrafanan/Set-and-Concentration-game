//
//  ViewController.swift
//  Stanford
//
//  Created by Daniel Marco S. Rafanan on May/6/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairs: flipCards.count/2)
    
    var themeIsFruits = true
    
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
        if pointsLabel != nil{
            pointsLabel.text = "Points: \(game.points)"
            if game.pairsMatched == game.numberOfPairs{
                FinishedLabel.isHidden = false
            }else{
                FinishedLabel.isHidden = true
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
    }
    
    @IBOutlet weak var FinishedLabel: UILabel!{
        didSet{
            FinishedLabel.isHidden = true
            FinishedLabel.textColor = .black
        }
    }
    
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
    
    var emojiArray:[Character] = ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇"] {
        didSet{
            updateViewFromModel()
            themeIsFruits = false
        }
    }
    
    lazy var emojiArrayIndices:[Int] = {
        var array = [Int]()
        for i in 0...emojiArray.count - 1{
            array += [i]
        }
        return array
    }()
    
    
    var emojiIdentifier = [Int:Int]()
    
    func emoji(for card:ConcentrationCard) -> Character {
        //if in emoji dictionary
        if let index = emojiIdentifier[card.identifier]{
            return emojiArray[index]
        }else{
            let index = emojiArrayIndices.remove(at: emojiArrayIndices.firstIndex(of: emojiArrayIndices.randomElement()!)!)
            emojiIdentifier[card.identifier] = index
            let emoji = emojiArray[emojiIdentifier[card.identifier]!]
            return emoji
        }
    }
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        var array = [Int]()
        for i in 0...emojiArray.count - 1{
            array += [i]
        }
        emojiArrayIndices = array
        game = Concentration(numberOfPairs: flipCards.count / 2)
        updateViewFromModel()
    }
}
