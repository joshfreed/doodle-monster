//
//  CreateAccountViewController.swift
//  doodle-monster
//
//  Created by Josh Freed on 12/14/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, CreateAccountView {
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailAddressLabel: UILabel!

    var presenter: CreateAccountViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CreateAccountView

    func goToMainMenu() {
        performSegueWithIdentifier("MainMenu", sender: self)
    }
    
    func showCreateAccountError() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions
    
    @IBAction func createAccount(sender: UIButton) {
        guard let
            displayName = displayNameTextField.text,
            confirmPassword = confirmPasswordTextField.text else
        {
            return
        }
        
        presenter.createAccount(displayName, confirmPassword: confirmPassword)
    }
}
