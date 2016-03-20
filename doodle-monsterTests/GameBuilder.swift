//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
@testable import doodle_monster

class GameBuilder: Builder {
    var gameId: String?
    var playerBuilders: [PlayerBuilder] = []
    var players: [Player] = []

    static func aGame() -> GameBuilder {
        return GameBuilder()
    }

    func build() -> Game {
        var game = Game()
        game.id = gameId ?? generateId()
        game.currentPlayerNumber = 0

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

    func withId(id: String) -> GameBuilder {
        gameId = id
        return self
    }

    func withPlayers(players: [PlayerBuilder]) -> GameBuilder {
        playerBuilders = players
        return self
    }

    func withPlayers(players: [Player]) -> GameBuilder {
        self.players = players
        return self
    }
}
