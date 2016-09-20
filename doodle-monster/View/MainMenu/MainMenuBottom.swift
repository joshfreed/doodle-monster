//
//  MainMenuCollectionReusableView.swift
//  doodle-monster
//
//  Created by Josh Freed on 1/18/16.
//  Copyright © 2016 BleepSmazz. All rights reserved.
//

import UIKit

class MainMenuBottom: UICollectionReusableView, NibLoadableView {
    weak var viewModel: MainMenuViewModelProtocol?

    @IBAction func newMonster(_ sender: AnyObject) {
        viewModel?.newMonster()
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        viewModel?.signOut()
    }
}
