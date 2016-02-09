//
//  NewMonsterViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/28/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol NewMonsterRouter {
    func goToNewMonster(game: Game)
}

protocol NewMonsterViewModelProtocol {
    // Properties
    var players: [PlayerViewModelProtocol] { get }
    var currentPlayer: PlayerViewModelProtocol { get }
    var buttonHidden: Bool { get }
    // Changes
    var playerWasAdded: ((PlayerViewModelProtocol) -> ())? { get set }
    var playerWasRemoved: ((PlayerViewModelProtocol) -> ())? { get set }
    var buttonVisibilityChanged: (() -> ())? { get set }

    init(currentPlayer: Player, gameService: GameService, router: NewMonsterRouter)
    func addPlayer(player: Player)
    func removePlayer(player: PlayerViewModelProtocol)
    func startGame()
}

class NewMonsterViewModel: NewMonsterViewModelProtocol {
    // Properties
    var players: [PlayerViewModelProtocol] = []
    var currentPlayer: PlayerViewModelProtocol
    var buttonHidden = true
    private let _currentPlayerModel: Player
    private var _playerModels: [Player] = []
    private let gameService: GameService
    private let router: NewMonsterRouter

    // Changes
    var playerWasAdded: ((PlayerViewModelProtocol) -> ())?
    var playerWasRemoved: ((PlayerViewModelProtocol) -> ())?
    var buttonVisibilityChanged: (() -> ())?

    required init(currentPlayer: Player, gameService: GameService, router: NewMonsterRouter) {
        self._currentPlayerModel = currentPlayer
        self.currentPlayer = PlayerViewModel(player: currentPlayer)
        self.gameService = gameService
        self.router = router
        _playerModels.append(self._currentPlayerModel)
    }

    func removePlayer(player: PlayerViewModelProtocol) {
        guard let index = players.indexOf({ (p) -> Bool in return p.isEqualTo(player) }) else {
            return
        }

        players.removeAtIndex(index)
        self.playerWasRemoved?(player)
        validateGame()
    }
    
    func addPlayer(player: Player) {
        guard !_playerModels.contains(player) else {
            return
        }

        _playerModels.append(player)
        let playerVm = PlayerViewModel(player: player)
        players.append(playerVm)
        self.playerWasAdded?(playerVm)
        validateGame()
    }

    func validateGame() {
        if players.count > 0 {
            buttonHidden = false
        } else {
            buttonHidden = true
        }

        buttonVisibilityChanged?()
    }

    func startGame() {
        gameService.createGame(_playerModels) { result in
            switch result {
            case .Success(let newGame):
                let wrappedGame = Wrapper<Game>(theValue: newGame)
                NSNotificationCenter.defaultCenter().postNotificationName("NewGameStarted", object: nil, userInfo: ["game": wrappedGame])
                self.router.goToNewMonster(newGame)
            case .Failure(let error):
                print("Game failed to start \(error)")
                break
            }
        }
    }
}

protocol PlayerViewModelProtocol {
    var email: String { get }
    var displayName: String { get }

    init(player: Player)
    func isEqualTo(other: PlayerViewModelProtocol) -> Bool
}

struct PlayerViewModel: PlayerViewModelProtocol {
    var email: String {
        if let un = player.username {
            return un
        } else {
            return ""
        }
    }
    var displayName: String {
        return player.displayName ?? ""
    }

    private let player: Player
    
    init(player: Player) {
        self.player = player
    }

    func isEqualTo(other: PlayerViewModelProtocol) -> Bool {
        return self.displayName == other.displayName && self.email == other.email
    }
}


