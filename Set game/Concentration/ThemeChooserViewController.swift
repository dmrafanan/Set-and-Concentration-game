//
//  ThemeChooserViewController.swift
//  Set game
//
//  Created by Daniel Marco S. Rafanan on Aug/27/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class ThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    
    var themeChoices:[String:[Character]] = [
        "Sports":["🏉","🏈","🏐","⚾️","🏀","🥎","🎾","⚽️"],
        "Animals":["🐈","🐁","🦩","🦧","🦢","🦙","🦕","🐓"],
        "Faces":["😂","😇","😍","😘","😎","🤪","😭","😡"]
    ]
    
    
    @IBAction func changeTheme(_ sender: Any) {
        let sender = sender as? UIButton
        let emojiArray = themeChoices[sender!.title(for: .normal)!]!
        if let cvc = pushedConcentrationViewController{
            cvc.emojiArray = emojiArray
            print("b")
            navigationController?.present(cvc, animated: true)
        }else if let cvc = lastConcentrationViewController{
            cvc.emojiArray = emojiArray
            print("a")
        }else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    
    private var pushedConcentrationViewController:ConcentrationViewController? {
        return navigationController?.topViewController as? ConcentrationViewController
    }
    
    private var lastConcentrationViewController:ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("c")
        if let sender = sender as? UIButton,let title = sender.currentTitle,let cvc = segue.destination as? ConcentrationViewController,segue.identifier == "Choose Theme"
        {
            let emojiArray = themeChoices[sender.title(for: .normal)!]!
            cvc.emojiArray = emojiArray
        }
    }
}
