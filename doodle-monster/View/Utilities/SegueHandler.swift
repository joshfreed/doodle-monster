//
//  SegueHandler.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/5/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        // still have to use guard stuff here, but at least you're extracting it this time
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).")
        }
        
        return segueIdentifier
    }
}



protocol RoutedSegue {
    var segues: [String: Segue] { get set }
}

extension RoutedSegue where Self: UIViewController {
    func prepareRoutedSegue(_ segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let segueAction = segues[identifier] else {
            print("Segue \(segue.identifier) was not configured")
            return
        }

        segueAction.run(segue.destination)
    }
}

struct Segue {
    let action: (UIViewController, [String: Any]) -> ()
    let arguments: [String: Any]

    init(action: @escaping (UIViewController, [String: Any]) -> (), arguments: [String: Any]) {
        self.action = action
        self.arguments = arguments
    }

    func run(_ vc: UIViewController) {
        action(vc, arguments)
    }
}
