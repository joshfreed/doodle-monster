//
//  NewMonsterViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class NewMonsterViewController: UIViewController, RoutedSegue, NewMonsterView {
    @IBOutlet weak var currentPlayersLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var invitePlayersLabel: UILabel!
    @IBOutlet weak var inviteButtonsStack: UIStackView!
    @IBOutlet weak var currentPlayerName: UILabel!
    @IBOutlet weak var currentPlayerEmail: UILabel!

    var segues: [String: Segue] = [:]
    var playerViews: [PlayerView] = []

    var viewModel: NewMonsterViewModelProtocol!
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareRoutedSegue(segue, sender: sender)
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToNewMonster(_ segue: UIStoryboardSegue) {
        
    }

    @IBAction func inviteFromFacebook(_ sender: UIButton) {
        
    }
    
    @IBAction func start(_ sender: UIButton) {
        viewModel.startGame()
    }

    // MARK: - NewMonsterView

    func displayPlayer(_ player: PlayerViewModel) {
        let playerView = PlayerView.loadFromNib()
        playerView.configure(viewModel, playerViewModel: player)
        stackView.addArrangedSubview(playerView)
        playerViews.append(playerView)
    }

    func removePlayer(_ player: PlayerViewModel) {
        for playerView in playerViews {
            if playerView.playerViewModel == player {
                stackView.removeArrangedSubview(playerView)
                playerView.removeFromSuperview()
            }
        }
    }

    func updateStartButton() {
        startButton.isHidden = viewModel.buttonHidden
    }
}

