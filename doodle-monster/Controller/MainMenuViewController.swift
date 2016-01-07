//
//  MainMenuViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

class MainMenuViewController: UIViewController {
    @IBOutlet weak var yourTurnCollection: UICollectionView!
    @IBOutlet weak var waitingCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewMonster" {
            if let vc = segue.destinationViewController as? NewMonsterViewController {
                let currentPlayer = appDelegate.playerService.getCurrentPlayer()!
                vc.viewModel = NewMonsterViewModel(currentPlayer: currentPlayer, gameService: appDelegate.gameService)
            }
        }
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
    }

    @IBAction func signOut(sender: UIButton) {
        PFUser.logOut()
        performSegueWithIdentifier("ShowLoginScreen", sender: self)
    }
}
