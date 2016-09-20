//
//  ViewControllerExtensions.swift
//  doodle-monster
//
//  Created by Josh Freed on 6/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ err: Error, title: String?) {
        let title = title ?? "Server Error"
        let defaultMessage = "This operation could not be completed because a server error has occurred. Please try again later."
        
        switch err {
        case DoodMonError.httpError(_, let msg): showSimpleAlert(title: title, message: msg)
        case DoodMonError.serverError(let msg): showSimpleAlert(title: title, message: msg)
        default: showSimpleAlert(title: title, message: defaultMessage)
        }
    }
}
