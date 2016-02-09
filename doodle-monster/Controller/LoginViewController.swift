//
//  ViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/9/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginByEmail" {
            if let vc = segue.destinationViewController as? LoginByEmailViewController {
                vc.presenter = appDelegate.viewModelFactory.loginByEmailPresenter(vc)
            }
        }
    }
    
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {
    }

    @IBAction func loginByFacebook(sender: UIButton) {
    }
}

