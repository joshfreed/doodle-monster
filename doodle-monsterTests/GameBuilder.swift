//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
import ObjectMapper
@testable import doodle_monster

class GameBuilder: Builder {
    var gameId: String?
    var playerBuilders: [PlayerBuilder] = []
    var players: [Player] = []

    static func aGame() -> GameBuilder {
        return GameBuilder()
    }

    func build() -> Game {
        var json: [String: Any] = [:]
        json["id"] = gameId ?? generateId()
        json["currentPlayerNumber"] = 0
        
        var game = Mapper<Game>().map(JSON: json)!
        
        var players: [Player] = []
        for builder in playerBuilders {
            players.append(builder.build())
        }
        for player in self.players {
            players.append(player)
        }
        game.players = players
        
        return game
    }

    func withId(_ id: String) -> GameBuilder {
        gameId = id
        return self
    }

    func withPlayers(_ players: [PlayerBuilder]) -> GameBuilder {
        playerBuilders = players
        return self
    }

    func withPlayers(_ players: [Player]) -> GameBuilder {
        self.players = players
        return self
    }
}
