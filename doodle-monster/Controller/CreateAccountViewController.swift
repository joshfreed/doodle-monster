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

        presenter.showUsername()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CreateAccountView

    func goToMainMenu() {
        performSegue(withIdentifier: "MainMenu", sender: self)
    }
    
    func showCreateAccountError() {
        
    }
    
    func setUsername(_ username: String) {
        emailAddressLabel.text = username
    }

//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "MainMenu" {
//            if let vc = segue.destination as? MainMenuViewController {
//                vc.viewModel = appDelegate.viewModelFactory.mainMenuViewModel(vc)
//            }
//        }
//    }

    // MARK: - Actions
    
    @IBAction func createAccount(_ sender: UIButton) {
        guard let
            displayName = displayNameTextField.text,
            let confirmPassword = confirmPasswordTextField.text else
        {
            return
        }
        
        presenter.createAccount(displayName, confirmPassword: confirmPassword)
    }
}
