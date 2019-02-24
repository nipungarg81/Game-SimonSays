//
//  ViewController.swift
//  SimonSays
//
//  Created by Nipun Garg on 9/6/18.
//  Copyright © 2018 Nipun Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButton: [CircularButton]!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var scoreLabel: [UILabel]!
    @IBOutlet var playerLabel: [UILabel]!
    
    var currentPlayer = 0
    var score = [0,0]
    
    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsToTap = [Int]()
    
    var gameEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        colorButton = customSort(obj: colorButton) as! [CircularButton]
        scoreLabel = customSort(obj: scoreLabel) as! [UILabel]
        playerLabel = customSort(obj:playerLabel) as! [UILabel]
        print()
        createNewGame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded == true {
            gameEnded = false
            createNewGame()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        for button in colorButton {
            button.alpha = 0.5
            button.isEnabled = false
        }
        
        currentPlayer = 0
        score = [0,0]
        playerLabel[currentPlayer].alpha = 1.0
        playerLabel[1].alpha = 0.75
    }
    
    func updateScoreLabels() {
        for (index, label) in scoreLabel.enumerated() {
            label.text = "\(score[index])"
        }
    }
    
    func switchPlayer() {
        playerLabel[currentPlayer].alpha = 0.75
        currentPlayer = currentPlayer == 0 ? 1:0
        playerLabel[currentPlayer].alpha = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customSort(obj:Array<AnyObject>) -> Array<AnyObject>{
        var object = obj
        object = object.sorted() {
            $0.tag < $1.tag
        }
        return object
    }
    
    func addNewColor() {
        colorSequence.append(Int(arc4random_uniform(UInt32(4))))
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flash(button: colorButton[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the Circle", for: .normal)
            for button in colorButton {
                button.isEnabled = true
            }
        }
    }
    
    func flash(button:CircularButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (Bool) in
            self.playSequence()
        }
    }
    
    @IBAction func actionButtonHandler(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        addNewColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 Wins!": "Player 1 Wins!"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true
        createNewGame()
    }
    
    @IBAction func colorButtonHandler(_ sender: CircularButton) {
        if sender.tag == colorsToTap.removeFirst() {
            
        } else {
            for button in colorButton {
                button.isEnabled = false
            }
            endGame()
            return
        }
        if colorsToTap.isEmpty {
            for button in colorButton {
                button.isEnabled = false
            }
            score[currentPlayer] += 1
            updateScoreLabels()
            switchPlayer()
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
        
    }
}

