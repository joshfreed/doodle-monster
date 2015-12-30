//
//  NewMonsterViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class NewMonsterViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!

    var playerViews: [PlayerView] = []
    
    var viewModel: NewMonsterViewModelProtocol! {
        didSet {
            self.viewModel.playerWasAdded = self.addPlayerView
            self.viewModel.playerWasRemoved = self.removePlayerView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InviteByEmail" {
            if let vc = segue.destinationViewController as? InviteByEmailViewController {
                let vm = InviteByEmailViewModel(userService: appDelegate.userService)
                vm.playerWasSelected = viewModel.addPlayer
                vc.viewModel = vm
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToNewMonster(segue: UIStoryboardSegue) {
        
    }

    @IBAction func inviteFromFacebook(sender: UIButton) {
        
    }
    
    @IBAction func inviteByEmail(sender: UIButton) {
        
    }
    
    @IBAction func start(sender: UIButton) {
        
    }
    
    // MARK: Views or whatever
    
    private func addPlayerView(playerViewModel: PlayerViewModelProtocol) {
        let playerView = PlayerView.loadFromNib()
        playerView.configure(self.viewModel, playerViewModel: playerViewModel)
        self.stackView.insertArrangedSubview(playerView, atIndex: 1)
        self.playerViews.append(playerView)
    }
    
    private func removePlayerView(playerViewModel: PlayerViewModelProtocol) {
        for playerView in self.playerViews {
            if playerView.playerViewModel.isEqualTo(playerViewModel) {
                self.stackView.removeArrangedSubview(playerView)
            }
        }
    }
}
