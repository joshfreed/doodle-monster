//
// Created by Josh Freed on 2/14/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class InviteByEmailViewModelTests: XCTestCase {
    var vm: InviteByEmailViewModel!
    var view: InviteByEmailViewMock!
    var api: ApiServiceMock!
    var session: SessionMock!
    var app: DoodleMonsterMock!

    override func setUp() {
        super.setUp()

        view = InviteByEmailViewMock()
        api = ApiServiceMock()
        api.nextResult = SearchResult.success([])
        session = SessionMock()
        app = DoodleMonsterMock()
        vm = InviteByEmailViewModel(view: view, api: api, session: session, applicationLayer: app)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_search_callsPlayerServiceSearchWithTheSearchString() {
        vm.search("hamburgers")
        XCTAssertEqual("hamburgers", api.lastSearchedFor)
    }
    
    func test_search_translatesPlayersToViewModels() {
        let searchResults = [
            PlayerBuilder.aPlayer().withName("Gabby Joe").build(),
            PlayerBuilder.aPlayer().withName("Jimmy Jack").build(),
            PlayerBuilder.aPlayer().withName("Freddy Johns").build(),
        ]
        api.nextResult = SearchResult.success(searchResults)

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
        api.nextResult = SearchResult.success(searchResults)
        session.me = searchResults[1];
        
        vm.search("whatever");
        
        XCTAssertEqual(2, vm.players.count)
        XCTAssertFalse(vm.players.contains(PlayerViewModel(player: searchResults[1])))
    }
    
    func test_search_updatesTheViewOnSuccess() {
        vm.search("whatever")
        XCTAssertTrue(view.calledDisplayedSearchResults);
    }
    
    func test_search_error_updatesTheViewAfterAnError() {
        api.nextResult = SearchResult.error
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
        api.players = players
        
        vm.selectPlayer(IndexPath(row: 2, section: 0))
       
        XCTAssertEqual(players[2], app.lastPlayerAdded)
    }
    
    func test_selectPlayer_doesNothingWhenGivenAnInvalidIndex() {
        let players = [
            PlayerBuilder.aPlayer().withName("Gabby Joe").build(),
            PlayerBuilder.aPlayer().withName("Jimmy Jack").build(),
            PlayerBuilder.aPlayer().withName("Freddy Johns").build(),
        ]
        vm.setPlayers(players)
        api.players = players
        
        vm.selectPlayer(IndexPath(row: 90, section: 0))
        
        XCTAssertNil(app.lastPlayerAdded)
    }
}
