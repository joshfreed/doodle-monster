//
//  InviteByEmailViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class InviteByEmailViewController: UIViewController, InviteByEmailView {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var playersTable: UITableView!
    
    var viewModel: InviteByEmailViewModelProtocol!
    var dataSource: ArrayDataSource<PlayerTableViewCell, PlayerViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = ArrayDataSource<PlayerTableViewCell, PlayerViewModel>(items: [], cellIdentifier: "PlayerCell")

        playersTable.dataSource = dataSource
        playersTable.delegate = self
        searchTextField.addTarget(self, action: #selector(InviteByEmailViewController.searchTextDidChange), for: .editingChanged)
        searchTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchTextDidChange() {
        viewModel.search(searchTextField.text!)
    }

    func displaySearchResults() {
        dataSource.replaceItems(viewModel.players)
        playersTable.reloadData()
    }
    
    func displaySearchError() {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

// MARK: - UITableViewDelegate
extension InviteByEmailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectPlayer(indexPath)
        self.performSegue(withIdentifier: "CloseInviteByEmail", sender: self)
    }
}

