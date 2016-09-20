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
    func saveImages(_ fullImageData: Data)
    func saveTurn(_ letter: String)
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

    fileprivate var full: Data?
    fileprivate var drawingMode: DrawingMode = .draw
    
    required init(view: DrawingView, game: Game, gameService: GameService) {
        self.view = view
        self.game = game
        self.gameService = gameService
    }

    func loadPreviousTurns() {
        gameService.loadImageData(game.id!) { result in
            switch result {
            case .success(let imageData): self.drawingService.setImageData(imageData)
            case .failure(let err): self.view.showError(err)
            }
        }
    }
    
    func saveImages() {
        guard let fullImageData = drawingService.fullImageData else {
            fatalError("Can't get the image data")
        }
        full = fullImageData as Data
    }

    func saveTurn(_ letter: String, completion: @escaping (Error?) -> ()) {
        guard let fullImageData = full else {
            fatalError("Did not set the images before saving")
        }

        gameService.saveTurn(game.id!, image: fullImageData, letter: letter) { result in
            switch result {
            case .success(let updatedGame):
                let wrappedGame = Wrapper<Game>(theValue: updatedGame)

                if updatedGame.gameOver {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "GameOver"), object: nil, userInfo: ["game": wrappedGame])
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "TurnComplete"), object: nil, userInfo: ["game": wrappedGame])
                }

                completion(nil)
                
                self.view.goToMainMenu()
            case .failure(let err): completion(err)
            }
        }
    }
    
    func enterDrawMode() {
        guard drawingMode != .draw else {
            return
        }
        
        drawingMode = .draw
        
        drawingService.drawingMode = .draw
        
        view.switchToDrawMode()
    }
    
    func enterEraseMode() {
        guard drawingMode != .erase else {
            return
        }

        drawingMode = .erase
        drawingService.drawingMode = .erase
        
        view.switchToEraseMode()
    }
    
    func undo() {
        drawingService.undo()
    }
    
    func redo() {
        drawingService.redo()
    }
    
    func startDraw(_ point: CGPoint) {
        drawingService.startDraw(point)
    }
    
    func movePencilTo(_ point: CGPoint) {
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
