//
//  DrawingViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/11/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, UIScrollViewDelegate, DrawingView {
    var viewModel: DrawingViewModel!
    @IBOutlet weak var previousTurnsImageView: UIImageView!
    @IBOutlet weak var currentTurnImageView: UIImageView!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scrollView: DrawingScrollView!
    @IBOutlet weak var imageContainer: UIView!

    @IBOutlet weak var pencilSelectedContraint: NSLayoutConstraint!
    @IBOutlet weak var pencilNotSelectedConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserSelectedConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserNotSelectedConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollView.delaysContentTouches = false
        scrollView.delegate = self
        scrollView.drawingDelegate = self
        scrollView.accessibilityActivate()
        scrollView.accessibilityIdentifier = "drawingScrollView"
        
        let uiDrawingService = UIDrawingService(
            currentTurnImageView: self.currentTurnImageView,
            previousTurnImageView: self.previousTurnsImageView
        )
        viewModel.drawingService = DrawingService(
            uiDrawingService: uiDrawingService,
            strokeHistory: StrokeHistory(canvas: uiDrawingService.currentTurnImageView)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        updateZoom()
        viewModel.loadPreviousTurns()
    }

    @IBAction func unwindToDrawing(segue: UIStoryboardSegue) {
    }
    
    func updateZoom() {
        let heightScale = scrollView.bounds.size.height / imageContainer.bounds.size.height
        let widthScale = scrollView.bounds.size.width / imageContainer.bounds.size.width
//        print("ScrollView bounds: \(scrollView.bounds.size), img: \(imageContainer.bounds.size), heightScale: \(heightScale), widthScale: \(widthScale)")
        scrollView.minimumZoomScale = min(heightScale, widthScale)
        scrollView.maximumZoomScale = 7.0
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveDrawing" {
            let vc = segue.destinationViewController as! SaveViewController
            vc.viewModel = viewModel
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageContainer
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func touchedSave(sender: UIButton) {
        viewModel.saveImages()
        performSegueWithIdentifier("SaveDrawing", sender: self)
    }
    
    @IBAction func touchedPencil(sender: UIButton) {
        viewModel.enterDrawMode()
    }
    
    @IBAction func touchedEraser(sender: UIButton) {
        viewModel.enterEraseMode()
    }
    
    @IBAction func touchedCancel(sender: UIButton) {
        viewModel.cancelDrawing()
    }
    
    @IBAction func undo(sender: UIButton) {
        viewModel.undo()
    }
    
    @IBAction func redo(sender: UIButton) {
        viewModel.redo()
    }
    
    // MARK: - View Commands
    
    func switchToDrawMode() {
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
    }
    
    func switchToEraseMode() {
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
    }
    
    func showCancelConfirmation() {
        performSegueWithIdentifier("ConfirmCancelDrawing", sender: self)
    }
    
    func goToMainMenu() {
        performSegueWithIdentifier("cancelDrawing", sender: self)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            viewModel.startDraw(touch.locationInView(imageContainer))
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            viewModel.movePencilTo(touch.locationInView(imageContainer))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        viewModel.endDraw()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        viewModel.abortLine()
    }
    
    // MARK: - DrawingView
    
    func allowPanningAndZooming() -> Bool {
        return viewModel.drawingService.allowPanningAndZooming()
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

