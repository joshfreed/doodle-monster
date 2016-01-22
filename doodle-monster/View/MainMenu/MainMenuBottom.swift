//
//  MainMenuCollectionReusableView.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class MainMenuBottom: UICollectionReusableView, NibLoadableView {
    var viewModel: MainMenuViewModelProtocol!

    @IBAction func newMonster(sender: AnyObject) {
        viewModel.newMonster()
    }
    
    @IBAction func signOut(sender: AnyObject) {
        viewModel.signOut()
    }
}
