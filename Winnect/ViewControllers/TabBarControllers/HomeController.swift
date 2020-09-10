//
//  HomeController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/19/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController, CLLocationManagerDelegate {
    
    var tutorCells: [TutorCell] = []
    let locationManager = CLLocationManager()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadTutorCells(5)
       /*
        let db = Firestore.firestore()
        var storageRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        storageRef.updateData(["firstName":"John", "lastName":"Williams"])
        storageRef = db.collection("tutors").document(Auth.auth().currentUser!.uid)
        storageRef.updateData(["name":"John Williams"])
 */
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        //print(self.locationManager.location?.coordinate.latitude)
        //print(self.locationManager.location?.coordinate.longitude)
        
    }
    
    func setupTutorCell(cell: TutorCell){
        let uid = cell.uid
        if uid != nil{
            let db = Firestore.firestore()
            let tutorRef = db.collection("tutors").document(uid!)
            
            tutorRef.getDocument(source: .cache){ (document,error) in
                if error != nil{
                    print("Couldnt get tutor document")
                    return
                }
                else{
                
                    cell.nameLabel.text = document?.get("name") as? String
                    cell.educationLabel.text = "" + (document?.get("education") as? String ?? "")
                    cell.rateLabel.text = "$"+(document?.get("rate") as? String ?? "")+"/h"
                    cell.bioText = document?.get("bioText") as? String
                    cell.bottomView.layer.borderWidth = 2
                    cell.bottomView.layer.borderColor = UIColor.black.cgColor
                    cell.bottomView.layer.backgroundColor = UIColor.white.cgColor
                    
                    if(CLLocationManager.locationServicesEnabled()){
                        let userLoc = self.locationManager.location
                        let tutorCoords = document?.get("location") as! GeoPoint
                        let tutorLoc = CLLocation(latitude: tutorCoords.latitude, longitude: tutorCoords.longitude)
                        let distance = (userLoc?.distance(from: tutorLoc))!/1000.0
                        cell.showGPSDistance("\(String(format: "%.1f", distance)) miles away")
                    }
                    
                    var subjects:String = ""
                    for subject in document?.get("subjects") as! [String]{
                        subjects = subjects + "\(subject), "
                    }
                    subjects.removeLast()
                    subjects.removeLast()
                    cell.subjectsLabel.text = subjects
                    self.loadProfilePicture(cell: cell){success in
                        if success {
                            print("Succesfully Loaded Profile Picture!")
                        }
                        else{
                            print("Unsuccesfully Tried To Load Profile Picture!")
                        }
                    }
                    
                   // self.tutors.append(tutor)
                }
                
                
            }
            
        }
        else {
            print("uid was null!")
            return
        }
    }
    
    func loadTutorCells(_ numOfCells:Int) {
        for _ in 1...numOfCells{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorCell") as! TutorCell
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.topView.backgroundColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        cell.topView.layer.cornerRadius = 10
        cell.bottomView.layer.cornerRadius = 10
        // get list of tutor ids
        // ensure that the tutor id is not already in the array
        let db = Firestore.firestore()
        db.collection("tutors").getDocuments(){(snapshot, error) in
            
            if error != nil{
                print("couldnt get tutor list")
                return
            }
            else{
                for document in snapshot!.documents{
                    let curr_uid = document.get("uid") as! String?
                    var uidInUse: Bool = false
                    
                    for cell in self.tutorCells{
                        if cell.uid == curr_uid{
                            uidInUse = true
                            break
                        }
                    }
                    if(!uidInUse){
                        cell.uid = curr_uid
                        self.tutorCells.append(cell)
                        cell.parentViewController = self
                        print("assigning uid to cell")
                        self.setupTutorCell(cell: cell)
                        self.tableView.reloadData()
                        break
                    }
                }
                
            }
        }
        
        }
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func loadProfilePicture(cell:TutorCell, completion: @escaping ((_ success:Bool) -> ())){
        guard let uid = cell.uid else {completion(false); return}
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
                            cell.profileImage.image = UIImage(data: data)
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


extension HomeController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorCells.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tutorCells[indexPath.row]
    }
    
}



