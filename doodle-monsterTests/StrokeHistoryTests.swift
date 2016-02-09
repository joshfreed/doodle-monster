//
//  StrokeHistoryTests.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/13/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import XCTest
@testable import doodle_monster

class StrokeHistoryTests: XCTestCase {
    let canvas = TestCanvas()
    var sut: StrokeHistory!
    
    override func setUp() {
        super.setUp()
        sut = StrokeHistory(canvas: canvas, undoLimit: 3)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddOneStroke() {
        let stroke = TestStroke(id: 1)
        
        sut.addStroke(stroke)
        
        XCTAssertEqual(1, sut.strokes.count)
    }
    
    func testAddMoreStrokesThanCanBeUnDone() {
        let stroke1 = TestStroke(id: 1)
        let stroke2 = TestStroke(id: 2)
        let stroke3 = TestStroke(id: 3)
        let stroke4 = TestStroke(id: 4)
        let stroke5 = TestStroke(id: 5)
        
        sut.addStroke(stroke1)
        sut.addStroke(stroke2)
        sut.addStroke(stroke3)
        sut.addStroke(stroke4)
        sut.addStroke(stroke5)
        
        XCTAssertEqual(4, sut.strokes.count)
        XCTAssertEqual(sut.strokes[0] as? TestStroke, stroke2)
        XCTAssertEqual(sut.strokes[1] as? TestStroke, stroke3)
        XCTAssertEqual(sut.strokes[2] as? TestStroke, stroke4)
        XCTAssertEqual(sut.strokes[3] as? TestStroke, stroke5)
    }
    
    func testUndoOneStroke() {
        let stroke1 = TestStroke(id: 1)
        sut.addStroke(stroke1)
        
        sut.undo()
        
        XCTAssertNil(canvas.currentStroke)
    }
    
    func testUndoSomeStrokes() {
        let stroke1 = TestStroke(id: 1)
        let stroke2 = TestStroke(id: 2)
        let stroke3 = TestStroke(id: 3)
        let stroke4 = TestStroke(id: 4)
        let stroke5 = TestStroke(id: 5)
        sut.addStroke(stroke1)
        sut.addStroke(stroke2)
        sut.addStroke(stroke3)
        sut.addStroke(stroke4)
        sut.addStroke(stroke5)
        
        sut.undo()
        sut.undo()
        
        XCTAssertEqual(canvas.currentStroke as? TestStroke, stroke3)
    }
    
    func testUndoStrokesUpToLimit() {
        let stroke1 = TestStroke(id: 1)
        let stroke2 = TestStroke(id: 2)
        let stroke3 = TestStroke(id: 3)
        let stroke4 = TestStroke(id: 4)
        let stroke5 = TestStroke(id: 5)
        sut.addStroke(stroke1)
        sut.addStroke(stroke2)
        sut.addStroke(stroke3)
        sut.addStroke(stroke4)
        sut.addStroke(stroke5)
        
        sut.undo()
        sut.undo()
        sut.undo()
        sut.undo()
        sut.undo()
        
        XCTAssertEqual(canvas.currentStroke as? TestStroke, stroke2)
    }
    
    func testRedoOneStroke() {
        let stroke1 = TestStroke(id: 1)
        
        sut.addStroke(stroke1)
        sut.undo()
        sut.redo()
        
        XCTAssertEqual(canvas.currentStroke as? TestStroke, stroke1)
    }
    
    func testRedoMoreStrokesThanWereUndone() {
        let stroke1 = TestStroke(id: 1)
        let stroke2 = TestStroke(id: 2)
        let stroke3 = TestStroke(id: 3)
        let stroke4 = TestStroke(id: 4)
        let stroke5 = TestStroke(id: 5)
        sut.addStroke(stroke1)
        sut.addStroke(stroke2)
        sut.addStroke(stroke3)
        sut.addStroke(stroke4)
        sut.addStroke(stroke5)
        
        sut.undo()
        sut.undo()
        sut.redo()
        sut.redo()
        sut.redo()
        
        XCTAssertEqual(canvas.currentStroke as? TestStroke, stroke5)
    }
    
    func testUndoAndRedoAndUndoAgain() {
        let stroke1 = TestStroke(id: 1)
        let stroke2 = TestStroke(id: 2)
        let stroke3 = TestStroke(id: 3)
        let stroke4 = TestStroke(id: 4)
        let stroke5 = TestStroke(id: 5)
        sut.addStroke(stroke1)
        sut.addStroke(stroke2)
        sut.addStroke(stroke3)
        sut.addStroke(stroke4)
        sut.addStroke(stroke5)
        
        sut.undo()
        sut.redo()
        sut.undo()
        sut.undo()
        sut.redo()
        sut.undo()
        
        XCTAssertEqual(canvas.currentStroke as? TestStroke, stroke3)
    }
    
    func testAddingMoreStrokesClearsTheRedoHistory() {
        let stroke1 = TestStroke(id: 1)
        let stroke2 = TestStroke(id: 2)
        let stroke3 = TestStroke(id: 3)
        let stroke4 = TestStroke(id: 4)
        sut.addStroke(stroke1)
        sut.addStroke(stroke2)
        sut.addStroke(stroke3)
        sut.undo()
        sut.undo()
        XCTAssertEqual(sut.unDoneStrokes.count, 2)
        
        sut.addStroke(stroke4)
        XCTAssertEqual(sut.unDoneStrokes.count, 0)
    }
}

class TestStroke: Stroke, Equatable {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var image: UIImage {
        return UIImage()
    }
}

func ==(lhs: TestStroke, rhs: TestStroke) -> Bool {
    return lhs.id == rhs.id
}

class TestCanvas: Canvas {
    var currentStroke: Stroke?
}