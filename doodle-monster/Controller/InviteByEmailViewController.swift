//
//  InviteByEmailViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class InviteByEmailViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var playersTable: UITableView!
    
    var viewModel: InviteByEmailViewModelProtocol! {
        didSet {
            self.viewModel.playersDidChange = { viewModel in
                self.playersTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playersTable.dataSource = self
        playersTable.delegate = self
        searchTextField.addTarget(self, action: "searchTextDidChange", forControlEvents: .EditingChanged)
        searchTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchTextDidChange() {
        viewModel.search(searchTextField.text!)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}

// MARK: - UITableViewDataSource
extension InviteByEmailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell") as! PlayerTableViewCell
        cell.configure(viewModel.playerAt(indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension InviteByEmailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.selectPlayer(indexPath)
        self.performSegueWithIdentifier("CloseInviteByEmail", sender: self)
    }
}

