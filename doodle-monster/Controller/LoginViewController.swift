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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginByEmail" {
            if let vc = segue.destination as? LoginByEmailViewController {
                vc.presenter = appDelegate.viewModelFactory.loginByEmailPresenter(vc)
            }
        }
    }
    
    @IBAction func unwindToLoginScreen(_ segue: UIStoryboardSegue) {
    }

    @IBAction func loginByFacebook(_ sender: UIButton) {
    }
}

