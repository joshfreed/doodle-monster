//
//  ParseGameService.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

class ParseGameService: GameService {
    let parsePlayerService: ParseUserService
    let playerTranslator = ParsePlayerTranslator()
    let gameTranslator = ParseGameTranslator()
    var parseObjects: [PFObject] = []

    init(parsePlayerService: ParseUserService) {
        self.parsePlayerService = parsePlayerService
    }

    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        let newGame = PFObject(className: "Game")
        
        var parsePlayers: [PFObject] = []
        for player in players {
            guard let obj = parsePlayerService.objectFor(player) else {
                fatalError("Tried to use a player not loaded from the server")
            }
            parsePlayers.append(obj)
        }
        newGame["players"] = parsePlayers
        
        newGame.saveInBackgroundWithBlock { result, error in
            guard error == nil else {
                return callback(.Failure(error!))
            }
            
            print("RESULT: \(result)")

            callback(.Success(self.gameTranslator.parseToModel(newGame)))
        }
    }
    
    func getActiveGames(callback: (Result<[Game]> -> ())) {
        let query = PFQuery(className: "Game")
        query.includeKey("players")
        query.whereKey("gameOver", equalTo: false)
        query.findObjectsInBackgroundWithBlock() { objects, error in
            guard error == nil else {
                return
            }

            var games: [Game] = []
            for object in objects! {
                self.parseObjects.append(object)
                games.append(self.gameTranslator.parseToModel(object))
            }
            callback(.Success(games))
        }
    }
    
    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ()) {
        let params = [
            "gameId": gameId,
            "monsterImage": image.base64EncodedStringWithOptions(.Encoding64CharacterLineLength),
            "letter": letter
        ]
        
        PFCloud.callFunctionInBackground("saveTurn", withParameters: params) { response, error in
            print("RESPONSE \(response) ERROR \(error)")

            guard error == nil else {
                return completion(.Failure(error!))
            }
            guard let object = response as? PFObject else {
                return completion(.Failure(UserError.NoData))
            }

            let game = self.gameTranslator.parseToModel(object)

            completion(.Success(game))
        }
    }
}

class ParseGameTranslator {
    let playerTranslator = ParsePlayerTranslator()

    func parseToModel(obj: PFObject) -> Game {
        var game = Game()
        game.id = obj.objectId
        game.gameOver = obj["gameOver"] as? Bool ?? false
        game.players = playerTranslator.parseArray(obj["players"] as! NSArray)
        game.imageFile = obj["imageFile"] as? PFFile
        game.thumbnail = obj["thumbnail"] as? PFFile
        game.name = obj["name"] as? String
        game.lastTurn = obj["lastTurn"] as? NSDate
        game.currentPlayerNumber = obj["currentPlayerNumber"] as? Int ?? 0
        return game
    }
}

