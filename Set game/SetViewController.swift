import UIKit

class SetViewController: UIViewController {
    var game = Set(){
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
        game = Set()
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
        game = Set()
        updateBorderColor()
    }
    
    @IBOutlet weak var addCardButton: UIButton!
    
    @IBAction func touchAddCardButton(_ sender: UIButton) {
        addCards(of: 3)
    }
    
    lazy var itemBehavior:UIDynamicItemBehavior = {
       let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = true
        itemBehavior.elasticity = 1
        itemBehavior.resistance = 0
        animator.addBehavior(itemBehavior)
        return itemBehavior
    }()
    lazy var collisionBehavior:UICollisionBehavior = {
       let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        return collisionBehavior
    }()
    
    
    @objc func tapCardContainerView(sender:UITapGestureRecognizer){
        //TODO
        //        guard let view = sender.view else { return  }
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
        }
        game.removeSelectedCards()

    }
    
    func animateRemoveMatchedViewsFromCardContainer(){
        let selectedCardIndices = game.returnSelectedCardIndices()
        let viewsToBeRemoved:[UIView] = [cardContainerView.subviews[selectedCardIndices[0]],
                                         cardContainerView.subviews[selectedCardIndices[1]],
                                         cardContainerView.subviews[selectedCardIndices[2]]]
        for _ in 0...2{
            for view in viewsToBeRemoved{
                itemBehavior.addItem(view)
                let push = UIPushBehavior(items: [view], mode: .instantaneous)
                push.angle = CGFloat.random(in: 0...2*CGFloat.pi)
                push.magnitude = 20
                push.action = { [unowned push] in
                    push.dynamicAnimator?.removeBehavior(push)
                }
                animator.addBehavior(push)
            }
        }
        for view in viewsToBeRemoved{
            let x = trashDeckView.bounds.width/view.bounds.width
            let transformScale = CGAffineTransform.identity.scaledBy(x: x, y: x)
            let origRect = trashDeckView.convert(view.frame.applying(transformScale), from: cardContainerView)
            view.removeFromSuperview()
            trashDeckView.addSubview(view)
            view.frame = origRect
            let snap = UISnapBehavior(item: view, snapTo: trashDeckView.center)
            snap.damping = 0.5
            animator.addBehavior(snap)
        }
        game.removeSelectedCards()


        addCards(of: 3)

        
    }
    
    func addCards(of quantity:Int){
        //if there are available cards
//        if deckView.subviews.count < quantity{
//            return
//        }
        cardContainerView.addToCellCount(quantity)
        var viewsToBeAdded = [UIView]()
        if deckView.subviews.count >= quantity {
//            var timer = TimeInterval(exactly: 0)!
            for _ in 0..<quantity{
//                timer += 1
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
        updateViewFromModel()
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
            deckView.insertSubview(cardView, at: deckView.subviews.count)
            
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


