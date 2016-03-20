//
//  PlayerView.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/29/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class PlayerView: UIStackView {
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var viewModel: NewMonsterViewModelProtocol!
    var playerViewModel: PlayerViewModel!
    
    @IBAction func removePlayer(sender: UIButton) {
        viewModel.removePlayer(playerViewModel)
    }
    
    func configure(viewModel: NewMonsterViewModelProtocol, playerViewModel: PlayerViewModel) {
        self.viewModel = viewModel
        self.playerViewModel = playerViewModel
        displayNameLabel.text = playerViewModel.displayName
        emailLabel.text = playerViewModel.email
    }
}
