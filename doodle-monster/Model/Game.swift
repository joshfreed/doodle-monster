//
//  Game.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Foundation
import Parse

struct Game: Equatable {
    var id: String?
    var gameOver: Bool = false
    var players: [Player] = []
    var imageFile: PFFile?
    var thumbnail: NSData?
    var name: String?
    var lastTurn: NSDate?
    var currentPlayerNumber: Int = 0
    
    var currentPlayerName: String {
        return currentPlayer.displayName ?? ""
    }
    
    var currentPlayer: Player {
        return players[currentPlayerNumber]
    }
    
    func isCurrentTurn(player: Player) -> Bool {
        return currentPlayer.id == player.id
    }
    
    func isWaitingForAnotherPlayer(player: Player) -> Bool {
        return currentPlayer.id != player.id
    }
    
    func friendlyLastTurnText() -> String {
        if lastTurn != nil {
            return DateService().getPrettyDiff(lastTurn!, date2: NSDate()) + " ago"
        } else {
            return ""
        }
    }
}

func ==(lhs: Game, rhs: Game) -> Bool {
    return lhs.id == rhs.id
}