//
//  Game.swift
//  Apple Pie
//
//  Created by Abdinasir Muhumed on 10/19/19.
//  Copyright © 2019 Abdinasir Muhumed. All rights reserved.
//

import Foundation

struct Game{
    var word : String
    var incorrectMovesRemaining : Int
    var guessedLetters : [Character]
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
    
    mutating func playerGuessed(char : Character){
        guessedLetters.append(char)
        
        if !word.contains(char){
            incorrectMovesRemaining -= 1
        }
    }
}
