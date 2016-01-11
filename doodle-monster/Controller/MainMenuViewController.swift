//
//  MainMenuViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

class MainMenuViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var yourTurnCollection: UICollectionView!
    @IBOutlet weak var waitingCollection: UICollectionView!

    var yourTurnDataSource: ArrayDataSource<YourTurnCell, GameViewModel>!
    var waitingDataSource: ArrayDataSource<WaitingCellCollectionViewCell, GameViewModel>!
    var selectedIndex: Int?
    
    var viewModel: MainMenuViewModelProtocol! {
        didSet {
            viewModel.gamesUpdated = self.gamesUpdated
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        yourTurnDataSource = ArrayDataSource(items: [], cellIdentifier: "YourTurnGameCell")
        yourTurnCollection.registerNib(UINib(nibName: "YourTurnCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "YourTurnGameCell")
        yourTurnCollection.dataSource = yourTurnDataSource
        yourTurnCollection.delegate = self
        
        waitingDataSource = ArrayDataSource(items: [], cellIdentifier: "WaitingGameCell")
        waitingCollection.registerNib(UINib(nibName: "WaitingCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "WaitingGameCell")
        waitingCollection.dataSource = waitingDataSource
        
        viewModel.loadItems()

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
                vc.viewModel = NewMonsterViewModel(
                    currentPlayer: currentPlayer,
                    gameService: appDelegate.gameService,
                    router: vc
                )
            }
        } else if segue.identifier == "goToGame" {
            if let nc = segue.destinationViewController as? UINavigationController,
                vc = nc.topViewController as? DrawingViewController,
                selectedIndex = self.selectedIndex
            {
                vc.viewModel = viewModel.getDrawingViewModel(selectedIndex)
            }
        }
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
    }

    @IBAction func signOut(sender: UIButton) {
        PFUser.logOut()
        performSegueWithIdentifier("ShowLoginScreen", sender: self)
    }

    func gamesUpdated() {
        yourTurnDataSource.replaceItems(viewModel.yourTurnGames)
        yourTurnCollection.insertItemsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)])
        yourTurnCollection.reloadData()
        
        waitingDataSource.replaceItems(viewModel.waitingGames)
        waitingCollection.insertItemsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)])
        waitingCollection.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("goToGame", sender: self)
    }
}

