//
//  Game.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Foundation
import ObjectMapper

struct Game: Mappable, Equatable {
    var id: String?
    var gameOver: Bool = false
    var players: [Player] = []
    var thumbnail: Data?
    var name: String?
    var lastTurn: Date?
    var currentPlayerNumber: Int = 0
    
    var currentPlayerName: String {
        return currentPlayer.displayName ?? ""
    }
    
    var currentPlayer: Player {
        print("Get current player: \(currentPlayerNumber) from \(players)")
        return players[currentPlayerNumber]
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        gameOver <- map["gameOver"]
        players <- map["players"]
        thumbnail <- (map["thumbnail"], Base64Transform())
        name <- map["name"]
        currentPlayerNumber <- map["currentPlayerNumber"]
        lastTurn <- (map["lastTurn"], DateTransform(dateFormat: "yyyy-MM-dd"))
    }
    
    func isCurrentTurn(_ player: Player) -> Bool {
        return currentPlayer.id == player.id
    }
    
    func isWaitingForAnotherPlayer(_ player: Player) -> Bool {
        return currentPlayer.id != player.id
    }
    
    func friendlyLastTurnText() -> String {
        if lastTurn != nil {
            return DateService().getPrettyDiff(lastTurn!, date2: Date()) + " ago"
        } else {
            return ""
        }
    }
}

func ==(lhs: Game, rhs: Game) -> Bool {
    return lhs.id == rhs.id
}
