//
//  MainMenuTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/10/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest

class GameTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["TESTING"]
        app.launchEnvironment["CURRENT_USER"] = "11111"
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_StartingANewGame() {
        let app = XCUIApplication()
        
        app.collectionViews.buttons["New Monster"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["email button"].tap()
        app.textFields["SearchText"].typeText("jerry")
        app.tables.staticTexts["jerry@bleepsmazz.com"].tap()
        elementsQuery.buttons["Start!"].tap()
        
        let scrollView = app.scrollViews["drawingScrollView"]
        let exists = NSPredicate(format: "exists == 1")
        expectationForPredicate(exists, evaluatedWithObject: scrollView, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        app.buttons["cancel drawing"].tap()
        
        let monsterCollection = app.collectionViews["monsterCollection"]
        XCTAssert(monsterCollection.exists)
        XCTAssertEqual(1, monsterCollection.cells.count)
        
//        XCTAssertTrue(app.collectionViews["monsterCollection"].cells.otherElements.containingType(.StaticText, identifier:"").element.hittable)
    }
    
    func test_StartingANewGameAndTakingTheFirstTurn() {
        let app = XCUIApplication()

        app.collectionViews.buttons["New Monster"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["email button"].tap()
        app.textFields["SearchText"].typeText("jerry")
        app.tables.staticTexts["jerry@bleepsmazz.com"].tap()
        elementsQuery.buttons["Start!"].tap()
        
        let scrollView = app.scrollViews["drawingScrollView"]
        let exists = NSPredicate(format: "exists == 1")
        expectationForPredicate(exists, evaluatedWithObject: scrollView, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
        let imageContainer = app.otherElements["ImageContainer"]
        
        let start = imageContainer.coordinateWithNormalizedOffset(CGVector(dx: 0, dy: 0))
        let end = imageContainer.coordinateWithNormalizedOffset(CGVector(dx: 1, dy: 1))
        start.pressForDuration(0, thenDragToCoordinate: end)
        
        app.buttons["saveDrawing"].tap()
        
        let letterTextField = app.textFields["letter"]
        letterTextField.typeText("Q")
        
        app.buttons["saveTurn"].tap()

        XCTAssert(app.buttons["Sign Out"].exists)
        
        let monsterCollection = app.collectionViews["monsterCollection"]
        XCTAssert(monsterCollection.exists)
        XCTAssertEqual(1, monsterCollection.cells.count)
        
        let cell = monsterCollection.cells.elementBoundByIndex(0)
        XCTAssertEqual("Q", cell.staticTexts["monsterName"].label)

        // Game shows updated thumbnail. -- HOW DOES I TEST THIS?
        // Game is moved to "Waiting".
    }
}
