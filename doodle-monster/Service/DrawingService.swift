//
//  DrawingService.swift
//  doodle-monster
//
//  Created by Josh Freed on 3/20/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol DrawingServiceProtocol {
    var fullImageData: Data? { get }
    var drawingMode: DrawingMode { get set }
    
    func setImageData(_ imageData: Data)
    func startDraw(_ currentPoint: CGPoint)
    func movePencilTo(_ currentPoint: CGPoint)
    func endDraw()
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint)
    func abortLine()
    func saveCurrentToHistory()
    func allowPanningAndZooming() -> Bool
    func hasMadeChanges() -> Bool
    func undo()
    func redo()
}

class DrawingService: DrawingServiceProtocol {
    let strokeHistory: StrokeHistoryProtocol
    let uiDrawingService: GraphicsContextService
    
    var drawingMode: DrawingMode = .draw
    
    fileprivate(set) var startPoint = CGPoint.zero
    fileprivate(set) var lastPoint = CGPoint.zero
    fileprivate(set) var swiped = false
    
    var fullImageData: Data? {
        return uiDrawingService.fullImageData as Data?
    }
    
    init(uiDrawingService: GraphicsContextService, strokeHistory: StrokeHistoryProtocol) {
        self.uiDrawingService = uiDrawingService
        self.strokeHistory = strokeHistory
        saveCurrentToHistory()
    }
    
    func setImageData(_ imageData: Data) {
        uiDrawingService.setImageData(imageData)
    }
    
    func startDraw(_ currentPoint: CGPoint) {
        swiped = false
        lastPoint = currentPoint
        startPoint = currentPoint
    }
    
    func movePencilTo(_ currentPoint: CGPoint) {
        swiped = true
        drawLineFrom(lastPoint, toPoint: currentPoint)
        lastPoint = currentPoint
    }
    
    func endDraw() {
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        startPoint = CGPoint.zero
        
        saveCurrentToHistory()
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        uiDrawingService.startDrawingLine(fromPoint, toPoint)
        
        if drawingMode == .draw {
            uiDrawingService.setNormalStroke()
        } else if drawingMode == .erase {
            uiDrawingService.setClearStroke()
        }
    
        uiDrawingService.endDrawingLine()
    }
    
    func abortLine() {
        saveCurrentToHistory()
        strokeHistory.undo()
    }
    
    func saveCurrentToHistory() {
        guard let image = uiDrawingService.currentImage else {
            return
        }
        
        strokeHistory.addStroke(image)
    }
    
    func allowPanningAndZooming() -> Bool {
        if startPoint != CGPoint.zero {
            let xDist = lastPoint.x - startPoint.x
            let yDist = lastPoint.y - startPoint.y
            let distance = sqrt((xDist * xDist) + (yDist * yDist))
            print("Distance: \(distance)")
            
            // 8 seems like an okay number of my iPhone 6
            // If your finger has moved more than 8, then don't allow panning and zooming - continue drawing
            // If less than 8, then cancel the stroke - erase it, and allow panning and zooming
            return distance < 8
        }
        
        return true
    }
    
    func hasMadeChanges() -> Bool {
        return strokeHistory.strokes.count > 0
    }
    
    func undo() {
        strokeHistory.undo()
    }
    
    func redo() {
        strokeHistory.redo()
    }
}
