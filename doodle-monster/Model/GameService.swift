//
//  GameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/2/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import Parse

protocol GameService {
    func createGame(players: [Player])
    func getActiveGames(callback: ([Game]) -> ())
}

class ParseGameService: GameService {
    func createGame(players: [Player]) {
        let newGame = PFObject(className: "Game")
        newGame["gameOver"] = false
        newGame["currentPlayer"] = players.first
        let relation = newGame.relationForKey("players")
        for player in players {
            relation.addObject(player)
        }
        newGame.saveInBackground()
    }

    func getActiveGames(callback: ([Game] -> ())) {
        let query = PFQuery(className: "Game")
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
