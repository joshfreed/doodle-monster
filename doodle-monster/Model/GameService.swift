//
//  GameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/2/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

protocol GameService {
    func createGame(players: [Player]) -> Game
    func getActiveGames(callback: ([Game]) -> ())
}

class ParseGameService: GameService {
    func createGame(players: [Player]) -> Game {
        let newGame = Game()
        newGame["players"] = players
        newGame.saveInBackground()
        return newGame
    }

    func getActiveGames(callback: ([Game] -> ())) {
        let query = PFQuery(className: "Game")
        query.includeKey("players")
        query.whereKey("gameOver", equalTo: false)
        query.findObjectsInBackgroundWithBlock() { objects, error in
            guard error == nil else {
                return
            }

            if let objects = objects as? [Game] {
                callback(objects)
            }
        }
    }
}
