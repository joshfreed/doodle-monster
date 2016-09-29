//
//  DrawingViewModelTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 3/26/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class DrawingViewModelTests: XCTestCase {
    var sut: DrawingViewModel!
    var view: DrawingViewMock!
    var game: Game!
    var api: ApiServiceMock!
    var drawingService: DrawingServiceMock!
    
    override func setUp() {
        super.setUp()
        view = DrawingViewMock()
        game = GameBuilder.aGame().build()
        api = ApiServiceMock()
        drawingService = DrawingServiceMock()
        sut = DrawingViewModel(view: view, game: game, api: api)
        sut.drawingService = drawingService
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCancellingADrawingWithNoChangesGoesToTheMainMenu() {
        sut.cancelDrawing()
        XCTAssertTrue(view.calledGoToMainMenu)
    }
    
    func testCancellingADrawingWithChangesShowsAConfirmationDialog() {
        drawingService.wasChanged = true
        sut.cancelDrawing()
        XCTAssertTrue(view.calledShowCancelConfirmation)
    }
}
