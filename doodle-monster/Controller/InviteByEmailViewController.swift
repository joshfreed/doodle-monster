//
//  InviteByEmailViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/23/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class InviteByEmailViewController: UIViewController, UITextFieldDelegate {
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
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - InviteByEmailView
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let updatedTextString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        viewModel.search(updatedTextString)
        return true
    }
}

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