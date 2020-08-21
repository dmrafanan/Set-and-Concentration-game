//
//  CardView.swift
//  Set game
//
////  Created by Daniel Marco S. Rafanan on Aug/10/20.
////  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
////
//
import UIKit

class CardView: UIView {
    
    private var shape:ShapeEnum!
    private var texture:TextureEnum!
    private var count:Int!
    private var color:ColorEnum!
    var isFlipped:Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
//        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        isFlipped = true
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        if !isFlipped{
            switch count{
            case 0:
                drawShape(inCenter:CGPoint(x: bounds.size.width/2, y: bounds.height/2),context: context)
            case 1:
                let topHalf = CGPoint(x: bounds.size.width/2 , y: bounds.size.height/3)
                let bottomHalf = CGPoint(x: bounds.size.width/2, y: bounds.size.height/1.5)
                drawShape(inCenter: topHalf, context: context)
                drawShape(inCenter: bottomHalf, context: context)
            case 2:
                let topHalf = CGPoint(x: bounds.size.width/2, y: bounds.size.height/4)
                let bottomHalf = CGPoint(x: bounds.size.width/2, y: bounds.size.height/1.33)
                let center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
                drawShape(inCenter: topHalf, context: context)
                drawShape(inCenter: center, context: context)
                drawShape(inCenter: bottomHalf, context: context)
            default:break
            }
        }
    }
    
    func with(shape:ShapeEnum,texture:TextureEnum,count:Int,color:ColorEnum){
        self.shape = shape
        self.texture = texture
        self.count = count
        self.color = color

    }
    
    func drawShape(inCenter center:CGPoint,context:CGContext){
        let path = UIBezierPath()
        switch shape{
        case .diamond:
            let length = CGFloat(bounds.size.height/9)
            let topPoint = CGPoint(x: center.x, y: center.y - length)
            let leftPoint = CGPoint(x: center.x - length, y: center.y)
            let bottomPoint = CGPoint(x: center.x, y: center.y + length)
            let rightPoint = CGPoint(x: center.x + length, y: center.y)
            //        context.saveGState()
            path.move(to: topPoint)
            path.addLine(to: leftPoint)
            path.addLine(to: bottomPoint)
            path.addLine(to: rightPoint)
            path.close()
        case .circle:
            let radius = CGFloat(bounds.size.height/10)
            path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        case .squiggle:
            let height = CGFloat(bounds.size.height/24)
            let length = CGFloat(bounds.size.height/8)
            let topLeft = CGPoint(x: center.x - length, y: center.y - height)
            let topControlPoint1 = CGPoint(x: center.x - length/5, y: center.y - length/1.3 - height)
            let topControlPoint2 = CGPoint(x: center.x + length/5, y: center.y + length/1.3 - height)
            let topRight = CGPoint(x: center.x + length, y: center.y - height)
            let bottomLeft = CGPoint(x: center.x - length, y: center.y + height)
            let bottomRight = CGPoint(x: center.x + length, y: center.y + height)
            let bottomControlPoint1 = CGPoint(x: center.x - length/5, y: center.y - length/1.3 + height)
            let bottomControlPoint2 = CGPoint(x: center.x + length/5, y: center.y + length/1.3 + height)
            let topAndBottomLeftControlPoint = CGPoint(x: topLeft.x - height, y: (topLeft.y + bottomLeft.y)/2)
            let topAndBottomRightControlPoint = CGPoint(x: topRight.x + height, y: (topRight.y + bottomRight.y)/2)
            path.move(to: bottomRight)
            path.addQuadCurve(to: topRight, controlPoint: topAndBottomRightControlPoint)
            path.addCurve(to: topLeft, controlPoint1: topControlPoint2, controlPoint2: topControlPoint1)
            
            path.addQuadCurve(to: bottomLeft, controlPoint: topAndBottomLeftControlPoint)
            path.addCurve(to: bottomRight, controlPoint1: bottomControlPoint1, controlPoint2: bottomControlPoint2)
            path.close()
        default: break
        }
        context.saveGState()
        path.addClip()
        
        configureShape(path: path)
        context.restoreGState()
    }
    func configureShape(path:UIBezierPath){
        let width = bounds.size.width / 50
        var tempColor:UIColor!
        switch color {
        case .brown:
            tempColor = UIColor.brown
        case .green:
            tempColor = UIColor.green
        case .red:
            tempColor = UIColor.red
        default:
            break
        }
        switch texture {
        case .filled:
            tempColor.setFill()
            path.fill()
        case .hollow:
            tempColor.setStroke()
            path.lineWidth = width
            path.stroke()
        case .striped:
            UIGraphicsBeginImageContext(CGSize(width: bounds.size.width/26, height: bounds.size.height))
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0,y:bounds.size.height))
            tempColor.setStroke()
            path.lineWidth = width
            path.stroke()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            UIColor(patternImage: image!).setFill()
            path.fill()
            tempColor.setStroke()
            path.stroke()
        default:
            return
        }
    }
}
