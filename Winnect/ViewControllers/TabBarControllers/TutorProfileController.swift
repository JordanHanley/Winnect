//
//  TutorProfileViewController.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/3/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class TutorProfileController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var imagePicker: UIImagePickerController!
    var isTutor: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        initialPFPLoad(){success in
            if success{
                print("Succesfully Loaded User's PFP!")
            }
            
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath == [1,0]){
            
            let alert = UIAlertController(title: "Select Availability Type", message: "Select What Type of Availability You Want To Configure!", preferredStyle: UIAlertController.Style.alert)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            alert.addAction(UIAlertAction(title: "Everyday Availability", style: .default, handler: {(action) in

                let everydayAvailabilityVC = mainStoryboard.instantiateViewController(withIdentifier: "EverydayAvailabilityVC") as! EverdayAvailabilityViewController
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationController?.pushViewController(everydayAvailabilityVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Weekly Availability", style: .default, handler: {(action) in
                let weeklyAvailabilityVC = mainStoryboard.instantiateViewController(withIdentifier: "WeeklyAvailabilityVC") as! WeeklyAvailabilityViewController
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationController?.pushViewController(weeklyAvailabilityVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Specific Day Availability", style: .default, handler: {(action)in
                let specificAvailabilityCalendarVC = mainStoryboard.instantiateViewController(withIdentifier: "SpecificAvailabilityCalendarVC") as! SpecificAvailabilityCalendarViewController
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationController?.pushViewController(specificAvailabilityCalendarVC, animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if(indexPath == [1,1]){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let editBiographyVC = mainStoryboard.instantiateViewController(withIdentifier: "EditBiographyVC") as! EditBiographyController
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(editBiographyVC, animated: true)
        }
        
        if(indexPath == [1,2]){
            let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                self.navigationController?.popToRootViewController(animated: false)
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let initialVC = mainStoryboard.instantiateViewController(withIdentifier: "InitialVC") as! InitialViewController
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationController?.pushViewController(initialVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        if(indexPath == [2,0]){
            if(isTutor != nil){
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if(!isTutor!){
                    guard let applicationVC = mainStoryboard.instantiateViewController(withIdentifier: "ApplicationVC") as? ApplicationController else{ print("Couldn't Instantiate ApplicationVC!"); return}
                    
                    self.navigationController?.pushViewController(applicationVC, animated: true)
                }
                
            }
        }
        
    }
    
    
    @IBAction func changePFPTapped(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("users/\(uid)/pfp")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "img/jpg"
        
        storageRef.putData(imageData, metadata: metaData) {metadata, error in
            if(error == nil){
                guard let metadata = metadata else {return}
                storageRef.downloadURL{url,error in
                    if(error == nil){
                        guard let downloadURL = url else {completion(nil); return}
                        completion(downloadURL)
                        
                    }
                    else {print(error!.localizedDescription); completion(nil); return}
                }
                
            }
            else {print(error!.localizedDescription); completion(nil); return}
        }
    }
    
    func saveProfile(profileImageURL:URL, completion: @escaping ((_ success:Bool) -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let userDataRef = db.collection("users").document(uid)
        
        userDataRef.updateData(["pfpURL":profileImageURL.absoluteString]) {error in
            if error != nil {
                print("Couldn't update user pfpurl")
                print(error!.localizedDescription)
            }
            else {completion(true)}
        }
    }
    
    func initialPFPLoad(completion: @escaping ((_ success:Bool) -> ())){
        guard let uid = Auth.auth().currentUser?.uid else {completion(false); return}
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument(source: .cache){ (document, error) in
            if let document = document{
                self.nameLabel.text = (document.get("firstName") as? String)! + " " + (document.get("lastName") as! String)
                if(document.get("isTutor") as! Bool){
                    self.isTutor = true
                    
                }
                else{
                    self.isTutor = false
                    
                }
                let url = document.get("pfpURL") as? String
                if url == "nil" || url == nil{
                    completion(false)
                    return
                }
                else{
                    
                    self.getData(from: URL(string: url!)!) {data, response, error in
                        guard let data = data, error == nil else {completion(false); return}
                        print(response?.suggestedFilename ?? URL(string: url!)!.lastPathComponent)
                        DispatchQueue.main.async {
                            [weak self] in
                            self?.profileImageView.image = UIImage(data: data)
                        }
                        
                    }
                    
                }
            }
            else{
                print("Couldn't Retrieve document!")
                completion(false)
                return
            }
        }
    }
    
}


extension TutorProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImageView.image = pickedImage
            uploadProfileImage(self.profileImageView.image!) {url in
                guard let url = url else {return}
                self.saveProfile(profileImageURL: url) {success in
                    if success{
                        print("Saved PFP!")
                    }
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

