//
//  CardContainerView.swift
//  Set game
//
//  Created by Daniel Marco S. Rafanan on Aug/13/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class CardContainerView: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: .aspectRatio(0.625), frame: CGRect(x: 0, y: 0 , width: bounds.size.width, height: bounds.size.height))
        grid.cellCount = subviews.count
        for i in subviews.indices{
            let subview = subviews[i]
            subview.backgroundColor = .white
            subview.translatesAutoresizingMaskIntoConstraints = false
//            let animator = UIViewPropertyAnimator()
            UIView.animate(withDuration: 1.0) {
                subview.frame = grid[i]!
            }
//            animator.duration
            
            subview.layer.borderWidth = subview.frame.size.width/200
        }
    }
}
