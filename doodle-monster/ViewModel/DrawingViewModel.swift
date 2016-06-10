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

    init(view: DrawingView, game: Game, gameService: GameService)
    func saveImages(fullImageData: NSData)
    func saveTurn(letter: String)
    func enterDrawMode()
    func enterEraseMode()
    func cancelDrawing()
}

class DrawingViewModel: NSObject {
    let view: DrawingView
    let game: Game
    let gameService: GameService

    var drawingService: DrawingServiceProtocol!
    
    var name: String {
        return game.name ?? ""
    }

    private var full: NSData?
    private var drawingMode: DrawingMode = .Draw
    
    required init(view: DrawingView, game: Game, gameService: GameService) {
        self.view = view
        self.game = game
        self.gameService = gameService
    }

    func loadPreviousTurns() {
        gameService.loadImageData(game.id!) { result in
            switch result {
            case .Success(let imageData): self.drawingService.setImageData(imageData)
            case .Failure(let err): self.view.showError(err)
            }
        }
    }
    
    func saveImages() {
        guard let fullImageData = drawingService.fullImageData else {
            fatalError("Can't get the image data")
        }
        full = fullImageData
    }

    func saveTurn(letter: String, completion: (ErrorType?) -> ()) {
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

                completion(nil)
                
                self.view.goToMainMenu()
            case .Failure(let err): completion(err)
            }
        }
    }
    
    func enterDrawMode() {
        guard drawingMode != .Draw else {
            return
        }
        
        drawingMode = .Draw
        
        drawingService.drawingMode = .Draw
        
        view.switchToDrawMode()
    }
    
    func enterEraseMode() {
        guard drawingMode != .Erase else {
            return
        }

        drawingMode = .Erase
        drawingService.drawingMode = .Erase
        
        view.switchToEraseMode()
    }
    
    func undo() {
        drawingService.undo()
    }
    
    func redo() {
        drawingService.redo()
    }
    
    func startDraw(point: CGPoint) {
        drawingService.startDraw(point)
    }
    
    func movePencilTo(point: CGPoint) {
        drawingService.movePencilTo(point)
    }
    
    func endDraw() {
        drawingService.endDraw()
    }
    
    func abortLine() {
        drawingService.abortLine()
    }
    
    func cancelDrawing() {
        if drawingService.hasMadeChanges() {
            view.showCancelConfirmation()
        } else {
            view.goToMainMenu()
        }
    }
}
