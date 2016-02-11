//
//  InMemoryServices.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/9/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class MemoryPlayerService: PlayerService {
    var players: [Player] = []
    var nextId = 0
    let session: MemorySessionService
    
    init(session: MemorySessionService) {
        self.session = session
    }
    
    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ()) {
        nextId = nextId + 1
        var player = Player()
        player.id = String(nextId)
        player.username = username
        player.password = password
        player.displayName = displayName
        players.append(player)
        session.currentPlayer = player
        callback(result: .Success)
    }
    
    func search(searchText: String, callback: (result: SearchResult) -> ()) {
        print("Searching for \(searchText)")
        var matches: [Player] = []
        for player in players {
            print("Checking \(player.username)")
            if player.username != nil && player.username!.containsString(searchText) {
                matches.append(player)
            }
        }
        callback(result: .Success(matches))
    }
}

class MemoryGameService: GameService {
    var games: [Game] = []
    let session: MemorySessionService
    var nextId = 0
    
    init(session: MemorySessionService) {
        self.session = session
    }
    
    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        nextId = nextId + 1
        var game = Game()
        game.id = String(nextId)
        game.name = ""
        game.players = players
        games.append(game)
        callback(.Success(game))
    }
    
    func getActiveGames(callback: ([Game]) -> ()) {
        callback(games)
    }
    
    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ()) {
        var game = getGame(gameId)
        if game != nil {
            game!.name = (game!.name ?? "") + letter
            return completion(.Success(game!))
        }
        
        completion(.Failure(NSError(domain: "Game not found", code: 0, userInfo: nil)))
    }
    
    func getGame(gameId: String) -> Game? {
        for game in games {
            if game.id == gameId {
                return game
            }
        }
        
        return nil
    }
}

class MemorySessionService: SessionService {
    var currentPlayer: Player?
    var playerService: MemoryPlayerService!
    
    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ()) {
        var foundPlayer = false
        for player in playerService.players {
            if player.username == username {
                foundPlayer = true
                break
            }
        }
        if !foundPlayer {
            return callback(result: .NoSuchUser)
        }
        
        for player in playerService.players {
            if player.username == username && player.password == password {
                currentPlayer = player
                return callback(result: .Success)
            }
        }
        
        callback(result: .Error)
    }
    
    func hasSession() -> Bool {
        return currentPlayer != nil
    }
    
    func logout() {
        currentPlayer = nil
    }
    
    func resume() {
        
    }
}
