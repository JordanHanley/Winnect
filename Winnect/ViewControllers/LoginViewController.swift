//
//  LoginViewController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/14/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        styleElements()
        errorLabel.alpha = 0
    }
    
    func styleElements() -> Void{
        Utilities.styleTextField(emailAddressTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        let err = validateFields()
        if(err != nil){
            showError(err!)
            return
        }
        let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
            if(error != nil){
                if((error! as NSError).code == 17011 || (error! as NSError).code == 17009){
                    self.showError("Invalid Email or Password")
                }
                else{
                    self.showError("Error Sigining In. Please Try Again.")
                }
            }
            else{self.transistionToMainVC()}
            
        }
            
            
        
    }
    
    
    
    func validateFields() -> String? {
        
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please Fill in All Fields"
        }
        
        return nil
    }
    
    func showError(_ err:String) -> Void{
        errorLabel.alpha = 1
        errorLabel.text = err
    }
    
    func transistionToMainVC() -> Void{
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as? MainViewController else{ print("Couldn't Instantiate HomeVC!"); return}
        
        self.navigationController?.pushViewController(mainVC, animated: true)
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
