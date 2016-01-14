//
//  DrawingViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

class DrawingViewController: UIViewController, UIScrollViewDelegate {
    var viewModel: DrawingViewModel!
    @IBOutlet weak var previousTurnsImageView: UIImageView!
    @IBOutlet weak var currentTurnImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageContainer: UIView!

    @IBOutlet weak var pencilSelectedContraint: NSLayoutConstraint!
    @IBOutlet weak var pencilNotSelectedConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserSelectedConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserNotSelectedConstraint: NSLayoutConstraint!
    
    let pencilConstantOffset: Double = 0.0
    var drawingMode: DrawingMode = .Draw
    var strokeHistory: StrokeHistory!
    
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
        
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 7.0;
        scrollView.contentSize = imageContainer.frame.size;
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollView.delaysContentTouches = false
        scrollView.delegate = self

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
        
        strokeHistory = StrokeHistory(canvas: currentTurnImageView)
        saveCurrentToHistory()
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
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageContainer
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func touchedSave(sender: UIButton) {
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        previousTurnsImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        currentTurnImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
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
        strokeHistory.undo()
    }
    
    @IBAction func redo(sender: UIButton) {
        strokeHistory.redo()
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            startDraw(touch.locationInView(imageContainer))
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            movePencilTo(touch.locationInView(imageContainer))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endDraw()
    }
    
    // MARK: - Drawing
    
    func startDraw(currentPoint: CGPoint) {
        swiped = false
        lastPoint = currentPoint
    }
    
    func movePencilTo(currentPoint: CGPoint) {
        swiped = true
        drawLineFrom(lastPoint, toPoint: currentPoint)
        lastPoint = currentPoint
    }
    
    func endDraw() {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }

        saveCurrentToHistory()
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(currentTurnImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        currentTurnImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: currentTurnImageView.frame.size.width, height: currentTurnImageView.frame.size.height))
        
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
        
        currentTurnImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        currentTurnImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }

    func saveCurrentToHistory() {
        guard let image = currentTurnImageView.image else {
            return
        }
        
        strokeHistory.addStroke(image)
    }
}

enum DrawingMode {
    case Draw
    case Erase
}

extension UIImage: Stroke {
    var image: UIImage {
        return self
    }
}

extension UIImageView: Canvas {
    var currentStroke: Stroke? {
        get { return image }
        set(stroke) { image = stroke?.image }
    }
}

