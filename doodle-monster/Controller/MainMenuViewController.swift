//
//  MainMenuViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var monsterCollection: UICollectionView!

    var monsterDataSource: SectionedArrayDataSource<GameViewModel>!
    var selectedIndex: Int?
    
    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 0.0
    
    var offscreenCells = Dictionary<String, UICollectionViewCell>()

    var headerViewFactory: SupplementaryViewFactory<MonsterSectionHeader>!
    var footerViewFactory: MonsterFooterViewFactory!
    var yourTurn: Section<GameViewModel, YourTurnCell, MonsterSectionHeader, MonsterSectionFooter>!
    var waiting: Section<GameViewModel, WaitingCell, MonsterSectionHeader, MonsterSectionFooter>!
    
    var viewModel: MainMenuViewModelProtocol! {
        didSet {
            viewModel.gamesUpdated = { [weak self] in self?.gamesUpdated() }
            viewModel.signedOut = { [weak self] in self?.signedOut() }
            viewModel.routeToNewMonster = { [weak self] in self?.routeToNewMonster() }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headerViewFactory = SupplementaryViewFactory<MonsterSectionHeader>()
        footerViewFactory = MonsterFooterViewFactory(viewModel: viewModel)

        yourTurn = Section<GameViewModel, YourTurnCell, MonsterSectionHeader, MonsterSectionFooter>(items: [])
        yourTurn.headerViewFactory = headerViewFactory
        yourTurn.footerViewFactory = footerViewFactory
        waiting = Section<GameViewModel, WaitingCell, MonsterSectionHeader, MonsterSectionFooter>(items: [])
        waiting.headerViewFactory = headerViewFactory
        waiting.footerViewFactory = footerViewFactory
        
        monsterDataSource = SectionedArrayDataSource(sections: [yourTurn, waiting])

        monsterCollection.register(YourTurnCell.self)
        monsterCollection.register(WaitingCell.self)
        monsterCollection.dataSource = monsterDataSource
        monsterCollection.delegate = self
        
        let theNib = UINib(nibName: MainMenuBottom.nibName, bundle: NSBundle(forClass: MainMenuBottom.self))
        monsterCollection.registerNib(theNib, forSupplementaryViewOfKind: "MainMenuBottom", withReuseIdentifier: MainMenuBottom.defaultReuseIdentifier)
        
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
            guard let vc = segue.destinationViewController as? DrawingViewController else {
                return
            }
            
            guard let selectedIndex = self.selectedIndex else {
                return
            }

            vc.viewModel = viewModel.getDrawingViewModel(selectedIndex)
        }
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
    }

    @IBAction func signOut(sender: UIButton) {
        viewModel.signOut()
    }

    func gamesUpdated() {
        yourTurn.replaceItems(viewModel.yourTurnGames)
        waiting.replaceItems(viewModel.waitingGames)
        monsterCollection.reloadData()
    }

    func signedOut() {
        performSegueWithIdentifier("ShowLoginScreen", sender: self)
    }

    func routeToNewMonster() {
        performSegueWithIdentifier("NewMonster", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            return
        }
        
        selectedIndex = indexPath.row
        
        performSegueWithIdentifier("goToGame", sender: self)
    }

    // MARK: - UICollectionViewFlowLayout Delegate

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set up desired width
        let targetWidth: CGFloat = (collectionView.bounds.width - 3 * kHorizontalInsets) / 2

        if indexPath.section == 0 {
            var cell: YourTurnCell? = self.offscreenCells[YourTurnCell.defaultReuseIdentifier] as? YourTurnCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed(YourTurnCell.nibName, owner: self, options: nil)[0] as? YourTurnCell
                self.offscreenCells[YourTurnCell.defaultReuseIdentifier] = cell
            }
            
            cell!.configure(yourTurn.items[indexPath.row])
            
            return calculateCellSize(cell!, targetWidth: targetWidth)
        } else {
            var cell: WaitingCell? = self.offscreenCells[WaitingCell.defaultReuseIdentifier] as? WaitingCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed(WaitingCell.nibName, owner: self, options: nil)[0] as? WaitingCell
                self.offscreenCells[WaitingCell.defaultReuseIdentifier] = cell
            }
            cell!.configure(waiting.items[indexPath.row])
            return calculateCellSize(cell!, targetWidth: targetWidth)
        }
    }
    
    private func calculateCellSize(cell: UICollectionViewCell, targetWidth: CGFloat) -> CGSize {
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell.bounds = CGRectMake(0, 0, targetWidth, cell.bounds.height)
        cell.contentView.bounds = cell.bounds
        
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        var size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kVerticalInsets, kHorizontalInsets, kVerticalInsets, kHorizontalInsets)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kHorizontalInsets
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kVerticalInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if monsterDataSource.sections[section].count == 0 {
            return CGSizeZero
        } else {
            return (collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height: 155)
        } else {
            return CGSizeZero
        }
    }
}

