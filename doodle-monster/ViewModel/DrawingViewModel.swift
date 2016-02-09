//
//  DrawingViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol DrawingViewModelProtocol {
    var name: String { get }

    init(game: Game, gameService: GameService)
    func saveImages(currentImageData: NSData, fullImageData: NSData)
    func saveTurn(letter: String)
}

class DrawingViewModel: NSObject {
    let game: Game
    let gameService: GameService

    var name: String {
        return game.name ?? ""
    }

    private var full: NSData?
    
    required init(game: Game, gameService: GameService) {
        self.game = game
        self.gameService = gameService
    }

    func saveImages(currentImageData: NSData, fullImageData: NSData) {
        full = fullImageData
    }

    func saveTurn(letter: String, completion: () -> ()) {
        guard let fullImageData = full else {
            fatalError("Did not set the images before saving")
        }

        gameService.saveTurn(game.id!, image: fullImageData, letter: letter) { result in
            switch result {
            case .Success(let updatedGame):
                let wrappedGame = Wrapper<Game>(theValue: updatedGame)

                if updatedGame.gameOver {
                    NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: nil, userInfo: ["game": wrappedGame])
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName("TurnComplete", object: nil, userInfo: ["game": wrappedGame])
                }

                completion()
            case .Failure(let error):
                fatalError("Failed to save turn")
            }
        }
    }
}
