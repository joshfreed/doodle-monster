//
//  DrawingViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

class DrawingViewController: UIViewController {
    var viewModel: DrawingViewModel!
    @IBOutlet weak var previousTurnsImageView: UIImageView!
    @IBOutlet weak var currentTurnImageView: UIImageView!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        if let previousMonsterFile = viewModel.game.imageFile {
            previousMonsterFile.getDataInBackgroundWithBlock() { (imageData: NSData?, error: NSError?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        self.previousTurnsImageView.image = image
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    
    // MARK: - Actions
    
    @IBAction func touchedSave(sender: UIButton) {
        UIGraphicsBeginImageContext(previousTurnsImageView.frame.size)
        previousTurnsImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        currentTurnImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        previousTurnsImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let newFullImage = previousTurnsImageView.image else {
            return
        }
        guard let fullImageData = UIImagePNGRepresentation(newFullImage) else {
            return
        }

        guard let currentTurnImage = currentTurnImageView.image else {
            return
        }
        guard let currentTurnImageData = UIImagePNGRepresentation(currentTurnImage) else {
            return
        }
        
        viewModel.save(currentTurnImageData, fullImageData: fullImageData)
    }
    
    @IBAction func touchedPencil(sender: UIButton) {
        // change to highlighted image; animate upwards
        // change eraser to regular; animate down
    }
    
    @IBAction func touchedEraser(sender: UIButton) {
    }
    
    @IBAction func touchedCancel(sender: UIButton) {
        
    }
    
    @IBAction func undo(sender: UIButton) {
    }
    
    @IBAction func redo(sender: UIButton) {
    }

    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first {
             lastPoint = touch.locationInView(self.view)
        }
        
        super.touchesBegan(touches, withEvent:event)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
    }
    
    // MARK: - Drawing
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        currentTurnImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        CGContextStrokePath(context)
        
        currentTurnImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        currentTurnImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}
