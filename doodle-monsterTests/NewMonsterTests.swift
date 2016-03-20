//
//  NewMonsterTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/30/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster
/*
class NewMonsterTests: XCTestCase {
    let vm = NewMonsterViewModel()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingAPlayerAppendsThePlayerToTheList() {
        let player = PlayerViewModel(player: Player(email: "player@test.com", displayName: "Test Player"))
        vm.addPlayer(player)
        XCTAssertEqual(1, vm.players.count)
    }
    
    func testAddingAPlayerCallsTheCallback() {
        var calledPlayerWasAdded = false
        vm.playerWasAdded = { vm in
            calledPlayerWasAdded = true
        }
        
        vm.addPlayer(PlayerViewModel(player: Player(email: "player@test.com", displayName: "Test Player")))
        
        XCTAssertTrue(calledPlayerWasAdded)
    }

    func testDoesNotAddTheSamePlayerMoreThanOnce() {
        let player = PlayerViewModel(player: Player(email: "player@test.com", displayName: "Test Player"))

        vm.addPlayer(player)
        vm.addPlayer(player)
        
        XCTAssertEqual(1, vm.players.count)
    }
    
    func testRemovePlayerRemovesThePlayerFromTheList() {
        let player = PlayerViewModel(player: Player(email: "player@test.com", displayName: "Test Player"))
        vm.addPlayer(player)
        
        vm.removePlayer(player)
        
        XCTAssertEqual(0, vm.players.count)
    }
    
    func testRemovePlayerCallsTheCallback() {
        var calledPlayerWasRemoved = false
        vm.playerWasRemoved = { vm in calledPlayerWasRemoved = true }
        let player = PlayerViewModel(player: Player(email: "player@test.com", displayName: "Test Player"))
        vm.addPlayer(player)
        
        vm.removePlayer(player)
        
        XCTAssertTrue(calledPlayerWasRemoved)
    }
    
    func testRemovePlayerCanRemoveAnArbitraryPlayer() {
        var removed: PlayerViewModel?
        vm.playerWasRemoved = { vm in
            removed = vm
        }
        let player1 = PlayerViewModel(player: Player(email: "player1@test.com", displayName: "Test Player1"))
        let player2 = PlayerViewModel(player: Player(email: "player2@test.com", displayName: "Test Player2"))
        let player3 = PlayerViewModel(player: Player(email: "player3@test.com", displayName: "Test Player3"))
        vm.addPlayer(player1)
        vm.addPlayer(player2)
        vm.addPlayer(player3)
        
        vm.removePlayer(player2)
        
        XCTAssertEqual(2, vm.players.count)
        XCTAssertFalse(vm.players.contains({ (p) -> Bool in return p.isEqualTo(player2) }))
        if let removed = removed {
            XCTAssertTrue(player2.isEqualTo(removed))
        } else {
            XCTFail("Nothing was removed")
        }
    }
}
*/
