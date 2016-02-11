//
// Created by Josh Freed on 2/11/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit
@testable import doodle_monster

class MainMenuViewMock: MainMenuView {
    var gameListWasUpdated = false

    func updateGameList() {
        gameListWasUpdated = true
    }
}

class GameServiceMock: GameService {
    var activeGames: [Game] = []

    func setActiveGames(games: [Game]) {
        activeGames = games
    }

    // MARK: GameService

    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        callback(.Success(GameBuilder.aGame().withPlayers(players).build()))
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