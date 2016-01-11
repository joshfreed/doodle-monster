//
//  MainMenuViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

protocol MainMenuViewModelProtocol {
    var yourTurnGames: [GameViewModel] { get }
    var waitingGames: [GameViewModel] { get }

    var gamesUpdated: (() -> ())? { get set }

    init(gameService: GameService, currentPlayer: Player)
    func loadItems()
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
}
