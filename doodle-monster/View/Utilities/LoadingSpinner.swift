//
//  LoadingSpinner.swift
//  doodle-monster
//
//  Created by Josh Freed on 4/15/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class LoadingSpinner {
    var overlayView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    func show(inView parent: UIView) {
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        parent.addSubview(overlayView)
    }
    
    func hide() {
        guard overlayView != nil else {
            return
        }
        
        overlayView.removeFromSuperview()
    }
}

