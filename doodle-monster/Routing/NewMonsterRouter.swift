//
// Created by Josh Freed on 2/9/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import UIKit

protocol NewMonsterRouter {
    func goToNewMonster(_ game: Game)
}

class NewMonsterRouterImpl: NewMonsterRouter {
    weak var vc: NewMonsterViewController!
    weak var viewModelFactory: ViewModelFactory!

    init(vc: NewMonsterViewController, vmFactory: ViewModelFactory) {
        self.vc = vc
        self.viewModelFactory = vmFactory

        self.vc.segues["InviteByEmail"] = Segue(action: segueToInviteByEmailViewController, arguments: [:])
    }

    func goToNewMonster(_ game: Game) {
        vc.segues["goToNewMonster"] = Segue(action: segueToDrawingViewController, arguments: ["game": game])
        vc.performSegue(withIdentifier: "goToNewMonster", sender: vc)
    }

    func segueToDrawingViewController(_ destinationViewController: UIViewController, arguments: [String: Any]) {
        guard let vc = destinationViewController as? DrawingViewController else {
            fatalError("Unexpected view controller type")
        }
        guard let drawingView = destinationViewController as? DrawingView else {
            fatalError("Unexpected view controller type")
        }
        guard let game = arguments["game"] as? Game else {
            fatalError("No game in arguments")
        }

        vc.viewModel = viewModelFactory.drawingViewModel(game, view: drawingView)
    }

    func segueToInviteByEmailViewController(_ destinationViewController: UIViewController, arguments: [String: Any]) {
        if let nc = destinationViewController as? UINavigationController,
            let vc = nc.topViewController as? InviteByEmailViewController
        {
            vc.viewModel = viewModelFactory.inviteByEmailViewModel(vc)
        }
    }
}
