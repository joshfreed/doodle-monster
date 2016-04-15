//
//  UIDrawingService.swift
//  doodle-monster
//
//  Created by Josh Freed on 3/26/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol GraphicsContextService {
    var fullImageData: NSData? { get }
    var currentImage: UIImage? { get }
    func setImageData(imageData: NSData)
    func startDrawingLine(fromPoint: CGPoint, _ toPoint: CGPoint)
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
    
    var fullImageData: NSData? {
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        let rect = CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height)
        previousTurnImageView.image?.drawInRect(rect, blendMode: CGBlendMode.Normal, alpha: 1.0)
        currentTurnImageView.image?.drawInRect(rect, blendMode: CGBlendMode.Normal, alpha: opacity)
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
    
    func setImageData(imageData: NSData) {
        let image = UIImage(data: imageData)
        self.previousTurnImageView.image = image
    }
    
    func startDrawingLine(fromPoint: CGPoint, _ toPoint: CGPoint) {
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        context = UIGraphicsGetCurrentContext()
        currentTurnImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        CGContextSetLineCap(context, CGLineCap.Round)
    }
    
    func setNormalStroke() {
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
    }
    
    func setClearStroke() {
        CGContextSetLineWidth(context, eraserWidth)
        CGContextSetBlendMode(context, CGBlendMode.Clear)
    }
    
    func endDrawingLine() {
        CGContextStrokePath(context)
        
        currentTurnImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        currentTurnImageView.alpha = opacity
        UIGraphicsEndImageContext()
        context = nil
    }
}
