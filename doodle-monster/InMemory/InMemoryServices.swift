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
    
    func createUser(_ username: String, password: String, displayName: String, callback: @escaping (CreateUserResult) -> ()) {
        nextId = nextId + 1
        var player = Player()
        player.id = String(nextId)
        player.username = username
        player.password = password
        player.displayName = displayName
        players.append(player)
        session.currentPlayer = player
        callback(.success)
    }
    
    func search(_ searchText: String, callback: @escaping (SearchResult) -> ()) {
        print("Searching for \(searchText)")
        var matches: [Player] = []
        for player in players {
            print("Checking \(player.username)")
            if player.username != nil && player.username!.contains(searchText) {
                matches.append(player)
            }
        }
        callback(.success(matches))
    }

    func playerBy(_ id: String) -> Player? {
        for player in players {
            if player.id == id {
                return player
            }
        }

        return nil
    }
}

class MemoryGameService: GameService {
    var games: [Game] = []
    let session: MemorySessionService
    var nextId = 0
    
    init(session: MemorySessionService) {
        self.session = session
    }
    
    func createGame(_ players: [Player], callback: @escaping (Result<Game>) -> ()) {
        nextId = nextId + 1
        var game = Game()
        game.id = String(nextId)
        game.name = ""
        game.players = players
        games.append(game)
        callback(.success(game))
    }
    
    func getActiveGames(_ callback: @escaping (Result<[Game]>) -> ()) {
        callback(.success(games))
    }
    
    func saveTurn(_ gameId: String, image: Data, letter: String, completion: @escaping (Result<Game>) -> ()) {
        var game = getGame(gameId)
        if game != nil {
            game!.name = (game!.name ?? "") + letter
            return completion(.success(game!))
        }
        
        completion(.failure(NSError(domain: "Game not found", code: 0, userInfo: nil)))
    }
    
    func getGame(_ gameId: String) -> Game? {
        for game in games {
            if game.id == gameId {
                return game
            }
        }
        
        return nil
    }
    
    func loadImageData(_ gameId: String, completion: @escaping (Result<Data>) -> ()) {
        
    }
}

class MemorySessionService: SessionService {
    var currentPlayer: Player?
    var token: String?
    var playerService: MemoryPlayerService!
    
    func tryToLogIn(_ username: String, password: String, callback: @escaping (LoginResult) -> ()) {
        var foundPlayer = false
        for player in playerService.players {
            if player.username == username {
                foundPlayer = true
                break
            }
        }
        if !foundPlayer {
            return callback(.noSuchUser)
        }
        
        for player in playerService.players {
            if player.username == username && player.password == password {
                currentPlayer = player
                return callback(.success)
            }
        }
        
        callback(.error)
    }
    
    func hasSession() -> Bool {
        return currentPlayer != nil
    }
    
    func logout() {
        currentPlayer = nil
    }
    
    func resume() {
        
    }
    
    func setAuthToken(_ token: String, andPlayer playerDict: NSDictionary) {
        
    }
}
