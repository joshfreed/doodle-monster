//
// Created by Josh Freed on 2/14/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class InviteByEmailViewModelTests: XCTestCase {
    var vm: InviteByEmailViewModel!
    var view: InviteByEmailViewMock!
    var playerService: PlayerServiceMock!
    var session: SessionMock!
    var app: DoodleMonsterMock!

    override func setUp() {
        super.setUp()

        view = InviteByEmailViewMock()
        playerService = PlayerServiceMock()
        playerService.nextResult = SearchResult.Success([])
        session = SessionMock()
        app = DoodleMonsterMock()
        vm = InviteByEmailViewModel(view: view, playerService: playerService, session: session, applicationLayer: app)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_search_callsPlayerServiceSearchWithTheSearchString() {
        vm.search("hamburgers")
        XCTAssertEqual("hamburgers", playerService.lastSearchedFor)
    }
    
    func test_search_translatesPlayersToViewModels() {
        let searchResults = [
            PlayerBuilder.aPlayer().withName("Gabby Joe").build(),
            PlayerBuilder.aPlayer().withName("Jimmy Jack").build(),
            PlayerBuilder.aPlayer().withName("Freddy Johns").build(),
        ]
        playerService.nextResult = SearchResult.Success(searchResults)

        vm.search("anything")

        XCTAssertEqual(3, vm.players.count)
        XCTAssertTrue(vm.players.contains(PlayerViewModel(player: searchResults[0])))
        XCTAssertTrue(vm.players.contains(PlayerViewModel(player: searchResults[1])))
        XCTAssertTrue(vm.players.contains(PlayerViewModel(player: searchResults[2])))
    }
    
    func test_search_excludesTheCurrentPlayerFromTheResults() {
        let searchResults = [
            PlayerBuilder.aPlayer().withName("Gabby Joe").build(),
            PlayerBuilder.aPlayer().withName("Jimmy Jack").build(),
            PlayerBuilder.aPlayer().withName("Freddy Johns").build(),
        ]
        playerService.nextResult = SearchResult.Success(searchResults)
        session.currentPlayer = searchResults[1];
        
        vm.search("whatever");
        
        XCTAssertEqual(2, vm.players.count)
        XCTAssertFalse(vm.players.contains(PlayerViewModel(player: searchResults[1])))
    }
    
    func test_search_updatesTheViewOnSuccess() {
        vm.search("whatever")
        XCTAssertTrue(view.calledDisplayedSearchResults);
    }
    
    func test_search_error_updatesTheViewAfterAnError() {
        playerService.nextResult = SearchResult.Error
        vm.search("anything")
        XCTAssertTrue(view.calledSearchError);
    }
    
    func test_selectPlayer_selectsThePlayerAtTheGivenIndex() {
        let players = [
            PlayerBuilder.aPlayer().withName("Gabby Joe").build(),
            PlayerBuilder.aPlayer().withName("Jimmy Jack").build(),
            PlayerBuilder.aPlayer().withName("Freddy Johns").build(),
        ]
        vm.setPlayers(players)
        playerService.players = players
        
        vm.selectPlayer(NSIndexPath(forRow: 2, inSection: 0))
       
        XCTAssertEqual(players[2], app.lastPlayerAdded)
    }
    
    func test_selectPlayer_doesNothingWhenGivenAnInvalidIndex() {
        let players = [
            PlayerBuilder.aPlayer().withName("Gabby Joe").build(),
            PlayerBuilder.aPlayer().withName("Jimmy Jack").build(),
            PlayerBuilder.aPlayer().withName("Freddy Johns").build(),
        ]
        vm.setPlayers(players)
        playerService.players = players
        
        vm.selectPlayer(NSIndexPath(forRow: 90, inSection: 0))
        
        XCTAssertNil(app.lastPlayerAdded)
    }
}