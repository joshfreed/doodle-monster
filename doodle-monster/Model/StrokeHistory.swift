//
//  StrokeHistory.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/13/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol Stroke {
    var image: UIImage { get }
}

protocol Canvas {
    var currentStroke: Stroke? { get set }
}

protocol StrokeHistoryProtocol {
    var strokes: [Stroke] { get }
    
    func addStroke(stroke: Stroke)
    func undo()
    func redo()
}

class StrokeHistory: StrokeHistoryProtocol {
    let undoLimit: Int
    
    private var canvas: Canvas
    private(set) var strokes: [Stroke] = []
    private(set) var unDoneStrokes: [Stroke] = []
    
    init(canvas: Canvas) {
        self.canvas = canvas
        undoLimit = 10
    }
    
    init(canvas: Canvas, undoLimit: Int) {
        self.canvas = canvas
        self.undoLimit = undoLimit
    }
    
    func addStroke(stroke: Stroke) {
        strokes.append(stroke)
        
        if strokes.count > undoLimit + 1 {
            strokes.removeFirst()
        }
        
        unDoneStrokes = []
    }
    
    func undo() {
        guard !strokes.isEmpty else {
            return
        }
        
        guard unDoneStrokes.count < undoLimit else {
            return
        }
        
        if let last = strokes.popLast() {
            unDoneStrokes.append(last)
            if let previous = strokes.last {
                canvas.currentStroke = previous
            } else {
                canvas.currentStroke = nil
            }
        }
    }
    
    func redo() {
        guard !unDoneStrokes.isEmpty else {
            return
        }
        
        if let stroke = unDoneStrokes.popLast() {
            strokes.append(stroke)
            canvas.currentStroke = stroke
        }
    }
}
