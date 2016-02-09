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
}

class MainMenuRouterImpl: MainMenuRouter {
    weak var vc: MainMenuViewController!
    
    init(vc: MainMenuViewController) {
        self.vc = vc
    }
    
    func showNewMonsterScreen() {
        vc!.performSegueWithIdentifier("NewMonster", sender: vc)
    }
}
