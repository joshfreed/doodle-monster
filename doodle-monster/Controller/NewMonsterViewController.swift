//
//  NewMonsterViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class NewMonsterViewController: UIViewController {
    @IBOutlet weak var currentPlayersLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var invitePlayersLabel: UILabel!
    @IBOutlet weak var inviteButtonsStack: UIStackView!
    @IBOutlet weak var currentPlayerName: UILabel!
    @IBOutlet weak var currentPlayerEmail: UILabel!

    var playerViews: [PlayerView] = []
    var newMonster: Game?
    
    var viewModel: NewMonsterViewModelProtocol! {
        didSet {
            self.viewModel.playerWasAdded = self.addPlayerView
            self.viewModel.playerWasRemoved = self.removePlayerView
            self.viewModel.buttonVisibilityChanged = self.updateStartButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPlayerName.text = viewModel.currentPlayer.displayName
        currentPlayerEmail.text = viewModel.currentPlayer.email
        updateStartButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InviteByEmail" {
            if let nc = segue.destinationViewController as? UINavigationController,
                vc = nc.topViewController as? InviteByEmailViewController
            {
                let vm = InviteByEmailViewModel(playerService: appDelegate.playerService)
                vm.playerWasSelected = viewModel.addPlayer
                vc.viewModel = vm
            }
        } else if segue.identifier == "goToNewMonster" {
            if let vc = segue.destinationViewController as? DrawingViewController {
                vc.viewModel = DrawingViewModel(game: newMonster!)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToNewMonster(segue: UIStoryboardSegue) {
        
    }

    @IBAction func inviteFromFacebook(sender: UIButton) {
        
    }
    
    @IBAction func start(sender: UIButton) {
        viewModel.startGame()
    }
    
    // MARK: Views or whatever
    
    private func addPlayerView(playerViewModel: PlayerViewModelProtocol) {
        let playerView = PlayerView.loadFromNib()
        playerView.configure(self.viewModel, playerViewModel: playerViewModel)
        self.stackView.addArrangedSubview(playerView)
        self.playerViews.append(playerView)
    }
    
    private func removePlayerView(playerViewModel: PlayerViewModelProtocol) {
        for playerView in self.playerViews {
            if playerView.playerViewModel.isEqualTo(playerViewModel) {
                self.stackView.removeArrangedSubview(playerView)
                playerView.removeFromSuperview()
            }
        }
    }

    private func updateStartButton() {
        startButton.hidden = viewModel.buttonHidden
    }
}

extension NewMonsterViewController: NewMonsterRouter {
    func goToNewMonster(game: Game) {
        newMonster = game
        performSegueWithIdentifier("goToNewMonster", sender: self)
    }
}
