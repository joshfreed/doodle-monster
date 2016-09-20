//
//  UIDrawingService.swift
//  doodle-monster
//
//  Created by Josh Freed on 3/26/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol GraphicsContextService {
    var fullImageData: Data? { get }
    var currentImage: UIImage? { get }
    func setImageData(_ imageData: Data)
    func startDrawingLine(_ fromPoint: CGPoint, _ toPoint: CGPoint)
    func setNormalStroke()
    func setClearStroke()
    func endDrawingLine()
}

class UIDrawingService: GraphicsContextService {
    let currentTurnImageView: UIImageView
    let previousTurnImageView: UIImageView
    
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 2.0
    var eraserWidth: CGFloat = 10.0
    
    var context: CGContext?
    
    var fullImageData: Data? {
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        let rect = CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height)
        previousTurnImageView.image?.draw(in: rect, blendMode: CGBlendMode.normal, alpha: 1.0)
        currentTurnImageView.image?.draw(in: rect, blendMode: CGBlendMode.normal, alpha: opacity)
        previousTurnImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let newFullImage = previousTurnImageView.image else {
            return nil
        }
        guard let fullImageData = UIImagePNGRepresentation(newFullImage) else {
            return nil
        }
        return fullImageData
    }
    
    
    var currentImage: UIImage? {
        return currentTurnImageView.image
    }
    
    init(currentTurnImageView: UIImageView, previousTurnImageView: UIImageView) {
        self.currentTurnImageView = currentTurnImageView
        self.previousTurnImageView = previousTurnImageView
    }
    
    func setImageData(_ imageData: Data) {
        let image = UIImage(data: imageData)
        self.previousTurnImageView.image = image
    }
    
    func startDrawingLine(_ fromPoint: CGPoint, _ toPoint: CGPoint) {
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        context = UIGraphicsGetCurrentContext()
        currentTurnImageView.image?.draw(in: CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setLineCap(CGLineCap.round)
    }
    
    func setNormalStroke() {
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
    }
    
    func setClearStroke() {
        context?.setLineWidth(eraserWidth)
        context?.setBlendMode(CGBlendMode.clear)
    }
    
    func endDrawingLine() {
        context?.strokePath()
        
        currentTurnImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        currentTurnImageView.alpha = opacity
        UIGraphicsEndImageContext()
        context = nil
    }
}
