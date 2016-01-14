//
//  DrawingScrollView.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/14/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class DrawingScrollView: UIScrollView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nextResponder()?.touchesBegan(touches, withEvent: event)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nextResponder()?.nextResponder()?.touchesMoved(touches, withEvent: event)
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nextResponder()?.nextResponder()?.touchesEnded(touches, withEvent: event)
        super.touchesEnded(touches, withEvent: event)
    }
}
