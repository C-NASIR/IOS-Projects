//
//  ViewController.swift
//  Apple Pie
//
//  Created by Abdinasir Muhumed on 10/19/19.
//  Copyright © 2019 Abdinasir Muhumed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlet properties
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    //MARK: Other properties
    var listOfWords = ["buccaneer", "swift", "glorious",
    "incandescent", "bug", "program"]
    var incorrectAnswersAllowed = 7
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    
    var totalLoses = 0 {
        didSet {
            newRound()
        }
    }
    
    var currentGame : Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newRound()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(char: letter)
        updateGameStatus()
    }
    
    func newRound(){
        if !listOfWords.isEmpty {
            enableLetterButtons(true)
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectAnswersAllowed,guessedLetters: [])
            UpdateUI()
        }else {
            enableLetterButtons(false)
        }
    }
    
    func UpdateUI(){
        var letters = [String]()
        
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins)  losses: \(totalLoses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    func updateGameStatus(){
        if currentGame.incorrectMovesRemaining == 0 {
            totalLoses += 1
        } else if currentGame.word == currentGame.formattedWord{
            totalWins += 1
        } else {
            UpdateUI()
        }
    }
    
    func enableLetterButtons(_ enabled : Bool){
        for button in letterButtons{
            button.isEnabled = enabled
        }
    }
    
}

