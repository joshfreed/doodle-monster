//
// Created by Josh Freed on 2/9/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol NewMonsterRouter {
    func goToNewMonster(game: Game)
}

class NewMonsterRouterImpl: NewMonsterRouter {
    weak var vc: NewMonsterViewController!
    weak var viewModelFactory: ViewModelFactory!

    init(vc: NewMonsterViewController, vmFactory: ViewModelFactory) {
        self.vc = vc
        self.viewModelFactory = vmFactory

        self.vc.segues["InviteByEmail"] = Segue(action: segueToInviteByEmailViewController, arguments: [:])
    }

    func goToNewMonster(game: Game) {
        vc.segues["goToGame"] = Segue(action: segueToDrawingViewController, arguments: ["game": game])
        vc.performSegueWithIdentifier("goToNewMonster", sender: vc)
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

    func segueToInviteByEmailViewController(destinationViewController: UIViewController, arguments: [String: Any]) {
        if let nc = destinationViewController as? UINavigationController,
            vc = nc.topViewController as? InviteByEmailViewController
        {
            vc.viewModel = viewModelFactory.inviteByEmailViewModel()
        }
    }
}
