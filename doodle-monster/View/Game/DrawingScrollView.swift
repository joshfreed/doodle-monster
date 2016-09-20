//
//  DrawingScrollView.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/14/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol DrawingView {
    func allowPanningAndZooming() -> Bool
    func switchToDrawMode()
    func switchToEraseMode()
    func showCancelConfirmation()
    func goToMainMenu()
    func showAlert(_ title: String, message: String)
    func showError(_ err: Error)
}

class DrawingScrollView: UIScrollView {
    var drawingDelegate: DrawingView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.next?.touchesMoved(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.next?.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if drawingDelegate != nil {
            return drawingDelegate!.allowPanningAndZooming()
        } else {
            return super.touchesShouldCancel(in: view)
        }
    }
}
