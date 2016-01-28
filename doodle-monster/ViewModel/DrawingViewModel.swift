//
//  DrawingViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

protocol DrawingViewModelProtocol {
    var name: String { get }

    init(game: Game)
    func saveImages(currentImageData: NSData, fullImageData: NSData)
    func saveTurn(letter: String)
}

class DrawingViewModel: NSObject {
    let game: Game

    var name: String {
        return game.name
    }

    private var full: NSData?
    
    required init(game: Game) {
        self.game = game
    }

    func saveImages(currentImageData: NSData, fullImageData: NSData) {
        full = fullImageData
    }

    func saveTurn(letter: String, completion: () -> ()) {
        guard let fullImageData = full else {
            fatalError("Did not set the images before saving")
        }

        let params = [
            "gameId": game.objectId!,
            "monsterImage": fullImageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength),
            "letter": letter
        ]
        PFCloud.callFunctionInBackground("saveTurn", withParameters: params) {
            (response: AnyObject?, error: NSError?) -> Void in
            print("RESPONSE \(response) ERROR \(error)")
            
            guard let updatedGame = response as? Game else {
                fatalError("Unknown response")
            }

            self.game.thumbnail = updatedGame.thumbnail
            self.game.imageFile = updatedGame.imageFile
            self.game.name = updatedGame.name
            self.game.lastTurn = updatedGame.lastTurn
            self.game.currentPlayerNumber = updatedGame.currentPlayerNumber
            self.game.gameOver = updatedGame.gameOver

            if self.game.gameOver {
                NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: nil, userInfo: ["game": self.game])
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("TurnComplete", object: nil, userInfo: ["game": self.game])
            }
            
            completion()
        }
    }
}
