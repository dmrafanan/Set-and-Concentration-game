//
//  CardContainerView.swift
//  Set game
//
//  Created by Daniel Marco S. Rafanan on Aug/13/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit


class CardContainerView: UIView {
    override var bounds: CGRect {
        didSet {
            grid.frame = bounds
            animateFrameChange()
        }
    }
    lazy var grid = Grid(layout: .aspectRatio(0.625), frame: self.bounds)
    
    func addToCellCount(_ num:Int){
        grid.cellCount += num
    }
    func animateFrameChange(){
        grid.cellCount = subviews.count
        for i in subviews.indices{
            let subview = subviews[i]
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                subview.frame = self.grid[i]!
            }, completion: nil)
        }
    }
    
    //animate only the added cards
    func animateAddingOfCards(for views:[UIView]){
        var time = TimeInterval(exactly: 0)!
        grid.cellCount = subviews.count
        for i in views.indices{
            time += 0.1
            let view = views[i]
            view.layer.borderWidth = view.frame.size.width/200
            UIView.animate(withDuration: 0.5, delay: time, options: .curveEaseOut, animations: {
                let index = self.subviews.firstIndex(of: view)!
                view.frame = self.grid[index]!

            }, completion: {
                finished in
                UIView.transition(with: view, duration: 1, options: .transitionFlipFromLeft, animations: {
                    if let view = view as? CardView{
                        view.isFlipped = false
                        view.backgroundColor = .white
                        view.setNeedsDisplay()
                    }
                })
            })
            
        }
    }
    
}

