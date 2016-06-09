//
//  ViewControllerExtensions.swift
//  doodle-monster
//
//  Created by Josh Freed on 6/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(err: ErrorType, title: String?) {
        let title = title ?? "Server Error"
        let defaultMessage = "This operation could not be completed because a server error has occurred. Please try again later."
        
        switch err {
        case DoodMonError.HttpError(_, let msg): showSimpleAlert(title: title, message: msg)
        case DoodMonError.ServerError(let msg): showSimpleAlert(title: title, message: msg)
        default: showSimpleAlert(title: title, message: defaultMessage)
        }
    }
}
