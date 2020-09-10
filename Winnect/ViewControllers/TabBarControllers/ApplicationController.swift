//
//  ApplicationController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/23/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ApplicationController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var educationField: UITextField!
   
    @IBOutlet weak var subject1Field: UITextField!
    @IBOutlet weak var subject2Field: UITextField!
    @IBOutlet weak var subject3Field: UITextField!
    @IBOutlet weak var subject4Field: UITextField!
    @IBOutlet weak var subject5Field: UITextField!
    @IBOutlet weak var subject6Field: UITextField!
    @IBOutlet weak var subject7Field: UITextField!
    @IBOutlet weak var subject8Field: UITextField!
    @IBOutlet weak var subject9Field: UITextField!
    
    
    @IBOutlet weak var rateField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var subjectFieldArr: [UITextField]?
    var imageChanged:Bool = false
    var imagePicker: UIImagePickerController!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectFieldArr = [subject1Field, subject2Field, subject3Field, subject4Field, subject5Field, subject6Field, subject7Field, subject8Field, subject9Field]
        
        setupUIElements()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func setupUIElements(){
        errorLabel.alpha = 0
        
        for field in subjectFieldArr!{
            Utilities.styleTextField(field)
        }
        
        Utilities.styleTextField(rateField)
        Utilities.styleFilledButton(submitButton)
    }
    
    func showError(_ err:String){
        errorLabel.alpha = 1
        errorLabel.text = err
    }
    
    
    @IBAction func uploadImageTapped(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        if(!CLLocationManager.locationServicesEnabled()){
            let alert = UIAlertController(title: "Error", message: "You Must Enabled Your Location To Submit Application!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        
        
        if(!imageChanged){showError("Please Upload an image before submitting"); return}
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else{showError("Error Submitting Application"); return}
        
        db.collection("applications").document(uid).getDocument(){(document, error) in
            if(error != nil){
                self.showError("Error Submitting Application. Please Try Again.")
            }
            else{
                let appOpen = document?.get("isApplicationOpen") as? Bool
                if appOpen != nil && appOpen! {
                    self.showAlert(title: "Error", message: "You Have Already Submitted An Application!")
                }
                else{
                    let education = self.educationField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    var subjectsArray: [String] = []
                    
                    for field in self.subjectFieldArr! {
                        let text = field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        if (text != ""){
                            subjectsArray.append(text)
                        }
                    }
                    
                    let rate = self.rateField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let uploadImage = self.imageView.image
                    
                    var name:String?
                    self.getFullNameByUID(uid) {(fullName, success) in
                        if fullName != nil, success{
                            name = fullName
                            self.uploadApplicationImage(uploadImage!){ url in
                                if url != nil{
                                    let location = self.locationManager.location
                                    let latitude = location?.coordinate.latitude
                                    let longitude = location?.coordinate.longitude
                                    let geoPoint = GeoPoint(latitude: latitude!, longitude: longitude!)
                                    db.collection("applications").document(uid).setData(["uid":uid, "education":education, "subjects":subjectsArray, "rate": rate, "name": name, "imageURL":url?.absoluteString, "isApplicationOpen": true, "location" : geoPoint]) {error in
                                        if (error != nil){self.showError("Error Submitting Application. Please Try Again."); return}
                                        else {print("APPLICATION SUCCESFULLY SUBMITTED"); self.showAlert(title: "Application Submitted", message: "We Will Get Back To You In 1-2 Days!")}
                                    }
                                }
                                else{self.showError("Error Submitting Application. Please Try Again."); return}
                            }
                            
                        }
                        else {
                            self.showError("Error Submitting Application. Please Try Again.")
                            return
                        }
                    }}
            }
        }
        
        
        
        
        
        
    }
    
    func uploadApplicationImage(_ uploadImage:UIImage, completion: @escaping ((_ url:URL?)->())){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let storageRef = Storage.storage().reference().child("users/\(uid)/applicationImage")
        
        guard let imageData = uploadImage.jpegData(compressionQuality: 0.75) else {completion(nil); return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "img/jpg"
        
        storageRef.putData(imageData, metadata: metadata) {(metadata, error) in
            if (error != nil){
                completion(nil)
                return
            }
            else{
                storageRef.downloadURL(){(url, error) in
                    guard let downloadURL = url else {completion(nil); return}
                    completion(downloadURL)
                }
            }
        }
    }

    
    func getFullNameByUID(_ uid:String, completion: @escaping ((_ name:String?, _ success:Bool)->())){
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument(){(document, error) in
            if error != nil{
                completion(nil, false)
            }
            else{
                guard let firstName = document?.get("firstName") as? String else {completion(nil, false); return}
                guard let lastName = document?.get("lastName") as? String else {completion(nil, false); return}
                completion(firstName + " " + lastName, true)
            }
            
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
      
    }
    
    
}


extension ApplicationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imageView.image = pickedImage
            imageChanged = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}



