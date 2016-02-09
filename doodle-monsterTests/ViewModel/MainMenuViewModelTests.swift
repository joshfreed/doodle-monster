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
    var player: Player!
    var session: SessionMock!
    var router: MainMenuRouterStub!

    override func setUp() {
        super.setUp()
        view = MainMenuViewStub()
        gameService = GameServiceMock()
        player = aPlayer("BBB")
        session = SessionMock()
        router = MainMenuRouterStub()
        vm = MainMenuViewModel(view: view, gameService: gameService, currentPlayer: player, session: session, router: router)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadItems() {
        var activeModels = [
            aGame("999"),
            aGame("888"),
            aGame("777"),
        ]
        activeModels[0].players = [aPlayer("AAA")]
        activeModels[0].currentPlayerNumber = 0
        activeModels[1].players = [aPlayer("BBB")]
        activeModels[1].currentPlayerNumber = 0
        activeModels[2].players = [aPlayer("CCC")]
        activeModels[2].currentPlayerNumber = 0
        gameService.setActiveGames(activeModels)

        vm.loadItems()

        XCTAssertTrue(view.recorder.received("updateGameList", withArguments: [:], atIndex: 0), "updateGameList was not called on the view")
        XCTAssertEqual(1, vm.yourTurnGames.count, "Unexpected number of yourTurn games")
        XCTAssertEqual(GameViewModel(game: activeModels[1]), vm.yourTurnGames[0])
        XCTAssertEqual(2, vm.waitingGames.count)
        XCTAssertEqual(GameViewModel(game: activeModels[0]), vm.waitingGames[0])
        XCTAssertEqual(GameViewModel(game: activeModels[2]), vm.waitingGames[1])
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
    func hasSession() -> Bool {
        return false
    }

    func currentPlayer() -> Player? {
        return nil
    }

    func logout() {

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