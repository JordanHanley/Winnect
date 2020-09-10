//
//  NotificationsController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/25/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class NotificationsController: UIViewController {
    
    var notificationCells: [NotificationCell] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadNotifications(5)
    }
    
    func loadNotifications(_ numOfCells: Int){
        for _ in 1...numOfCells{
            guard let uid = Auth.auth().currentUser?.uid else{return}
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
            
            let db = Firestore.firestore()
            
            let notificationRef = db.collection("users").document(uid).collection("notifications")
            
            notificationRef.getDocuments(){(snapshot, error) in
                if error != nil{
                    print("Couldn't Get Notifications!")
                }
                else{
                    for document in snapshot!.documents{
                        let docID = document.documentID
                        var containsDocID: Bool = false
                        for cell in self.notificationCells{
                            if (cell.notificationID == docID){containsDocID = true}
                        }
                        if(!containsDocID){
                            cell.titleLabel.text = document.get("title") as? String
                            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
                            cell.bodyLabel.text = document.get("body") as? String
                            cell.notificationID = docID
                            let uid = document.get("pfpUID") as? String
                            if(uid != nil) {self.loadCellPFP(cell: cell, uid: uid!)}
                            self.notificationCells.append(cell)
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
    
    func loadCellPFP(cell: NotificationCell, uid: String){
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
                            cell.profileImage.image = UIImage(data: data)
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
    
    
}

extension NotificationsController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return notificationCells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
