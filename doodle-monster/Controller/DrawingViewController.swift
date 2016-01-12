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
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var pencilSelectedContraint: NSLayoutConstraint!
    @IBOutlet weak var pencilNotSelectedConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserSelectedConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserNotSelectedConstraint: NSLayoutConstraint!
    
    let pencilConstantOffset: Double = 0.0
    var drawingMode: DrawingMode = .Draw
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 2.0
    var eraserWidth: CGFloat = 10.0
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
        guard drawingMode != .Draw else {
            return
        }
        
        pencilButton.setImage(UIImage(named: "pencil-selected"), forState: .Normal)
        eraserButton.setImage(UIImage(named: "eraser"), forState: .Normal)
        
        view.layoutIfNeeded()
        
        pencilNotSelectedConstraint.active = false
        eraserSelectedConstraint.active = false
        pencilSelectedContraint.active = true
        eraserNotSelectedConstraint.active = true
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        drawingMode = .Draw
    }
    
    @IBAction func touchedEraser(sender: UIButton) {
        guard drawingMode != .Erase else {
            return
        }
        
        pencilButton.setImage(UIImage(named: "pencil"), forState: .Normal)
        eraserButton.setImage(UIImage(named: "eraser-selected"), forState: .Normal)
        
        view.layoutIfNeeded()
        
        pencilSelectedContraint.active = false
        eraserNotSelectedConstraint.active = false
        pencilNotSelectedConstraint.active = true
        eraserSelectedConstraint.active = true
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        drawingMode = .Erase
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
            tempImageView.image = currentTurnImageView.image
            currentTurnImageView.image = nil
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
        
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        currentTurnImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        currentTurnImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.image = nil
        UIGraphicsEndImageContext()
    }
    
    // MARK: - Drawing
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        CGContextSetLineCap(context, CGLineCap.Round)
        
        if drawingMode == .Draw {
            CGContextSetLineWidth(context, brushWidth)
            CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
            CGContextSetBlendMode(context, CGBlendMode.Normal)
        } else if drawingMode == .Erase {
            CGContextSetLineWidth(context, eraserWidth)
            CGContextSetBlendMode(context, CGBlendMode.Clear)
        }
        
        CGContextStrokePath(context)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}

enum DrawingMode {
    case Draw
    case Erase
}
