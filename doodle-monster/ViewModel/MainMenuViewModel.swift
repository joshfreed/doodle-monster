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

    init(gameService: GameService, currentPlayer: Player, session: SessionService, router: MainMenuRouter)
    func loadItems()
    func refresh()
    func getDrawingViewModel(index: Int) -> DrawingViewModel
    func signOut()
    func newMonster()
}

struct GameViewModel: Equatable {
    let game: Game
    
    var currentPlayerName: String {
        return "Waiting on " + game.currentPlayerName
    }

    var monsterName: String {
        return game.name ?? ""
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

func ==(lhs: GameViewModel, rhs: GameViewModel) -> Bool {
    return lhs.game.id == rhs.game.id
}

class MainMenuViewModel: MainMenuViewModelProtocol {
    let gameService: GameService
    let currentPlayer: Player
    let session: SessionService
    let router: MainMenuRouter
    var yourTurnGames: [GameViewModel] = []
    var waitingGames: [GameViewModel] = []

    var gamesUpdated: (() -> ())?
    var signedOut: (() -> ())?

    private var games: [String: Game] = [:]
    private var newGameObserver: NSObjectProtocol?
    private var turnCompleteObserver: NSObjectProtocol?
    private var gameOverObserver: NSObjectProtocol?

    required init(gameService: GameService, currentPlayer: Player, session: SessionService, router: MainMenuRouter) {
        self.gameService = gameService
        self.currentPlayer = currentPlayer
        self.session = session
        self.router = router
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
            self.games = self.arrayToDict(games)

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
        removeGameFromYourTurn(game)
        waitingGames.append(GameViewModel(game: game))
    }

    // TODO: move to array extension
    // TODO: remove GameViewModel
    private func removeGameFromYourTurn(game: Game) -> GameViewModel {
        var indexToMove: Int?
        for (index, vm) in yourTurnGames.enumerate() {
            if vm.game.id == game.id {
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
        router.showNewMonsterScreen()
    }

    func newGameStarted(notification: NSNotification) {
        guard let userInfo = notification.userInfo, wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }
        
        let game = wrapper.wrappedValue

        games[game.id!] = game
        self.yourTurnGames.append(GameViewModel(game: game))
        self.gamesUpdated?()
    }

    func turnComplete(notification: NSNotification) {
        guard let userInfo = notification.userInfo, wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }
        
        let game = wrapper.wrappedValue

        games[game.id!] = game
        self.moveGameToWaiting(game)
        self.gamesUpdated?()
    }

    func gameOver(notification: NSNotification) {
        guard let userInfo = notification.userInfo, wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        let game = wrapper.wrappedValue

        games[game.id!] = game
        self.removeGameFromYourTurn(game)
        self.gamesUpdated?()
    }



    // TODO: move to Array extension
    private func arrayToDict(games: [Game]) -> [String: Game] {
        var result: [String: Game] = [:]
        for game in games {
            result[game.id!] = game
        }
        return result
    }
}