//
//  NewMonsterTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 3/1/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class NewMonsterAppTests: XCTestCase {
    var app: DoodleMonsterApp!
    var api: ApiServiceMock!
    var session: SessionMock!
    
    override func setUp() {
        super.setUp()
        
        session = SessionMock()
        api = ApiServiceMock()
        session.me = PlayerBuilder.aPlayer().build()
        app = DoodleMonsterApp(api: api, session: session)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: createLobby
    
    func test_createLobby_addsTheCurrentPlayerToTheLobby() {
        app.createLobby()
        
        XCTAssertEqual(1, app.newGamePlayers.count)
        XCTAssertTrue(app.newGamePlayers.contains(session.me!))
    }
    
    func test_createLobby_doesNothingIfThereIsAlreadyALobbyCreated() {
        app.createLobby()
        app.createLobby() // 2nd one won't initialize things twice
        
        XCTAssertEqual(1, app.newGamePlayers.count)
        XCTAssertTrue(app.newGamePlayers.contains(session.me!))
    }
    
    // MARK: cancelLobby
    
    func test_cancelLobby() {
        app.createLobby()
        
        app.cancelLobby()
        
        XCTAssertEqual([], app.newGamePlayers)
    }
    
    // MARK: addPlayer
    
    func test_addPlayer_addsThePlayerToTheLobby() {
        let player = PlayerBuilder.aPlayer().build()
        app.createLobby()
        
        app.addPlayer(player)
        
        XCTAssertTrue(app.newGamePlayers.contains(player))
    }
    
    func test_addPlayer_doesNotAddTheSamePlayerMoreThanOnce() {
        let player = PlayerBuilder.aPlayer().build()
        app.createLobby()
        
        app.addPlayer(player)
        app.addPlayer(player)
        
        XCTAssertEqual(2, app.newGamePlayers.count) // 2 = current + added player
    }
    
    func test_addPlayer_emitsAnEvent() {
        let player = PlayerBuilder.aPlayer().build()
        let expectation = self.expectation(description: "playerAddedEvent was emitted")
        app.playerAdded.once { p in
            XCTAssertEqual(player, p)
            expectation.fulfill()
        }
        
        app.createLobby()
        app.addPlayer(player)

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: removePlayer
    
    func test_removePlayer_removesThePlayerFromTheLobby() {
        let player = PlayerBuilder.aPlayer().build()
        app.createLobby()
        app.addPlayer(player)
        
        app.removePlayer(player.id!)
        
        XCTAssertFalse(app.newGamePlayers.contains(player))
    }
    
    func test_removePlayer_emitsAnEvent() {
        let player = PlayerBuilder.aPlayer().build()
        let expectation = self.expectation(description: "Event was emitted")
        app.playerRemoved.once { p in
            XCTAssertEqual(player, p)
            expectation.fulfill()
        }
        
        app.createLobby()
        app.addPlayer(player)
        app.removePlayer(player.id!)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_removePlayer_anUnknownPlayerIdDoesNothing() {
        let player = PlayerBuilder.aPlayer().build()
        app.createLobby()
        app.addPlayer(player)
        
        app.removePlayer("abcdefgh")
        
        // still have all the players
        XCTAssertEqual(2, app.newGamePlayers.count)
        XCTAssertTrue(app.newGamePlayers.contains(player))
    }
    
    func test_removePlayer_cannotRemoveTheCurrentPlayer() {
        app.createLobby()
        
        app.removePlayer(session.me!.id!)
        
        XCTAssertTrue(app.newGamePlayers.contains(session.me!))
    }
    
    // MARK: startGame
    
    func test_startGame_usesTheGameServiceToCreateANewGameModel() {
        // SETUP
        app.createLobby()
        app.addPlayer(PlayerBuilder.aPlayer().build())
        
        // EXPECTATIONS
        let theNewGame = GameBuilder.aGame().withPlayers(app.newGamePlayers).build()
        api.createGameResult = .success(theNewGame)
        let expectation = self.expectation(description: "Event was emitted")
        app.newGameStarted.once { g in
            XCTAssertEqual(theNewGame, g)
            expectation.fulfill()
        }

        // SUT
        app.startGame()
        
        // VERIFY
        XCTAssertEqual([], app.newGamePlayers)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_startGame_doesNotStartTheGameIfThereArentEnoughPlayers() {
        app.createLobby()
        app.startGame()
        XCTAssertFalse(api.calledCreateGame)
    }
    
    func test_startGame_wontStartIfThereAreTooManyPlayers() {
        app.createLobby()
        for _ in 1...20 {
            app.addPlayer(PlayerBuilder.aPlayer().build())
        }
        app.startGame()
        XCTAssertFalse(api.calledCreateGame)

    }
    
    // MARK: canStartGame
    
    func test_canStartGame_returnsFalseIfLessThanTwoPlayers() {
        app.createLobby()
        XCTAssertFalse(app.canStartGame())
    }
    
    func test_canStartGame_returnsFalseIfMoreThan12Players() {
        app.createLobby()
        for _ in 1...20 {
            app.addPlayer(PlayerBuilder.aPlayer().build())
        }
        XCTAssertFalse(app.canStartGame())
    }
    
    func test_canStartGame_returnsTrueIfBetweenTwoAndTwelve() {
        app.createLobby()
        for _ in 1...6 {
            app.addPlayer(PlayerBuilder.aPlayer().build())
        }
        XCTAssertTrue(app.canStartGame())
    }
}
