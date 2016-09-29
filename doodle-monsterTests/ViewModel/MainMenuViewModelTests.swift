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
    var view: MainMenuViewMock!
    var api: ApiServiceMock!
    var session: SessionMock!
    var router: MainMenuRouterMock!
    var listener: MainMenuViewModelListenerMock!
    var app: DoodleMonsterMock!

    override func setUp() {
        super.setUp()
        view = MainMenuViewMock()
        api = ApiServiceMock()
        session = SessionMock()
        router = MainMenuRouterMock()
        listener = MainMenuViewModelListenerMock()
        app = DoodleMonsterMock()
        vm = MainMenuViewModel(view: view, api: api, session: session, router: router, listener: listener, applicationLayer: app)
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
        api.setActiveGames([game1, game2, game3])
        session.me = player2.build()

        let expectedVm1 = GameViewModel(game: game1)
        let expectedVm2 = GameViewModel(game: game2)
        let expectedVm3 = GameViewModel(game: game3)

        vm.loadItems()

        XCTAssertEqual(1, vm.yourTurnGames.count)
        XCTAssertEqual(2, vm.waitingGames.count)
        XCTAssertEqual(expectedVm2, vm.yourTurnGames[0])
        XCTAssertEqual(expectedVm1, vm.waitingGames[0])
        XCTAssertEqual(expectedVm3, vm.waitingGames[1])
        XCTAssertTrue(view.gameListWasUpdated)
    }

    func test_newGameStarted_addsGameViewModelToYourTurnCollection() {
        let newGame = GameBuilder.aGame().build()

        vm.newGameStarted(newGame)

        XCTAssertEqual(1, vm.yourTurnGames.count)
        XCTAssertEqual(GameViewModel(game: newGame), vm.yourTurnGames[0])
    }

    func test_newGameStarted_updatesTheView() {
        let newGame = GameBuilder.aGame().build()

        vm.newGameStarted(newGame)

        XCTAssertTrue(view.gameListWasUpdated)
    }

    func test_turnComplete_addsGameViewModelToYourTurnCollection() {
        let game = GameBuilder.aGame().build()
        vm.yourTurnGames.append(GameViewModel(game: game))

        vm.turnComplete(game)

        XCTAssertEqual(0, vm.yourTurnGames.count)
        XCTAssertEqual(1, vm.waitingGames.count)
        XCTAssertEqual(GameViewModel(game: game), vm.waitingGames[0])
    }

    func test_turnComplete_updatesTheView() {
        let game = GameBuilder.aGame().build()
        vm.yourTurnGames.append(GameViewModel(game: game))

        vm.turnComplete(game)

        XCTAssertTrue(view.gameListWasUpdated)
    }

    func test_gameOver_addsGameViewModelToYourTurnCollection() {
        let game = GameBuilder.aGame().build()
        vm.yourTurnGames.append(GameViewModel(game: game))

        vm.gameOver(game)

        XCTAssertEqual(0, vm.yourTurnGames.count)
        XCTAssertEqual(0, vm.waitingGames.count)
    }

    func test_gameOver_updatesTheView() {
        let game = GameBuilder.aGame().build()
        vm.yourTurnGames.append(GameViewModel(game: game))

        vm.gameOver(game)

        XCTAssertTrue(view.gameListWasUpdated)
    }

    func test_signOut_logsOutOfTheSession() {
        vm.signOut()
        XCTAssertTrue(session.loggedOut)
    }

    func test_signOut_routesToTheLoginScreen() {
        vm.signOut()
        XCTAssertTrue(router.showedLoginScreen)
    }

    func test_newMonster_routesToTheNewMonsterScreen() {
        vm.newMonster()
        XCTAssertTrue(router.showedNewMonsterScreen)
    }

    func test_selectGame_routesToTheGameDrawingScreen() {
        let game = GameBuilder.aGame().build()
        vm.yourTurnGames.append(GameViewModel(game: game))

        vm.selectGame(0)

        XCTAssertEqual(game, router.showedGame)
    }
}

