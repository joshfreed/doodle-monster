//
//  MainMenuViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/7/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import EmitterKit

protocol MainMenuView {
    func updateGameList()
    func showServerError(_ err: Error)
}

protocol MainMenuViewModelProtocol: class {
    var yourTurnGames: [GameViewModel] { get }
    var waitingGames: [GameViewModel] { get }

    init(view: MainMenuView,
         api: DoodMonApi,
         session: DoodMonSession,
         router: MainMenuRouter,
         listener: MainMenuViewModelListener,
         applicationLayer: DoodleMonster)
    func loadItems()
    func refresh()
    func signOut()
    func newMonster()
    func selectGame(_ index: Int)
}

class MainMenuViewModel: MainMenuViewModelProtocol {
    let view: MainMenuView
    let api: DoodMonApi
    let session: DoodMonSession
    let router: MainMenuRouter
    let listener: MainMenuViewModelListener
    let appLayer: DoodleMonster

    // Observables
    var yourTurnGames: [GameViewModel] = []
    var waitingGames: [GameViewModel] = []
    
    fileprivate var listeners: [Listener] = []

    required init(view: MainMenuView,
                  api: DoodMonApi,
                  session: DoodMonSession,
                  router: MainMenuRouter,
                  listener: MainMenuViewModelListener,
                  applicationLayer: DoodleMonster) {
        self.view = view
        self.api = api
        self.session = session
        self.router = router
        self.listener = listener
        self.appLayer = applicationLayer
        self.listener.viewModel = self
        self.listener.startListening()
                    
        listeners += self.appLayer.newGameStarted.on { [weak self] n in self?.newGameStarted(n) }
    }

    deinit {
        print("MainMenuViewModel::deinit")
        self.listener.stopListening()
    }

    func newGameStarted(_ game: Game) {
        yourTurnGames.append(GameViewModel(game: game))
        view.updateGameList()
    }

    func turnComplete(_ game: Game) {
        let vm = GameViewModel(game: game)
        yourTurnGames.remove(vm)
        waitingGames.append(vm)
        view.updateGameList()
    }

    func gameOver(_ game: Game) {
        yourTurnGames.remove(GameViewModel(game: game))
        view.updateGameList()
    }

    // MARK: - MainMenuViewModelProtocol

    func loadItems() {
        guard let currentPlayer = session.me else {
            fatalError("Tried to load games but no one is logged in")
        }

        api.getActiveGames() { result in
            switch result {
            case .success(let games):
                for game in games {
                    if game.isCurrentTurn(currentPlayer) {
                        self.yourTurnGames.append(GameViewModel(game: game))
                    } else if game.isWaitingForAnotherPlayer(currentPlayer) {
                        self.waitingGames.append(GameViewModel(game: game))
                    }
                }
                break
            case .failure(let err): self.view.showServerError(err)
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
        appLayer.createLobby()
        router.showNewMonsterScreen()
    }

    func selectGame(_ index: Int) {
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

    fileprivate var newGameObserver: NSObjectProtocol?
    fileprivate var turnCompleteObserver: NSObjectProtocol?
    fileprivate var gameOverObserver: NSObjectProtocol?

    func startListening() {
        let center = NotificationCenter.default
        newGameObserver = center.addObserver(forName: NSNotification.Name(rawValue: "NewGameStarted"), object: nil, queue: nil) { [weak self] n in self?.newGameStarted(n) }
        turnCompleteObserver = center.addObserver(forName: NSNotification.Name(rawValue: "TurnComplete"), object: nil, queue: nil)  { [weak self] n in self?.turnComplete(n) }
        gameOverObserver = center.addObserver(forName: NSNotification.Name(rawValue: "GameOver"), object: nil, queue: nil)  { [weak self] n in self?.gameOver(n) }
    }

    func stopListening() {
        if newGameObserver != nil {
            NotificationCenter.default.removeObserver(newGameObserver!)
        }
        if turnCompleteObserver != nil {
            NotificationCenter.default.removeObserver(turnCompleteObserver!)
        }
        if gameOverObserver != nil {
            NotificationCenter.default.removeObserver(gameOverObserver!)
        }
    }

    func newGameStarted(_ notification: Foundation.Notification) {
        guard let userInfo = (notification as NSNotification).userInfo, let wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        viewModel?.newGameStarted(wrapper.wrappedValue)
    }

    func turnComplete(_ notification: Foundation.Notification) {
        guard let userInfo = (notification as NSNotification).userInfo, let wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        viewModel?.turnComplete(wrapper.wrappedValue)
    }

    func gameOver(_ notification: Foundation.Notification) {
        guard let userInfo = (notification as NSNotification).userInfo, let wrapper = userInfo["game"] as? Wrapper<Game> else {
            fatalError("Missing game in message");
        }

        viewModel?.gameOver(wrapper.wrappedValue)
    }
}
