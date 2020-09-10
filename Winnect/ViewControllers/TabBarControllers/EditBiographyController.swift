//
//  EditBiographyController.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/21/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class EditBiographyController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    let CharacterLimit = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        Utilities.styleFilledButton(saveButton)
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1).cgColor
        errorLabel.alpha = 0
        loadBio()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text == nil){return}
        if(textView.text!.count > CharacterLimit){
            textView.layer.borderColor = UIColor.red.cgColor
            errorLabel.alpha = 1
        }
        else{
            textView.layer.borderColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1).cgColor
            errorLabel.alpha = 0
        }
    }
    
    func loadBio(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid)
        
        storageRef.getDocument(){(document, error) in
            if (error != nil){
                let alert = UIAlertController(title: "Error", message: "Couldn't Load Bio! Please Try Again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else{
                let bioText = document?.get("bioText") as? String
                if(bioText != nil){
                    self.textView.text = bioText
                }
                
            }
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if(textView.text!.count > CharacterLimit){return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid)
        storageRef.updateData(["bioText" : textView.text]) { (error) in
            if(error != nil){
                let alert = UIAlertController(title: "Error", message: "Couldn't Save Bio! Please Try Again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                
                }))
                self.present(alert, animated: true)
            }
            else{
                let alert = UIAlertController(title: "Success", message: "Saved Bio!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
  
}
