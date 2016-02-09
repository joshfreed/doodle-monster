//
//  SegueHandler.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/5/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        // still have to use guard stuff here, but at least you're extracting it this time
        guard let identifier = segue.identifier, segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).")
        }
        
        return segueIdentifier
    }
}



protocol RoutedSegue {
    var segues: [String: Segue] { get set }
}

extension RoutedSegue where Self: UIViewController {
    func prepare(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier, segueAction = segues[identifier] else {
            print("Segue \(segue.identifier) was not configured")
            return
        }

        segueAction.run(segue.destinationViewController)
    }
}

struct Segue {
    let action: (UIViewController, [String: Any]) -> ()
    let arguments: [String: Any]

    init(action: (UIViewController, [String: Any]) -> (), arguments: [String: Any]) {
        self.action = action
        self.arguments = arguments
    }

    func run(vc: UIViewController) {
        action(vc, arguments)
    }
}
