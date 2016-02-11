//
//  MainMenuViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

protocol MainMenuView {
    func updateGameList()
}

protocol MainMenuViewModelProtocol: class {
    var yourTurnGames: [GameViewModel] { get }
    var waitingGames: [GameViewModel] { get }

    init(view: MainMenuView,
         gameService: GameService,
         session: SessionService,
         router: MainMenuRouter,
         listener: MainMenuViewModelListener)
    func loadItems()
    func refresh()
    func signOut()
    func newMonster()
    func selectGame(index: Int)
}

class MainMenuViewModel: MainMenuViewModelProtocol {
    let view: MainMenuView
    let gameService: GameService
    let session: SessionService
    let router: MainMenuRouter
    let listener: MainMenuViewModelListener

    // Observables
    var yourTurnGames: [GameViewModel] = []
    var waitingGames: [GameViewModel] = []

    required init(view: MainMenuView,
                  gameService: GameService,
                  session: SessionService,
                  router: MainMenuRouter,
                  listener: MainMenuViewModelListener) {
        self.view = view
        self.gameService = gameService
        self.session = session
        self.router = router
        self.listener = listener
        self.listener.viewModel = self
        self.listener.startListening()
    }

    deinit {
        print("MainMenuViewModel::deinit")
        self.listener.stopListening()
    }

    func newGameStarted(game: Game) {
        yourTurnGames.append(GameViewModel(game: game))
        view.updateGameList()
    }

    func turnComplete(game: Game) {
        removeGameFromYourTurn(game)
        waitingGames.append(GameViewModel(game: game))
        view.updateGameList()
    }

    func gameOver(game: Game) {
        removeGameFromYourTurn(game)
        view.updateGameList()
    }

    // TODO: move to Array extension
    private func arrayToDict(games: [Game]) -> [String: Game] {
        var result: [String: Game] = [:]
        for game in games {
            result[game.id!] = game
        }
        return result
    }

    // TODO: move to array extension
    // TODO: remove GameViewModel
    private func removeGameFromYourTurn(game: Game) {
        var indexToMove: Int?
        for (index, vm) in yourTurnGames.enumerate() {
            if vm.game.id == game.id {
                indexToMove = index
                break
            }
        }

        guard let index = indexToMove else {
            print("Game not found \(game)")
            return
        }

        yourTurnGames.removeAtIndex(index)
    }

    // MARK: - MainMenuViewModelProtocol

    func loadItems() {
        guard let currentPlayer = session.currentPlayer else {
            fatalError("Tried to load games but no one is logged in")
        }

        gameService.getActiveGames() { games in
            for game in games {
                if game.isCurrentTurn(currentPlayer) {
                    self.yourTurnGames.append(GameViewModel(game: game))
                } else if game.isWaitingForAnotherPlayer(currentPlayer) {
                    self.waitingGames.append(GameViewModel(game: game))
                }
            }

            self.view.updateGameList()
        }
    }
    
    func refresh() {
        self.yourTurnGames = []
        self.waitingGames = []
        loadItems()
    }
    
    func signOut() {
        session.logout()
        router.showLoginScreen()
    }

    func newMonster() {
        router.showNewMonsterScreen()
    }

    func selectGame(index: Int) {
        let game = yourTurnGames[index].game
        router.showDrawingScreen(game)
    }
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

class MainMenuViewModelListener {
    weak var viewModel: MainMenuViewModel?

    private var newGameObserver: NSObjectProtocol?
    private var turnCompleteObserver: NSObjectProtocol?
    private var gameOverObserver: NSObjectProtocol?

    func startListening() {
        let center = NSNotificationCenter.defaultCenter()
        newGameObserver = center.addObserverForName("NewGameStarted", object: nil, queue: nil) { [weak self] n in self?.newGameStarted(n) }
        turnCompleteObserver = center.addObserverForName("TurnComplete", object: nil, queue: nil)  { [weak self] n in self?.turnComplete(n) }
        gameOverObserver = center.addObserverForName("GameOver", object: nil, queue: nil)  { [weak self] n in self?.gameOver(n) }
    }

    func stopListening() {
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

    func newGameStarted(notification: NSNotification) {
        guard let userInfo = notification.userInfo, wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        viewModel?.newGameStarted(wrapper.wrappedValue)
    }

    func turnComplete(notification: NSNotification) {
        guard let userInfo = notification.userInfo, wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        viewModel?.turnComplete(wrapper.wrappedValue)
    }

    func gameOver(notification: NSNotification) {
        guard let userInfo = notification.userInfo, wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        viewModel?.gameOver(wrapper.wrappedValue)
    }
}