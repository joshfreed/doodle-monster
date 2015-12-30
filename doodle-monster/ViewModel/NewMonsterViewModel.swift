//
//  NewMonsterViewModel.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/28/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

protocol NewMonsterViewModelProtocol {
    var playerWasAdded: ((PlayerViewModelProtocol) -> ())? { get set }
    var playerWasRemoved: ((PlayerViewModelProtocol) -> ())? { get set }
    var players: [PlayerViewModelProtocol] { get }
    
    func addPlayer(player: PlayerViewModelProtocol)
    func removePlayer(player: PlayerViewModelProtocol)
}

class NewMonsterViewModel: NewMonsterViewModelProtocol {
    var playerWasAdded: ((PlayerViewModelProtocol) -> ())?
    var playerWasRemoved: ((PlayerViewModelProtocol) -> ())?
    
    var players: [PlayerViewModelProtocol] = []
    
    func removePlayer(player: PlayerViewModelProtocol) {
        guard let index = players.indexOf({ (p) -> Bool in return p.isEqualTo(player) }) else {
            return
        }
        
        self.playerWasRemoved?(player)
        players.removeAtIndex(index)
    }
    
    func addPlayer(player: PlayerViewModelProtocol) {
        guard !players.contains({ (p) -> Bool in return p.isEqualTo(player) }) else {
            return
        }
        
        players.append(player)
        self.playerWasAdded?(player)
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


