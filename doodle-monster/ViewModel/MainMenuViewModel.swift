//
//  MainMenuViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

protocol MainMenuViewModelProtocol {
    var yourTurnGames: [GameViewModel] { get }
    var waitingGames: [GameViewModel] { get }

    var gamesUpdated: (() -> ())? { get set }
    var signedOut: (() -> ())? { get set }
    var routeToNewMonster: (() -> ())? { get set }

    init(gameService: GameService, currentPlayer: Player)
    func loadItems()
    func getDrawingViewModel(index: Int) -> DrawingViewModel
    func signOut()
    func newMonster()
}

struct GameViewModel {
    let game: Game
    
    var currentPlayerName: String {
        return "Fred"
    }

    init(game: Game) {
        self.game = game
    }
}

class MainMenuViewModel: MainMenuViewModelProtocol {
    let gameService: GameService
    let currentPlayer: Player
    var yourTurnGames: [GameViewModel] = []
    var waitingGames: [GameViewModel] = []

    var gamesUpdated: (() -> ())?
    var signedOut: (() -> ())?
    var routeToNewMonster: (() -> ())?

    private var gameModels: [Game] = []

    required init(gameService: GameService, currentPlayer: Player) {
        self.gameService = gameService
        self.currentPlayer = currentPlayer
    }

    func loadItems() {
        gameService.getActiveGames() { games in
            self.gameModels = games
            for game in games {
                if game.isCurrentTurn(self.currentPlayer) {
                    self.yourTurnGames.append(GameViewModel(game: game))
                } else if game.isWaitingForAnotherPlayer(self.currentPlayer) {
                    self.waitingGames.append(GameViewModel(game: game))
                }
            }
            self.gamesUpdated?()
        }
    }
    
    func getDrawingViewModel(index: Int) -> DrawingViewModel {
        return DrawingViewModel(game: gameModels[index])
    }

    func signOut() {
        PFUser.logOut()
        self.signedOut?()
    }

    func newMonster() {
        self.routeToNewMonster?()
    }
}
