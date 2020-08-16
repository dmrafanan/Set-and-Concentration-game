import UIKit

class SetViewController: UIViewController {
    var game = Set(){
        didSet {
            createDeckOfCardViews()
            addCards(of: 12)
            print("didset")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Set()
//        addCards(of: 12)
//        createDeckOfCardViews()
    }
    
    
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
            game.cards.shuffle()
            updateViewFromModel()
        default:
            break
        }
    }
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
//        for subview in cardContainerView.subviews{
//            subview.removeFromSuperview()
//        }
        game = Set()
        updateViewFromModel()
    }
    
    @IBOutlet weak var addCardButton: UIButton!
    
    @IBAction func touchAddCardButton(_ sender: UIButton) {
        addCards(of: 3)
    }
    
    func addCards(of quantity:Int){
        //if there are available cards
        if deckView.subviews.count >= quantity{
            for _ in 0..<quantity{
                let cardView = deckView.subviews.first
                cardView?.removeFromSuperview()
                cardContainerView.addSubview(cardView!)
                
                game.cards.append(game.cardsInDeck.removeFirst())
            }
        }
        
        updateViewFromModel()
    }
    
    @objc func tapCardContainerView(sender:UITapGestureRecognizer){
        //TODO
        let location = sender.location(in: cardContainerView)
        let subview = cardContainerView.hitTest(location, with: nil)!
        // if location is a card
        guard let index = cardContainerView.subviews.firstIndex(of: subview) else{
            return
        }
        game.chooseCard(atCardIndex: index)
        updateViewFromModel()
        game.removeSelectedCards()
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
            let cardView = CardView()
            cardView.frame = deckView.frame
            cardView.clipsToBounds = true
            cardView.with(shape: card.shape(), texture: card.texture(), count: card.number, color: card.color())
            cardView.translatesAutoresizingMaskIntoConstraints = false
            deckView.addSubview(cardView)
        }
    }
    
    func updateViewFromModel(){
//        configure card buttons
        for i in game.cards.indices{
            let cardView = cardContainerView.subviews[i]
            let card = game.cards[i]
                cardView.layer.borderColor = UIColor.clear.cgColor
                if game.matchingOnLastChooseCard && game.selectedCard.contains(card){
                    cardView.layer.borderWidth = 10
                    if !game.isASet{
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
}


