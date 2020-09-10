//
//  InitialViewController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/14/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase
class InitialViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        styleElements()
       /*
        let db = Firestore.firestore()
        let storageRef = db.collection("users").document("f5IqTHDo4pdv57YMp5FsJFInwG52").collection("appointments").document("0Gvei9hlDNBMF9sCzY46")
        storageRef.getDocument(){(doc, error) in
            let name = doc?.get("name") as? String
            let date = doc?.get("date") as? String
            let pfpURL = doc?.get("pfpURL") as? String
            let rate = doc?.get("rate") as? Int
            let timeBlock = doc?.get("timeBlock") as? Int
            let tutorUID = doc?.get("tutorUID") as? String
            
            for _ in 1...5{
                let uploadRef = db.collection("users").document("cxEocPS9lRRFtDDnCTCA9K2YuaE3").collection("appointments")
                uploadRef.addDocument(data: ["name":name, "date":date, "pfpURL":"https://firebasestorage.googleapis.com/v0/b/winnect-7b291.appspot.com/o/users%2Ff5IqTHDo4pdv57YMp5FsJFInwG52%2Fpfp?alt=media&token=28617487-0a29-40f7-b409-81be599f31f8", "rate":rate, "timeBlock":timeBlock, "tutorUID":tutorUID])
            }
        }*/
        
        
    }
    

    
    func styleElements() -> Void{
        Utilities.styleHollowButton(loginButton)
        Utilities.styleFilledButton(signupButton)
    }
    
   

}
