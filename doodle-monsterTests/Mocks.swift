//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
import EmitterKit
@testable import doodle_monster

class MainMenuViewMock: MainMenuView {
    var gameListWasUpdated = false

    func updateGameList() {
        gameListWasUpdated = true
    }
}

class InviteByEmailViewMock: InviteByEmailView {
    var calledDisplayedSearchResults = false
    var calledSearchError = false
    
    func displaySearchResults() {
        calledDisplayedSearchResults = true
    }
    
    func displaySearchError() {
        calledSearchError = true
    }
}

class GameServiceMock: GameService {
    var activeGames: [Game] = []
    var createGameResult: Result<Game>?
    var calledCreateGame = false

    func setActiveGames(games: [Game]) {
        activeGames = games
    }

    // MARK: GameService

    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        calledCreateGame = true
        guard let result = createGameResult else {
            return
        }
        callback(result);
    }

    func getActiveGames(callback: ([Game]) -> ()) {
        callback(activeGames)
    }

    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ()) {

    }
}

class SessionMock: SessionService {
    var currentPlayer: Player?
    var loggedOut = false

    func hasSession() -> Bool {
        return false
    }

    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ()) {

    }

    func logout() {
        loggedOut = true
    }

    func resume() {

    }
}

class MainMenuRouterMock: MainMenuRouter {
    var showedLoginScreen = false
    var showedNewMonsterScreen = false
    var showedGame: Game?

    func showNewMonsterScreen() {
        showedNewMonsterScreen = true
    }

    func showDrawingScreen(game: Game) {
        showedGame = game
    }

    func showLoginScreen() {
        showedLoginScreen = true
    }
}

class MainMenuViewModelListenerMock: MainMenuViewModelListener {
    override func startListening() {

    }

    override func stopListening() {

    }
}

class PlayerServiceMock: PlayerService {
    var lastSearchedFor: String?
    var nextResult: SearchResult?
    var players: [Player] = []

    func createUser(username: String, password: String, displayName: String, callback: (result: CreateUserResult) -> ()) {

    }

    func search(searchText: String, callback: (result: SearchResult) -> ()) {
        lastSearchedFor = searchText
        callback(result: nextResult!)
    }

    func playerBy(id: String) -> Player? {
        for player in players {
            if player.id == id {
                return player
            }
        }
        
        return nil
    }
}

class DoodleMonsterMock: DoodleMonster {
    var lastPlayerAdded: Player?
    
    // MARK:  Actions
    
    func createLobby() {
        
    }
    
    func cancelLobby() {
        
    }
    
    func addPlayer(player: Player) {
        lastPlayerAdded = player
    }
    
    func removePlayer(playerId: String) {
        
    }
    
    func startGame() {
        
    }
    
    func canStartGame() -> Bool {
        return false
    }
    
    // MARK: Events
    
    let playerAdded = Event<Player>()
    let playerRemoved = Event<Player>()
    let newGameStarted = Event<Game>()
}