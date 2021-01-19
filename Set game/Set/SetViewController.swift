import UIKit

class SetViewController: UIViewController {
    var game = SetGame(){
        didSet {
            createDeckOfCardViews()
            for view in trashDeckView.subviews{
                view.removeFromSuperview()
            }
            addCards(of: 12)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = SetGame()
        animator.delegate = self
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    
    @IBOutlet weak var cardContainerView: CardContainerView!{
        didSet{
            let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCardContainerView(sender:)))
            cardContainerView.addGestureRecognizer(tapGuestureRecognizer)
            let rotateGuestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateCardContainerView(_:)))
            cardContainerView.addGestureRecognizer(rotateGuestureRecognizer)
        }
    }
    @IBAction func swipeCardCollectionView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down{
            addCards(of: 3)
            
        }
    }
    @IBOutlet weak var deckView: UIView!
    
    @IBOutlet weak var trashDeckView: UIView!
    
    @objc func rotateCardContainerView(_ sender:UIRotationGestureRecognizer){
        switch sender.state{
        case .recognized:
            randomizeCards()
            cardContainerView.animateFrameChange()
        default:
            break
        }
    }
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        game = SetGame()
        updateBorderColor()
    }
    
    @IBOutlet weak var addCardButton: UIButton!
    
    @IBAction func touchAddCardButton(_ sender: UIButton) {
        addCards(of: 3)
    }
    
    lazy var itemBehavior:UIDynamicItemBehavior = {
       let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = false
        itemBehavior.elasticity = 0.5
        itemBehavior.resistance = 0
        animator.addBehavior(itemBehavior)
        return itemBehavior
    }()
    lazy var collisionBehavior:UICollisionBehavior = {
       let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        return collisionBehavior
    }()
    
    
    @objc func tapCardContainerView(sender:UITapGestureRecognizer){
        //TODO
        guard let view = cardContainerView.hitTest(sender.location(in: cardContainerView), with: nil) else {
            return
        }
        guard let index = cardContainerView.subviews.firstIndex(of: view) else {
            return
        }
        
        game.chooseCard(atCardIndex: index)
        updateBorderColor()

        if game.isASet && game.matchingOnLastChooseCard{
            animateRemoveMatchedViewsFromCardContainer()
        }else if game.matchingOnLastChooseCard{
            game.removeSelectedCards()
        }
    }
    
    func animateRemoveMatchedViewsFromCardContainer(){
        let selectedCardIndices = game.returnSelectedCardIndices()
        let viewsToBeRemoved:[UIView] = [cardContainerView.subviews[selectedCardIndices[0]],
                                         cardContainerView.subviews[selectedCardIndices[1]],
                                         cardContainerView.subviews[selectedCardIndices[2]]]
        let cardsToBeRemoved:[Card] = [game.cards[selectedCardIndices[0]],
                                       game.cards[selectedCardIndices[1]],
                                       game.cards[selectedCardIndices[2]]]
        var counter = 0
        var cardsIndices = [Int]()
        var origRect = CGRect()
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
            counter += 1
            for view in viewsToBeRemoved{
                self.collisionBehavior.addItem(view)
                self.itemBehavior.addItem(view)
                let push = UIPushBehavior(items: [view], mode: .instantaneous)
                push.angle = CGFloat.random(in: 0...2*CGFloat.pi)
                push.magnitude = 50
                push.action = { [unowned push] in
                    push.dynamicAnimator?.removeBehavior(push)
                }
                let x = self.trashDeckView.bounds.width/view.bounds.width
                let transformScale = CGAffineTransform.identity.scaledBy(x: x, y: x)
                origRect = self.trashDeckView.convert(view.frame.applying(transformScale), from: self.cardContainerView)

                view.removeFromSuperview()
                self.trashDeckView.addSubview(view)
                self.animator.addBehavior(push)
            }
            if counter == 5 {
                timer.invalidate()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { (_) in
            for i in viewsToBeRemoved.indices{
                let view = viewsToBeRemoved[i]
                let card = cardsToBeRemoved[i]
                cardsIndices.append(self.game.cards.firstIndex(of: card)!)
                self.itemBehavior.removeItem(view)
                self.collisionBehavior.removeItem(view)
                view.frame = origRect

                self.game.cards.remove(at: self.game.cards.firstIndex(of: card)!)

                let snap = UISnapBehavior(item: view, snapTo: self.trashDeckView.center)
                snap.damping = 0.5
                self.animator.addBehavior(snap)
//                view.frame = self.trashDeckView.bounds

            }
            if !self.deckView.subviews.isEmpty{
                var count = 2
                for _ in 0...2{
                    let view = self.deckView.subviews.first!
                    let card = self.game.cardsInDeck.removeFirst()	
                    guard let cardView = view as? CardView else { return }
                    let frame = self.cardContainerView.convert(cardView.frame, from: self.deckView)
                    cardView.removeFromSuperview()
                    
                    self.game.cards.insert(card, at: cardsIndices[count])
                    self.cardContainerView.insertSubview(cardView, at: cardsIndices[count])
                    print(cardsIndices[count])
                    cardView.isFlipped = false
                    
                    cardView.frame = frame
                    cardView.backgroundColor = .white
                    cardView.setNeedsDisplay()
                    count -= 1
                }
            }
            self.game.removeSelectedCards()
            self.cardContainerView.animateFrameChange()
            self.updateBorderColor()
//            print(self.game.cards)
        }

    }
    
    func addCards(of quantity:Int){
        cardContainerView.addToCellCount(quantity)
        var viewsToBeAdded = [UIView]()
        if deckView.subviews.count >= quantity {
            for _ in 0..<quantity{
                let cardView = deckView.subviews.first!
                let frame = cardContainerView.convert(cardView.frame, from: cardView.superview)

                cardView.removeFromSuperview()
                cardContainerView.addSubview(cardView)
                cardView.frame = frame
                viewsToBeAdded.append(cardView)
                game.cards.append(game.cardsInDeck.removeFirst())
            }
            
            cardContainerView.animateAddingOfCards(for: viewsToBeAdded)
        }
        cardContainerView.animateFrameChange()
        updateBorderColor()
//        updateViewFromModel()
    }
    
    func createDeckOfCardViews(){
        for subview in cardContainerView.subviews{
            subview.removeFromSuperview()
        }
        for subview in deckView.subviews{
            subview.removeFromSuperview()
        }
        
        for i in game.cardsInDeck.indices {
            let card = game.cardsInDeck[i]
            let cardView = CardView(frame: deckView.bounds)
            deckView.addSubview(cardView)
            
            cardView.with(shape: card.shape(), texture: card.texture(), count: card.number, color: card.color())
        }
    }
    
    func randomizeCards(){
        for _ in 0...2{
            for i in game.cards.indices{
                let ran = Int.random(in: 0..<game.cards.count)
                game.cards.swapAt(i, ran)
                cardContainerView.exchangeSubview(at: i, withSubviewAt: ran)
            }
        }
    }
    
    func updateBorderColor(){
        for i in cardContainerView.subviews.indices{
            let cardView = cardContainerView.subviews[i]
            let card = game.cards[i]
            cardView.layer.borderWidth = 1
            cardView.layer.borderColor = UIColor.black.cgColor
            if game.matchingOnLastChooseCard && game.selectedCard.contains(card){
                if !game.isASet{
                    cardView.layer.borderWidth = 10
                    cardView.layer.borderColor = UIColor.red.cgColor
                }
            } else if game.selectedCard.contains(card) {
                print(card)
                cardView.layer.borderWidth = 10
                cardView.layer.borderColor = UIColor.yellow.cgColor
            }
        }
        
        //update points
        pointLabel?.text = "Points:\(game.points)"
        
    }//updateviewfrommodel
    func updateViewFromModel(){
        for i in game.cards.indices{
            let card = game.cards[i]
            let cardView = cardContainerView.subviews[i] as! CardView
            cardView.with(shape: card.shape(), texture: card.texture(), count: card.number, color: card.color())
            cardView.setNeedsDisplay()
        }
    }
}


extension SetViewController:UIDynamicAnimatorDelegate{
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        for view in trashDeckView.subviews{
            if view != trashDeckView.subviews.last{
                let view = view as! CardView
                view.isFlipped = true
                view.setNeedsDisplay()
            }
        }
        if let cardView = trashDeckView.subviews.last as? CardView{
            UIView.transition(with: cardView, duration: 1, options: .transitionFlipFromLeft, animations: {
                cardView.isFlipped = true
                cardView.setNeedsDisplay()
            })
            
        }
    }
}
