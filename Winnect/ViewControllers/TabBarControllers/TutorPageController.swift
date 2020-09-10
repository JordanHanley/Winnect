//
//  TutorPageController.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/1/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class TutorPageController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directMessageButton: UIButton!
    @IBOutlet weak var requestAppointmentButton: UIButton!
    @IBOutlet weak var subjectsIconImage: UIImageView!
    @IBOutlet weak var rateIconImage: UIImageView!
    @IBOutlet weak var educationIconImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var subjectsLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    
    var profileImage: UIImage?
    var educationText: String?
    var subjectsText: String?
    var rateText: String?
    var nameText: String?
    var uid: String?
    var bioText: String?
    var userPFP: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupElements()
        getCurrentUserPFP()
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getCurrentUserPFP(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument(source: .cache){ (document, error) in
            if let document = document{
                let url = document.get("pfpURL") as? String
                if url == "nil" || url == nil{
                    return
                }
                else{
                    
                    self.getData(from: URL(string: url!)!) {data, response, error in
                        guard let data = data, error == nil else {return}
                        print(response?.suggestedFilename ?? URL(string: url!)!.lastPathComponent)
                        DispatchQueue.main.async {
                            [weak self] in
                            self?.userPFP = UIImage(data: data)
                        }
                        
                    }
                    
                }
            }
            else{
                print("Couldn't Retrieve document!")
                return
            }
        }
    }
    
    func setupElements(){
        Utilities.styleFilledButton(directMessageButton)
        Utilities.styleFilledButton(requestAppointmentButton)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        
        profileImageView.image = profileImage
        educationLabel.text = educationText
        subjectsLabel.text = subjectsText
        rateLabel.text = rateText
        nameLabel.text = nameText
        
      
        
        if(bioText != nil){
            bioLabel.text = bioText
        }
    }
    
    @IBAction func appointmentRequestTapped(_ sender:
        Any) {
        if (uid == Auth.auth().currentUser?.uid){
            let alert = UIAlertController(title: "Error", message: "You cannot request an appointment for yourself!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default){(action) in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let appointmentVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentVC") as! AppointmentController
        appointmentVC.uid = uid
        self.navigationController?.pushViewController(appointmentVC, animated: true)
    }
    
    
    @IBAction func dmButtonTapped(_ sender: Any) {
        //let vc = DirectMessageController()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageController
        vc.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "Me", pfp: self.userPFP)
        vc.messagedUser = Sender(senderId: uid!, displayName: nameText!, pfp: profileImageView.image)
        vc.navigationItem.title = nameText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
