//
//  ProfileController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/17/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {

    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var tutorButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    var isTutor: Bool?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.size.width/2
        ProfilePicture.clipsToBounds = true
        
        Utilities.styleFilledButton(tutorButton)
        createTutorButton()
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        initialPFPLoad(){success in
            if success{
                print("Succesfully Loaded User's PFP!")
            }
        }
        
        //let db = Firestore.firestore()
        //let userDataRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        //userDataRef.updateData(["isTutor":true]) {error in}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
    @IBAction func uploadTapped(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func tutorButtonTapped(_ sender: Any) {
        if(isTutor != nil){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if(!isTutor!){
                guard let applicationVC = mainStoryboard.instantiateViewController(withIdentifier: "ApplicationVC") as? ApplicationController else{ print("Couldn't Instantiate ApplicationVC!"); return}
                
                self.navigationController?.pushViewController(applicationVC, animated: true)
            }
            else{
                guard let tutorProfileVC = mainStoryboard.instantiateViewController(withIdentifier: "TutorProfileVC") as? TutorProfileController else {return}
                //tutorProfileVC.profilePicture = ProfilePicture.image
                //tutorProfileVC.name = self.name
                self.navigationController?.pushViewController(tutorProfileVC, animated: true)
            }
        }
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
    
    func createTutorButton(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument(source: .cache) {(document, error) in
            if error != nil{
                print("Couldn't get user doc!")
                return
            }
            else{
                self.isTutor = document?.get("isTutor") as? Bool
                let firstName = document?.get("firstName") as? String
                let lastName = document?.get("lastName") as? String
                self.name = firstName! + " " + lastName!
                
                if(self.isTutor != nil){
                    if(self.isTutor!){
                        self.tutorButton.setTitle("View Tutor Profile", for: .normal)
                    }
                    else{
                        self.tutorButton.setTitle("Sign Up For Tutor Account", for: .normal)
                    }
                }
                else{
                    print("isTutor came back null!")
                    return
                }
            }
            
        }
        
    }
    
    
    func initialPFPLoad(completion: @escaping ((_ success:Bool) -> ())){
        guard let uid = Auth.auth().currentUser?.uid else {completion(false); return}
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument(source: .cache){ (document, error) in
            if let document = document{
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
                            self?.ProfilePicture.image = UIImage(data: data)
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
   
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.ProfilePicture.image = pickedImage
            uploadProfileImage(self.ProfilePicture.image!) {url in
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

