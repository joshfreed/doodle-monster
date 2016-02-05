//
//  MainMenuViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

protocol MainMenuViewModelProtocol: class {
    var yourTurnGames: [GameViewModel] { get }
    var waitingGames: [GameViewModel] { get }

    var gamesUpdated: (() -> ())? { get set }
    var signedOut: (() -> ())? { get set }
    var routeToNewMonster: (() -> ())? { get set }

    init(gameService: GameService, currentPlayer: Player, session: SessionService)
    func loadItems()
    func refresh()
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
    let session: SessionService
    var yourTurnGames: [GameViewModel] = []
    var waitingGames: [GameViewModel] = []

    var gamesUpdated: (() -> ())?
    var signedOut: (() -> ())?
    var routeToNewMonster: (() -> ())?

    private var gameModels: [Game] = []
    private var newGameObserver: NSObjectProtocol?
    private var turnCompleteObserver: NSObjectProtocol?
    private var gameOverObserver: NSObjectProtocol?

    required init(gameService: GameService, currentPlayer: Player, session: SessionService) {
        self.gameService = gameService
        self.currentPlayer = currentPlayer
        self.session = session
        newGameObserver = NSNotificationCenter.defaultCenter().addObserverForName("NewGameStarted", object: nil, queue: nil) { [weak self] n in self?.newGameStarted(n) }
        turnCompleteObserver = NSNotificationCenter.defaultCenter().addObserverForName("TurnComplete", object: nil, queue: nil)  { [weak self] n in self?.turnComplete(n) }
        gameOverObserver = NSNotificationCenter.defaultCenter().addObserverForName("GameOver", object: nil, queue: nil)  { [weak self] n in self?.gameOver(n) }
    }

    deinit {
        print("main menu view model deinit")
        if newGameObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(newGameObserver!)
        }
        if turnCompleteObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(turnCompleteObserver!)
        }
        if gameOverObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(gameOverObserver!)
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
    
    func refresh() {
        self.yourTurnGames = []
        self.waitingGames = []
        loadItems()
    }
    
    func getDrawingViewModel(index: Int) -> DrawingViewModel {
        return DrawingViewModel(game: yourTurnGames[index].game, gameService: gameService)
    }

    private func moveGameToWaiting(game: Game) {
        let element = removeGameFromYourTurn(game)
        waitingGames.append(element)
    }

    private func removeGameFromYourTurn(game: Game) -> GameViewModel {
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

        return yourTurnGames.removeAtIndex(index)
    }

    func signOut() {
        session.logout()
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

    func gameOver(notification: NSNotification) {
        guard let userInfo = notification.userInfo, game = userInfo["game"] as? Game else {
            fatalError("Missing game in message");
        }

        print("GAME OVER BITCHES")

        self.removeGameFromYourTurn(game)
        self.gamesUpdated?()
    }
}
