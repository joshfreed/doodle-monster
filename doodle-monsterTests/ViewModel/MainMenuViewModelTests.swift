//
//  MainMenuViewModelTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class MainMenuViewModelTests: XCTestCase {
    var vm: MainMenuViewModel!
    var view: MainMenuViewStub!
    var gameService: GameServiceMock!
    var session: SessionMock!
    var router: MainMenuRouterStub!

    override func setUp() {
        super.setUp()
        view = MainMenuViewStub()
        gameService = GameServiceMock()
        session = SessionMock()
        router = MainMenuRouterStub()
        vm = MainMenuViewModel(view: view, gameService: gameService, session: session, router: router)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_LoadItems_LoadsActiveGamesAndDistributesBetweenYourTurnAndWaiting() {
        let player1 = PlayerBuilder.aPlayer()
        let player2 = PlayerBuilder.aPlayer().withId("BBB")
        let player3 = PlayerBuilder.aPlayer()
        let player4 = PlayerBuilder.aPlayer()
        let game1 = GameBuilder.aGame().withPlayers([player1, player2]).build()
        let game2 = GameBuilder.aGame().withPlayers([player2, player3]).build()
        let game3 = GameBuilder.aGame().withPlayers([player3, player4]).build()
        gameService.setActiveGames([game1, game2, game3])
        session.currentPlayer = player2.build()

        let expectedVm1 = GameViewModel(game: game1)
        let expectedVm2 = GameViewModel(game: game2)
        let expectedVm3 = GameViewModel(game: game3)

        vm.loadItems()

        XCTAssertEqual(1, vm.yourTurnGames.count)
        XCTAssertEqual(2, vm.waitingGames.count)
        XCTAssertEqual(expectedVm2, vm.yourTurnGames[0])
        XCTAssertEqual(expectedVm1, vm.waitingGames[0])
        XCTAssertEqual(expectedVm3, vm.waitingGames[1])
        XCTAssertTrue(view.recorder.received("updateGameList", withArguments: [:], atIndex: 0), "updateGameList was not called on the view")
    }




    private func aPlayer(id: String) -> Player {
        var player = Player()
        player.id = id
        return player
    }

    private func aGame(id: String) -> Game {
        var game = Game()
        game.id = id
        return game
    }
}

class StubRecorder {
    var calls: [FunctionCall] = []

    func recordCall(name: String, arguments: [String: Any]) {
        calls.append(FunctionCall(name: name, arguments: arguments))
    }

    func received(function: String, withArguments args: [String: Any], atIndex index: Int) -> Bool{
        guard index < calls.count else {
            return false
        }

        let call = calls[index]

        if call.name != function {
            return false
        }

//        if call.arguments != args {
//            return false
//        }

        return true
    }
}

class FunctionCall {
    let name: String
    let arguments: [String: Any]

    init(name: String, arguments: [String: Any]) {
        self.name = name
        self.arguments = arguments
    }
}

class MainMenuViewStub: MainMenuView {
    let recorder = StubRecorder()

    func updateGameList() {
        recorder.recordCall("updateGameList", arguments: [:])
    }
}

class GameServiceMock: GameService {
    let recorder = StubRecorder()
    var activeGames: [Game] = []

    func setActiveGames(games: [Game]) {
        activeGames = games
    }

    // MARK: GameService

    func createGame(players: [Player], callback: (Result<Game>) -> ()) {
        recorder.recordCall("createGame", arguments: ["players": players])
        callback(.Success(Game()))
    }

    func getActiveGames(callback: ([Game]) -> ()) {
        callback(activeGames)
    }

    func saveTurn(gameId: String, image: NSData, letter: String, completion: (Result<Game>) -> ()) {

    }
}

class SessionMock: SessionService {
    var currentPlayer: Player?

    func hasSession() -> Bool {
        return false
    }

    func tryToLogIn(username: String, password: String, callback: (result: LoginResult) -> ()) {
        
    }

    func logout() {

    }
    
    func resume() {
        
    }
}

class MainMenuRouterStub: MainMenuRouter {
    func showNewMonsterScreen() {

    }

    func showDrawingScreen(game: Game) {

    }

    func showLoginScreen() {

    }
}

protocol Builder {
    typealias Entity
    func build() -> Entity
}

extension Builder {
    func generateId() -> String {
        return randomStringWithLength(6) as! String
    }

    func randomStringWithLength(len: Int) -> NSString {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var randomString: NSMutableString = NSMutableString(capacity: len)

        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }

        return randomString
    }
}

class GameBuilder: Builder {
    var gameId: String?
    var playerBuilders: [PlayerBuilder] = []

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
}

class PlayerBuilder: Builder {
    var playerId: String?

    static func aPlayer() -> PlayerBuilder {
        return PlayerBuilder()
    }

    func build() -> Player {
        var player = Player()
        player.id = playerId ?? generateId()
        return player
    }

    func withId(_ id: String) -> PlayerBuilder {
        playerId = id
        return self
    }
}