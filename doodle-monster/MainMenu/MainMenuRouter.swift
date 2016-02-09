//
//  MainMenuRouter.swift
//  doodle-monster
//
//  Created by Josh Freed on 2/8/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol MainMenuRouter {
    func showNewMonsterScreen()
    func showDrawingScreen(game: Game)
    func showLoginScreen()
}

class MainMenuRouterImpl: MainMenuRouter {
    weak var vc: MainMenuViewController!
    weak var viewModelFactory: ViewModelFactory!
    
    init(vc: MainMenuViewController, vmFactory: ViewModelFactory) {
        self.vc = vc
        self.viewModelFactory = vmFactory
    }

    // MARK: - MainMenuRouter

    func showNewMonsterScreen() {
        vc.segues["NewMonster"] = Segue(action: segueToNewMonsterViewController, arguments: [:])
        vc.performSegueWithIdentifier("NewMonster", sender: vc)
    }

    func showDrawingScreen(game: Game) {
        vc.segues["goToGame"] = Segue(action: segueToDrawingViewController, arguments: ["game": game])
        vc.performSegueWithIdentifier("goToGame", sender: vc)
    }

    func showLoginScreen() {
        vc.performSegueWithIdentifier("ShowLoginScreen", sender: vc)
    }

    // MARK: - Segues

    func segueToNewMonsterViewController(destinationViewController: UIViewController, arguments: [String: Any]) {
        guard let vc = destinationViewController as? NewMonsterViewController else {
            fatalError("Unexpected view controller type")
        }
        vc.viewModel = viewModelFactory.newMonsterViewModel(vc)
    }

    func segueToDrawingViewController(destinationViewController: UIViewController, arguments: [String: Any]) {
        guard let vc = destinationViewController as? DrawingViewController else {
            fatalError("Unexpected view controller type")
        }
        guard let game = arguments["game"] as? Game else {
            fatalError("No game in arguments")
        }

        vc.viewModel = viewModelFactory.drawingViewModel(game)
    }
}
