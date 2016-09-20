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

    override func viewDidAppear(_ animated: Bool) {
        updateZoom()
        viewModel.loadPreviousTurns()
    }

    @IBAction func unwindToDrawing(_ segue: UIStoryboardSegue) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveDrawing" {
            let vc = segue.destination as! SaveViewController
            vc.viewModel = viewModel
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageContainer
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func touchedSave(_ sender: UIButton) {
        viewModel.saveImages()
        performSegue(withIdentifier: "SaveDrawing", sender: self)
    }
    
    @IBAction func touchedPencil(_ sender: UIButton) {
        viewModel.enterDrawMode()
    }
    
    @IBAction func touchedEraser(_ sender: UIButton) {
        viewModel.enterEraseMode()
    }
    
    @IBAction func touchedCancel(_ sender: UIButton) {
        viewModel.cancelDrawing()
    }
    
    @IBAction func undo(_ sender: UIButton) {
        viewModel.undo()
    }
    
    @IBAction func redo(_ sender: UIButton) {
        viewModel.redo()
    }
    
    // MARK: - View Commands
    
    func switchToDrawMode() {
        pencilButton.setImage(UIImage(named: "pencil-selected"), for: UIControlState())
        eraserButton.setImage(UIImage(named: "eraser"), for: UIControlState())
        
        view.layoutIfNeeded()
        
        pencilNotSelectedConstraint.isActive = false
        eraserSelectedConstraint.isActive = false
        pencilSelectedContraint.isActive = true
        eraserNotSelectedConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }
    
    func switchToEraseMode() {
        pencilButton.setImage(UIImage(named: "pencil"), for: UIControlState())
        eraserButton.setImage(UIImage(named: "eraser-selected"), for: UIControlState())
        
        view.layoutIfNeeded()
        
        pencilSelectedContraint.isActive = false
        eraserNotSelectedConstraint.isActive = false
        pencilNotSelectedConstraint.isActive = true
        eraserSelectedConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }
    
    func showCancelConfirmation() {
        performSegue(withIdentifier: "ConfirmCancelDrawing", sender: self)
    }
    
    func goToMainMenu() {
        performSegue(withIdentifier: "cancelDrawing", sender: self)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            viewModel.startDraw(touch.location(in: imageContainer))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            viewModel.movePencilTo(touch.location(in: imageContainer))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.endDraw()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.abortLine()
    }
    
    // MARK: - DrawingView
    
    func allowPanningAndZooming() -> Bool {
        return viewModel.drawingService.allowPanningAndZooming()
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ err: Error) {
        showErrorAlert(err, title: nil)
    }
}

enum DrawingMode {
    case draw
    case erase
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

