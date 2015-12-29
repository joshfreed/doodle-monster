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

    var viewModel: NewMonsterViewModelProtocol! {
        didSet {
            self.viewModel.playerWasAdded = { viewModel in
                let view = UIStackView()
                view.axis = UILayoutConstraintAxis.Horizontal
                
                let displayNameLabel = UILabel()
                displayNameLabel.text = viewModel.displayName
                view.addArrangedSubview(displayNameLabel)
                
                let emailAddressLabel = UILabel()
                emailAddressLabel.text = viewModel.email
                view.addArrangedSubview(emailAddressLabel)
                
                self.stackView.insertArrangedSubview(view, atIndex: 1)
            }
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
                vc.viewModel = viewModel.invitePlayerByEmail()
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
}
