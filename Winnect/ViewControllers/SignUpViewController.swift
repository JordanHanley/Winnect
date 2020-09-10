//
//  SignUpViewController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/14/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var emailAddressConfirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        styleElements()
        errorLabel.alpha = 0
    }
    

    func styleElements() -> Void{
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailAddressTextField)
        Utilities.styleTextField(emailAddressConfirmTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(passwordConfirmTextField)
        Utilities.styleFilledButton(signupButton)
    }
    
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let err = validateFields()
        if (err != nil){
            showError(err!)
        }
        else{
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailAddress = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, err) in
                if (err != nil){
                    
                    if((err! as NSError).code == 17007){
                        self.showError("Email Already Registered")
                    }
                    else{
                        self.showError("Error Creating User. Please Try Again.")
                        print(err!.localizedDescription)
                    }
                }
                else{
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["firstName":firstName, "lastName":lastName, "uid":result!.user.uid, "isTutor": false,"pfpURL":"nil"]) { (error) in
                        if (error != nil){
                            self.showError("Error Submitting User Data")
                        }
                        else{
                            self.transistionToMainVC()
                        }
                        
                    }
                }
                
                
            }
        }
        
    }
    
    func validateFields() -> String? {
        if (firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            || (lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            || (emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            || (emailAddressConfirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            || (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            || (passwordConfirmTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
            return "Please Fill in All Fields"
        }
        
        if !(emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).contains("@")){
            return "Please Enter A Valid Email"
        }
        
        let acceptedExtensions = [".com",".org",".gov",".info",".win",".io",".info",".net",".co",".uk",".biz",".us",".me"]
        
        var validExtension = false
        for ext in acceptedExtensions{
            if emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).contains(ext){
                validExtension = true
        
            }
        }
        if (!validExtension){
            return "Please Enter A Valid Email"
        }
        
        if(emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) !=
            (emailAddressConfirmTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return "Email Addresses Do Not Match"
        }
        
        let cleanedPass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !(Utilities.isPasswordValid(cleanedPass)){
            return "Password Requirements:\n-8 Characters\n-Contains A Number\n-Contains A Special Character ($@$#!%*?&)\n-Contains Uppercase Letter\n-Contains Lowercase Letter"
        }
        
        if (cleanedPass != passwordConfirmTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return "Passwords Do Not Match"
        }
        
        return nil
    }
    
    
    func showError(_ err:String){
        errorLabel.alpha = 1
        errorLabel.text = err
    }
    
    func transistionToMainVC(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as? MainViewController else{
            print("ERROR: Couldn't instantiate MainVC")
            return
        }
        //homeVC.modalTransitionStyle = .coverVertical
        //performSegue(withIdentifier: "show", sender: nil)
        self.navigationController!.pushViewController(mainVC, animated: true)
    }
    
    
    
}
