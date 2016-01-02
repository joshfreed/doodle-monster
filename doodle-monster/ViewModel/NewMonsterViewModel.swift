//
//  NewMonsterViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/28/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol NewMonsterViewModelProtocol {
    // Properties
    var players: [PlayerViewModelProtocol] { get }
    var currentPlayer: PlayerViewModelProtocol { get }
    var buttonHidden: Bool { get }
    // Changes
    var playerWasAdded: ((PlayerViewModelProtocol) -> ())? { get set }
    var playerWasRemoved: ((PlayerViewModelProtocol) -> ())? { get set }
    var buttonVisibilityChanged: (() -> ())? { get set }

    init(currentPlayer: Player)
    func addPlayer(player: PlayerViewModelProtocol)
    func removePlayer(player: PlayerViewModelProtocol)
}

class NewMonsterViewModel: NewMonsterViewModelProtocol {
    // Properties
    var players: [PlayerViewModelProtocol] = []
    var currentPlayer: PlayerViewModelProtocol
    var buttonHidden = true
    private let _currentPlayerModel: Player

    // Changes
    var playerWasAdded: ((PlayerViewModelProtocol) -> ())?
    var playerWasRemoved: ((PlayerViewModelProtocol) -> ())?
    var buttonVisibilityChanged: (() -> ())?

    required init(currentPlayer: Player) {
        self._currentPlayerModel = currentPlayer
        self.currentPlayer = PlayerViewModel(player: currentPlayer)
    }

    func removePlayer(player: PlayerViewModelProtocol) {
        guard let index = players.indexOf({ (p) -> Bool in return p.isEqualTo(player) }) else {
            return
        }

        players.removeAtIndex(index)
        self.playerWasRemoved?(player)
        validateGame()
    }
    
    func addPlayer(player: PlayerViewModelProtocol) {
        guard !players.contains({ (p) -> Bool in return p.isEqualTo(player) }) else {
            return
        }
        
        players.append(player)
        self.playerWasAdded?(player)
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
}

protocol PlayerViewModelProtocol {
    var email: String { get }
    var displayName: String { get }

    init(player: Player)
    func isEqualTo(other: PlayerViewModelProtocol) -> Bool
}

struct PlayerViewModel: PlayerViewModelProtocol {
    var email: String {
        return player.email
    }
    var displayName: String {
        return player.displayName
    }

    private let player: Player
    
    init(player: Player) {
        self.player = player
    }

    func isEqualTo(other: PlayerViewModelProtocol) -> Bool {
        return self.displayName == other.displayName && self.email == other.email
    }
}


