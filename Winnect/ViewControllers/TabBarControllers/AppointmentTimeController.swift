//
//  AppointmentTimeController.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/2/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase

class AppointmentTimeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    
    var unavailableTimeBlocks: [Int] = []
    var timeCells: [TimeCell] = []
    var date: Date?
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM dd"
        let dateStr = dateFormatter.string(from: date!)
        navigationTitle.title = "\(dateStr)"
        
        createTimeCells()
        loadUnavailability()
    }
    
    
    func loadUnavailability(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let db = Firestore.firestore()
        let everydayRef = db.collection("tutors").document(uid!).collection("unavailabilities").document("everyday")
        let weeklyRef = db.collection("tutors").document(uid!).collection("unavailabilities").document("weekly")
        let specificRef = db.collection("tutors").document(uid!).collection("unavailabilities").document("specificDay")
        
        everydayRef.getDocument(source: .cache) {(document, error) in
            if error != nil{
                self.showLoadingErrorAlert()
            }
            else{
                let arr = document?.get("timeBlocks") as? [Int]
                if(arr != nil){
                    for timeBlock in arr!{
                        self.unavailableTimeBlocks.append(timeBlock)
                        self.timeCells[timeBlock].disabled = true
                        self.timeCells[timeBlock].selectionStyle = .none
                    }
                }
            }
        }
        let weekday = dateFormatter.string(from: self.date!).lowercased()
        
        weeklyRef.getDocument(source: .cache) {(document, error) in
            if error != nil{
                self.showLoadingErrorAlert()
            }
            else{
                let arr = document?.get(weekday) as? [Int]
                if(arr != nil){
                    for timeBlock in arr!{
                        self.unavailableTimeBlocks.append(timeBlock)
                        self.timeCells[timeBlock].disabled = true
                        self.timeCells[timeBlock].selectionStyle = .none
                    }
                }
            }
        }
        
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        
        specificRef.getDocument(source: .cache) {(document, error) in
            if error != nil{
                self.showLoadingErrorAlert()
            }
            else{
                let arr = document?.get(dateFormatter.string(from: self.date!)) as? [Int]
                if (arr != nil){
                    for timeBlock in arr!{
                        self.unavailableTimeBlocks.append(timeBlock)
                        self.timeCells[timeBlock].disabled = true
                        self.timeCells[timeBlock].selectionStyle = .none
                    }
                }
                for timeBlock in self.unavailableTimeBlocks{
                    self.timeCells[timeBlock].disabled = true
                    self.timeCells[timeBlock].timeLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                    self.timeCells[timeBlock].enabledLabel.text = "- disabled"
                    self.timeCells[timeBlock].enabledLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                    
                }
            }
        }
        
    }
    
    func showLoadingErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "Error Loading Tutor Availability! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    
    func showAlert(title: String, message:String, timeBlock:Int){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            self.requestAppointment(timeBlock: timeBlock)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func requestAppointment(timeBlock:Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        let uploadDate = dateFormatter.string(from: date!)
        
        let db = Firestore.firestore()
        
        db.collection("tutors").document(uid!).collection("appointmentRequests").addDocument(data: ["requesterUID": userUID, "date": uploadDate, "timeBlock": timeBlock]) {(error) in
            
            if error == nil{
                let alert = UIAlertController(title: "Success", message: "Succesfully Requested Appointment!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Couldn't Request Appointment. Please Try Again Later!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    
    func createTimeCells(){
        for num in 1...96{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
            cell.timeBlock = num - 1
            timeCells.append(cell)
        }
        tableView.reloadData()
        timeCells[0].timeLabel.text = "12:00 AM"
        timeCells[1].timeLabel.text = "12:15 AM"
        timeCells[2].timeLabel.text = "12:30 AM"
        timeCells[3].timeLabel.text = "12:45 AM"
        timeCells[4].timeLabel.text = "1:00 AM"
        timeCells[5].timeLabel.text = "1:15 AM"
        timeCells[6].timeLabel.text = "1:30 AM"
        timeCells[7].timeLabel.text = "1:45 AM"
        timeCells[8].timeLabel.text = "2:00 AM"
        timeCells[9].timeLabel.text = "2:15 AM"
        timeCells[10].timeLabel.text = "2:30 AM"
        timeCells[11].timeLabel.text = "2:45 AM"
        timeCells[12].timeLabel.text = "3:00 AM"
        timeCells[13].timeLabel.text = "3:15 AM"
        timeCells[14].timeLabel.text = "3:30 AM"
        timeCells[15].timeLabel.text = "3:45 AM"
        timeCells[16].timeLabel.text = "4:00 AM"
        timeCells[17].timeLabel.text = "4:15 AM"
        timeCells[18].timeLabel.text = "4:30 AM"
        timeCells[19].timeLabel.text = "4:45 AM"
        timeCells[20].timeLabel.text = "5:00 AM"
        timeCells[21].timeLabel.text = "5:15 AM"
        timeCells[22].timeLabel.text = "5:30 AM"
        timeCells[23].timeLabel.text = "5:45 AM"
        timeCells[24].timeLabel.text = "6:00 AM"
        timeCells[25].timeLabel.text = "6:15 AM"
        timeCells[26].timeLabel.text = "6:30 AM"
        timeCells[27].timeLabel.text = "6:45 AM"
        timeCells[28].timeLabel.text = "7:00 AM"
        timeCells[29].timeLabel.text = "7:15 AM"
        timeCells[30].timeLabel.text = "7:30 AM"
        timeCells[31].timeLabel.text = "7:45 AM"
        timeCells[32].timeLabel.text = "8:00 AM"
        timeCells[33].timeLabel.text = "8:15 AM"
        timeCells[34].timeLabel.text = "8:30 AM"
        timeCells[35].timeLabel.text = "8:45 AM"
        timeCells[36].timeLabel.text = "9:00 AM"
        timeCells[37].timeLabel.text = "9:15 AM"
        timeCells[38].timeLabel.text = "9:30 AM"
        timeCells[39].timeLabel.text = "9:45 AM"
        timeCells[40].timeLabel.text = "10:00 AM"
        timeCells[41].timeLabel.text = "10:15 AM"
        timeCells[42].timeLabel.text = "10:30 AM"
        timeCells[43].timeLabel.text = "10:45 AM"
        timeCells[44].timeLabel.text = "11:00 AM"
        timeCells[45].timeLabel.text = "11:15 AM"
        timeCells[46].timeLabel.text = "11:30 AM"
        timeCells[47].timeLabel.text = "11:45 AM"
        timeCells[48].timeLabel.text = "12:00 PM"
        timeCells[49].timeLabel.text = "12:15 PM"
        timeCells[50].timeLabel.text = "12:30 PM"
        timeCells[51].timeLabel.text = "12:45 PM"
        timeCells[52].timeLabel.text = "1:00 PM"
        timeCells[53].timeLabel.text = "1:15 PM"
        timeCells[54].timeLabel.text = "1:30 PM"
        timeCells[55].timeLabel.text = "1:45 PM"
        timeCells[56].timeLabel.text = "2:00 PM"
        timeCells[57].timeLabel.text = "2:15 PM"
        timeCells[58].timeLabel.text = "2:30 PM"
        timeCells[59].timeLabel.text = "2:45 PM"
        timeCells[60].timeLabel.text = "3:00 PM"
        timeCells[61].timeLabel.text = "3:15 PM"
        timeCells[62].timeLabel.text = "3:30 PM"
        timeCells[63].timeLabel.text = "3:45 PM"
        timeCells[64].timeLabel.text = "4:00 PM"
        timeCells[65].timeLabel.text = "4:15 PM"
        timeCells[66].timeLabel.text = "4:30 PM"
        timeCells[67].timeLabel.text = "4:45 PM"
        timeCells[68].timeLabel.text = "5:00 PM"
        timeCells[69].timeLabel.text = "5:15 PM"
        timeCells[70].timeLabel.text = "5:30 PM"
        timeCells[71].timeLabel.text = "5:45 PM"
        timeCells[72].timeLabel.text = "6:00 PM"
        timeCells[73].timeLabel.text = "6:15 PM"
        timeCells[74].timeLabel.text = "6:30 PM"
        timeCells[75].timeLabel.text = "6:45 PM"
        timeCells[76].timeLabel.text = "7:00 PM"
        timeCells[77].timeLabel.text = "7:15 PM"
        timeCells[78].timeLabel.text = "7:30 PM"
        timeCells[79].timeLabel.text = "7:45 PM"
        timeCells[80].timeLabel.text = "8:00 PM"
        timeCells[81].timeLabel.text = "8:15 PM"
        timeCells[82].timeLabel.text = "8:30 PM"
        timeCells[83].timeLabel.text = "8:45 PM"
        timeCells[84].timeLabel.text = "9:00 PM"
        timeCells[85].timeLabel.text = "9:15 PM"
        timeCells[86].timeLabel.text = "9:30 PM"
        timeCells[87].timeLabel.text = "9:45 PM"
        timeCells[88].timeLabel.text = "10:00 PM"
        timeCells[89].timeLabel.text = "10:15 PM"
        timeCells[90].timeLabel.text = "10:30 PM"
        timeCells[91].timeLabel.text = "10:45 PM"
        timeCells[92].timeLabel.text = "11:00 PM"
        timeCells[93].timeLabel.text = "11:15 PM"
        timeCells[94].timeLabel.text = "11:30 PM"
        timeCells[95].timeLabel.text = "11:45 PM"
    }

}

extension AppointmentTimeController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return timeCells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if timeCells[indexPath.row].disabled == false{
            let time = timeCells[indexPath.row].timeLabel.text
            let dateFormatter = DateFormatter()
            var alertMessage = "Request Appointment For \(time!) on "
            dateFormatter.dateFormat = "MMMM"
            alertMessage = alertMessage + dateFormatter.string(from: date!) + " "
            dateFormatter.dateFormat = "dd"
            alertMessage = alertMessage + dateFormatter.string(from: date!) + "?"
            let timeBlock = timeCells[indexPath.row].timeBlock
            showAlert(title: "Appointment Request", message: alertMessage, timeBlock: timeBlock!)
        }
        
    }
}
