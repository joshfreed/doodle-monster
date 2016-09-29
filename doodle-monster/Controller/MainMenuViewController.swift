//
//  MainMenuViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UICollectionViewDelegate, RoutedSegue, MainMenuView {
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
    var refreshControl: UIRefreshControl!
    var spinner: UIActivityIndicatorView!

    var segues: [String: Segue] = [:]

    var viewModel: MainMenuViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = appDelegate.viewModelFactory.mainMenuViewModel(self)
        
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
        monsterCollection.alwaysBounceVertical = true // required to make pull down refresh work when list is smaller than screen
        monsterCollection.accessibilityActivate()
        monsterCollection.accessibilityIdentifier = "monsterCollection"
        
        let theNib = UINib(nibName: MainMenuBottom.nibName, bundle: Bundle(for: MainMenuBottom.self))
        monsterCollection.register(theNib, forSupplementaryViewOfKind: "MainMenuBottom", withReuseIdentifier: MainMenuBottom.defaultReuseIdentifier)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainMenuViewController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        monsterCollection.addSubview(refreshControl)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        monsterCollection.backgroundView = spinner
        spinner.startAnimating();
        viewModel.loadItems()

        navigationItem.hidesBackButton = true
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
    
    // MARK: - IBActions

    @IBAction func unwindToMainMenu(_ segue: UIStoryboardSegue) {
    }

    @IBAction func signOut(_ sender: UIButton) {
        viewModel.signOut()
    }

    func onRefresh(_ sender: UIRefreshControl!) {
        viewModel.refresh()
    }
    
    // MARK: - MainMenuView
    
    func updateGameList() {
        refreshControl.endRefreshing()
        spinner.stopAnimating();
        monsterCollection.backgroundView = nil
        
        yourTurn.replaceItems(viewModel.yourTurnGames)
        waiting.replaceItems(viewModel.waitingGames)
        monsterCollection.reloadData()
    }
    
    func showServerError(_ err: Error) {
        showErrorAlert(err, title: nil)
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            return
        }
        
        viewModel.selectGame((indexPath as NSIndexPath).row)
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set up desired width
        let targetWidth: CGFloat = (collectionView.bounds.width - 3 * kHorizontalInsets) / 2

        if (indexPath as NSIndexPath).section == 0 {
            var cell: YourTurnCell? = self.offscreenCells[YourTurnCell.defaultReuseIdentifier] as? YourTurnCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed(YourTurnCell.nibName, owner: self, options: nil)?[0] as? YourTurnCell
                self.offscreenCells[YourTurnCell.defaultReuseIdentifier] = cell
            }
            
            cell!.configure(yourTurn.items[(indexPath as NSIndexPath).row])
            
            return calculateCellSize(cell!, targetWidth: targetWidth)
        } else {
            var cell: WaitingCell? = self.offscreenCells[WaitingCell.defaultReuseIdentifier] as? WaitingCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed(WaitingCell.nibName, owner: self, options: nil)?[0] as? WaitingCell
                self.offscreenCells[WaitingCell.defaultReuseIdentifier] = cell
            }
            cell!.configure(waiting.items[(indexPath as NSIndexPath).row])
            return calculateCellSize(cell!, targetWidth: targetWidth)
        }
    }
    
    fileprivate func calculateCellSize(_ cell: UICollectionViewCell, targetWidth: CGFloat) -> CGSize {
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: cell.bounds.height)
        cell.contentView.bounds = cell.bounds
        
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        var size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kVerticalInsets, kHorizontalInsets, kVerticalInsets, kHorizontalInsets)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kHorizontalInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kVerticalInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if monsterDataSource.sections[section].count == 0 {
            return CGSize.zero
        } else {
            return (collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height: 155)
        } else {
            return CGSize.zero
        }
    }
}

