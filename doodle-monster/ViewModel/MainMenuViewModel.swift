//
//  MainMenuViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

protocol MainMenuViewModelProtocol: class {
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
        return "Waiting on " + game.currentPlayerName
    }

    var monsterName: String {
        return game.name
    }
    
    var lastTurnText: String {
        return "Last turn " + game.friendlyLastTurnText()
    }
    
    var playerInfo: String {
        return "\(game.players.count) doodlers"
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
    private var newGameObserver: NSObjectProtocol?
    private var turnCompleteObserver: NSObjectProtocol?

    required init(gameService: GameService, currentPlayer: Player) {
        self.gameService = gameService
        self.currentPlayer = currentPlayer
        newGameObserver = NSNotificationCenter.defaultCenter().addObserverForName("NewGameStarted", object: nil, queue: nil) { [weak self] n in self?.newGameStarted(n) }
        turnCompleteObserver = NSNotificationCenter.defaultCenter().addObserverForName("TurnComplete", object: nil, queue: nil)  { [weak self] n in self?.turnComplete(n) }
    }

    deinit {
        print("main menu view model deinit")
        if newGameObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(newGameObserver!)
        }
        if turnCompleteObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(turnCompleteObserver!)
        }
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
        return DrawingViewModel(game: yourTurnGames[index].game)
    }

    private func moveGameToWaiting(game: Game) {
        var indexToMove: Int?
        for (index, vm) in yourTurnGames.enumerate() {
            if vm.game.objectId == game.objectId {
                indexToMove = index
                break
            }
        }
        
        guard let index = indexToMove else {
            fatalError("Game not found")
        }
        
        let element = yourTurnGames.removeAtIndex(index)
        waitingGames.append(element)
    }

    func signOut() {
        PFUser.logOut()
        self.signedOut?()
    }

    func newMonster() {
        self.routeToNewMonster?()
    }

    func newGameStarted(notification: NSNotification) {
        guard let userInfo = notification.userInfo, game = userInfo["game"] as? Game else {
            fatalError("Missing game in message");
        }

        self.yourTurnGames.append(GameViewModel(game: game))
        self.gamesUpdated?()
    }

    func turnComplete(notification: NSNotification) {
        guard let userInfo = notification.userInfo, game = userInfo["game"] as? Game else {
            fatalError("Missing game in message");
        }

        self.moveGameToWaiting(game)
        self.gamesUpdated?()
    }
}
