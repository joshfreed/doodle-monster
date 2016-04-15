//
//  DrawingServiceTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 3/26/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class DrawingServiceTests: XCTestCase {
    var sut: DrawingService!
    var cgService: GraphicsContextMock!
    var strokeHistory: StrokeHistoryMock!
    
    override func setUp() {
        super.setUp()
        cgService = GraphicsContextMock()
        strokeHistory = StrokeHistoryMock()
        sut = DrawingService(uiDrawingService: cgService, strokeHistory: strokeHistory)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasMadeChanges_returnsFalseIfNoChanges() {
        XCTAssertFalse(sut.hasMadeChanges())
    }
    
    func testHasMadeChanges_returnsTrueIfChanges() {
        strokeHistory.addStroke(FakeStroke())
        XCTAssertTrue(sut.hasMadeChanges())
    }
}
