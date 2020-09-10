//
//  AvailabilityViewControllers.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/3/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import Firebase
import FSCalendar

class EverdayAvailabilityViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var timeCells: [TimeCell] = []
    var unavailableTimeBlocks: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       
        createTimeCells()
        loadUnavailability()
        Utilities.styleFilledButton(saveButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true 
    }
    
    
    func loadUnavailability(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(uid).collection("unavailabilities").document("everyday")
        docRef.getDocument(source: .cache){ (document, error) in
            if (error == nil || (error! as NSError).code == 14){
                
                let arr = document?.get("timeBlocks") as? [Int]
                if(arr != nil){
                    self.unavailableTimeBlocks += arr!
                    for index in self.unavailableTimeBlocks{
                        self.timeCells[index].timeLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                        self.timeCells[index].enabledLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                        self.timeCells[index].enabledLabel.text = "- disabled"
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Couldn't Load Availability! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
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
            cell.selectionStyle = .none
            cell.enabledLabel.text = "- enabled"
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        db.collection("tutors").document(uid).collection("unavailabilities").document("everyday").setData(["timeBlocks" : unavailableTimeBlocks]) {(error) in
            if(error == nil){
                let alert = UIAlertController(title: "Success", message: "Updated Everyday Availability", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Please Try Again Later!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension EverdayAvailabilityViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return timeCells[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeBlock = timeCells[indexPath.row].timeBlock!
        if !(unavailableTimeBlocks.contains(timeBlock)){
            unavailableTimeBlocks.append(timeBlock)
            timeCells[indexPath.row].timeLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
            timeCells[indexPath.row].enabledLabel.text = "- disabled"
            timeCells[indexPath.row].enabledLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        }
        else{
            let index = unavailableTimeBlocks.firstIndex(of: timeBlock)!
            unavailableTimeBlocks.remove(at: index)
            timeCells[indexPath.row].timeLabel.textColor = UIColor.black
            timeCells[indexPath.row].enabledLabel.text = "- enabled"
            timeCells[indexPath.row].enabledLabel.textColor = UIColor.black
        }
    }
}















class WeeklyAvailabilityViewController: UIViewController {
    
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var weekdayButtons: [UIButton] = []
    var selectedArr: [TimeCell] = []
    var weekdayAvailabilityArr: [[TimeCell]] = []
    var weekdayUnavailabilities: [[Int]] = [[],[],[],[],[],[],[]]
    var selectedDay: Int = 0 // 0 = sunday, 1 = monday etc..
    
    
   override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    
        setupButtons()
        setupAvailabilityArrays()
        loadUnavailability()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupButtons(){
        weekdayButtons.append(sundayButton)
        weekdayButtons.append(mondayButton)
        weekdayButtons.append(tuesdayButton)
        weekdayButtons.append(wednesdayButton)
        weekdayButtons.append(thursdayButton)
        weekdayButtons.append(fridayButton)
        weekdayButtons.append(saturdayButton)
        
        for button in weekdayButtons{
            button.layer.cornerRadius = button.frame.size.width/2
            button.backgroundColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
        }
        Utilities.styleFilledButton(saveButton)
        
    }
    
    func loadUnavailability(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid).collection("unavailabilities").document("weekly")
        
        storageRef.getDocument(source: .cache){ (document,error) in
            if(error != nil && !((error! as NSError).code == 14)){
                let alert = UIAlertController(title: "Error", message: "Couldn't Load Previous Unavailability! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else{
                if(document?.get("sunday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("sunday") as! [Int]
                }
                if(document?.get("monday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("monday") as! [Int]
                }
                if(document?.get("tuesday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("tuesday") as! [Int]
                }
                if(document?.get("wednesday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("wednesday") as! [Int]
                }
                if(document?.get("thursday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("thursday") as! [Int]
                }
                if(document?.get("friday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("friday") as! [Int]
                }
                if(document?.get("saturday") as? [Int] != nil){
                    self.weekdayUnavailabilities[0] = document?.get("saturday") as! [Int]
                }
           
                var index: Int = 0
                for arr in self.weekdayAvailabilityArr{
                    if (arr != nil){
                        for cell in arr{
                            if self.weekdayUnavailabilities[index].contains(cell.timeBlock!){
                                self.disableCell(cell)
                            }
                        }
                    }
                    index += 1
                }
                
                
            }
            
        }
    }
    
    func changeSelectedDay(_ num: Int){
        selectedArr = weekdayAvailabilityArr[num]
        selectedDay = num
        var i: Int = 0
        for button in weekdayButtons{
            if num == i{
                button.backgroundColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
            }
            else {button.backgroundColor = UIColor.white}
            i += 1
        }
        tableView.reloadData()
    }
    
    func setupAvailabilityArrays(){
        for _ in 0...6{
            var arr: [TimeCell] = []
            for num in 1...96{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
                cell.timeBlock = num - 1
                cell.selectionStyle = .none
                cell.enabledLabel.text = "- enabled"
                print(arr.count)
                arr.append(cell)
            }
            arr[0].timeLabel.text = "12:00 AM"
            arr[1].timeLabel.text = "12:15 AM"
            arr[2].timeLabel.text = "12:30 AM"
            arr[3].timeLabel.text = "12:45 AM"
            arr[4].timeLabel.text = "1:00 AM"
            arr[5].timeLabel.text = "1:15 AM"
            arr[6].timeLabel.text = "1:30 AM"
            arr[7].timeLabel.text = "1:45 AM"
            arr[8].timeLabel.text = "2:00 AM"
            arr[9].timeLabel.text = "2:15 AM"
            arr[10].timeLabel.text = "2:30 AM"
            arr[11].timeLabel.text = "2:45 AM"
            arr[12].timeLabel.text = "3:00 AM"
            arr[13].timeLabel.text = "3:15 AM"
            arr[14].timeLabel.text = "3:30 AM"
            arr[15].timeLabel.text = "3:45 AM"
            arr[16].timeLabel.text = "4:00 AM"
            arr[17].timeLabel.text = "4:15 AM"
            arr[18].timeLabel.text = "4:30 AM"
            arr[19].timeLabel.text = "4:45 AM"
            arr[20].timeLabel.text = "5:00 AM"
            arr[21].timeLabel.text = "5:15 AM"
            arr[22].timeLabel.text = "5:30 AM"
            arr[23].timeLabel.text = "5:45 AM"
            arr[24].timeLabel.text = "6:00 AM"
            arr[25].timeLabel.text = "6:15 AM"
            arr[26].timeLabel.text = "6:30 AM"
            arr[27].timeLabel.text = "6:45 AM"
            arr[28].timeLabel.text = "7:00 AM"
            arr[29].timeLabel.text = "7:15 AM"
            arr[30].timeLabel.text = "7:30 AM"
            arr[31].timeLabel.text = "7:45 AM"
            arr[32].timeLabel.text = "8:00 AM"
            arr[33].timeLabel.text = "8:15 AM"
            arr[34].timeLabel.text = "8:30 AM"
            arr[35].timeLabel.text = "8:45 AM"
            arr[36].timeLabel.text = "9:00 AM"
            arr[37].timeLabel.text = "9:15 AM"
            arr[38].timeLabel.text = "9:30 AM"
            arr[39].timeLabel.text = "9:45 AM"
            arr[40].timeLabel.text = "10:00 AM"
            arr[41].timeLabel.text = "10:15 AM"
            arr[42].timeLabel.text = "10:30 AM"
            arr[43].timeLabel.text = "10:45 AM"
            arr[44].timeLabel.text = "11:00 AM"
            arr[45].timeLabel.text = "11:15 AM"
            arr[46].timeLabel.text = "11:30 AM"
            arr[47].timeLabel.text = "11:45 AM"
            arr[48].timeLabel.text = "12:00 PM"
            arr[49].timeLabel.text = "12:15 PM"
            arr[50].timeLabel.text = "12:30 PM"
            arr[51].timeLabel.text = "12:45 PM"
            arr[52].timeLabel.text = "1:00 PM"
            arr[53].timeLabel.text = "1:15 PM"
            arr[54].timeLabel.text = "1:30 PM"
            arr[55].timeLabel.text = "1:45 PM"
            arr[56].timeLabel.text = "2:00 PM"
            arr[57].timeLabel.text = "2:15 PM"
            arr[58].timeLabel.text = "2:30 PM"
            arr[59].timeLabel.text = "2:45 PM"
            arr[60].timeLabel.text = "3:00 PM"
            arr[61].timeLabel.text = "3:15 PM"
            arr[62].timeLabel.text = "3:30 PM"
            arr[63].timeLabel.text = "3:45 PM"
            arr[64].timeLabel.text = "4:00 PM"
            arr[65].timeLabel.text = "4:15 PM"
            arr[66].timeLabel.text = "4:30 PM"
            arr[67].timeLabel.text = "4:45 PM"
            arr[68].timeLabel.text = "5:00 PM"
            arr[69].timeLabel.text = "5:15 PM"
            arr[70].timeLabel.text = "5:30 PM"
            arr[71].timeLabel.text = "5:45 PM"
            arr[72].timeLabel.text = "6:00 PM"
            arr[73].timeLabel.text = "6:15 PM"
            arr[74].timeLabel.text = "6:30 PM"
            arr[75].timeLabel.text = "6:45 PM"
            arr[76].timeLabel.text = "7:00 PM"
            arr[77].timeLabel.text = "7:15 PM"
            arr[78].timeLabel.text = "7:30 PM"
            arr[79].timeLabel.text = "7:45 PM"
            arr[80].timeLabel.text = "8:00 PM"
            arr[81].timeLabel.text = "8:15 PM"
            arr[82].timeLabel.text = "8:30 PM"
            arr[83].timeLabel.text = "8:45 PM"
            arr[84].timeLabel.text = "9:00 PM"
            arr[85].timeLabel.text = "9:15 PM"
            arr[86].timeLabel.text = "9:30 PM"
            arr[87].timeLabel.text = "9:45 PM"
            arr[88].timeLabel.text = "10:00 PM"
            arr[89].timeLabel.text = "10:15 PM"
            arr[90].timeLabel.text = "10:30 PM"
            arr[91].timeLabel.text = "10:45 PM"
            arr[92].timeLabel.text = "11:00 PM"
            arr[93].timeLabel.text = "11:15 PM"
            arr[94].timeLabel.text = "11:30 PM"
            arr[95].timeLabel.text = "11:45 PM"
            weekdayAvailabilityArr.append(arr)
        }
        changeSelectedDay(0)
    }
    
    
    @IBAction func sundayTapped(_ sender: Any) {
        changeSelectedDay(0)
    }
    
    @IBAction func mondayTapped(_ sender: Any) {
        changeSelectedDay(1)
    }
    
    @IBAction func tuesdayTapped(_ sender: Any) {
        changeSelectedDay(2)
    }
    
    @IBAction func wednesdayTapped(_ sender: Any) {
        changeSelectedDay(3)
    }
    
    @IBAction func thursdayTapped(_ sender: Any) {
        changeSelectedDay(4)
    }
    
    @IBAction func fridayTapped(_ sender: Any) {
        changeSelectedDay(5)
    }
    
    @IBAction func saturdayTapped(_ sender: Any) {
        changeSelectedDay(6)
    }
    
    func enableCell(_ cell: TimeCell){
        cell.timeLabel.textColor = UIColor.black
        cell.enabledLabel.text = "- enabled"
        cell.enabledLabel.textColor = UIColor.black
    }
    
    func disableCell(_ cell: TimeCell){
        cell.timeLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        cell.enabledLabel.text = "- disabled"
        cell.enabledLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid).collection("unavailabilities").document("weekly")
        storageRef.setData(["sunday" : weekdayUnavailabilities[0], "monday" : weekdayUnavailabilities[1], "tuesday" : weekdayUnavailabilities[2], "wednesday" : weekdayUnavailabilities[3], "thursday" : weekdayUnavailabilities[4], "friday" : weekdayUnavailabilities[5], "saturday" : weekdayUnavailabilities[6]]) {(error) in
            if (error != nil){
                let alert = UIAlertController(title: "Error", message: "Couldn't Save! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Success", message: "Updated Availability!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            
        }
    }
    
    
}

extension WeeklyAvailabilityViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return selectedArr[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeBlock = selectedArr[indexPath.row].timeBlock!
        if !(weekdayUnavailabilities[selectedDay].contains(timeBlock)){
            weekdayUnavailabilities[selectedDay].append(timeBlock)
            disableCell(selectedArr[indexPath.row])
          
        }
        else{
            let index = weekdayUnavailabilities[selectedDay].firstIndex(of: timeBlock)!
           weekdayUnavailabilities[selectedDay].remove(at: index)
            enableCell(selectedArr[indexPath.row])
            
        }
        
    }
}


class SpecificAvailabilityCalendarViewController: UIViewController, FSCalendarDelegate {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        
        calendar.appearance.headerTitleColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        calendar.appearance.weekdayTextColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM-dd yyyy?"
        let alert = UIAlertController(title: dateFormatter.string(from: date), message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let specificAvailabilityVC = mainStoryboard.instantiateViewController(withIdentifier: "SpecificAvailabilityVC") as! SpecificAvailabilityViewController
            specificAvailabilityVC.date = date
            self.navigationController?.pushViewController(specificAvailabilityVC, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) in
            
        }))
        self.present(alert, animated: true)
    }
}


class SpecificAvailabilityViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var saveButton: UIButton!
    var date: Date?
    
    var timeCells: [TimeCell] = []
    var unavailableTimeBlocks: [Int] = []
    var docExists: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM-dd yyyy"
        if(date != nil){
            navigationTitle.title = dateFormatter.string(from: date!)
        }
        Utilities.styleFilledButton(saveButton)
        createTimeCells()
        loadUnavailability()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func createTimeCells(){
        for num in 1...96{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
            cell.timeBlock = num - 1
            cell.selectionStyle = .none
            cell.enabledLabel.text = "- enabled"
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid).collection("unavailabilities").document("specificDay")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        
     
        storageRef.updateData([dateFormatter.string(from: date!) : unavailableTimeBlocks]) {(error) in
            if (error != nil && (error! as NSError).code != 5){
                
                print("\n\n\n"+error!.localizedDescription)
                print((error! as NSError).code)
                let alert = UIAlertController(title: "Error", message: "Couldn't Update Availability! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else if (error != nil && ((error! as NSError).code == 5 || (error! as NSError).code == 14)){
                storageRef.setData([dateFormatter.string(from: self.date!) : self.unavailableTimeBlocks]) {(error) in
                    if (error != nil){
                        
                        print("\n\n\n"+error!.localizedDescription)
                        print((error! as NSError).code)
                        let alert = UIAlertController(title: "Error", message: "Couldn't Update Availability! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Success", message: "Updated Availability!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "Success", message: "Updated Availability!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    
    func loadUnavailability(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid).collection("unavailabilities").document("specificDay")
        storageRef.getDocument(source: .cache) {(document, error) in
           if(error != nil && (error! as NSError).code != 14) { // if docuement doesnt exist then keep moving on
            
                print("running this bullshit")
                let alert = UIAlertController(title: "Error", message: "Couldn't Load Previous Unavailability! Please Try Again!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else {
                print("running this bullshit 1")
                if (error != nil && ((error! as NSError).code == 14)) {
                    print("running this bullshit 2")
                    self.docExists = false
                    print("Doc Exists: \(self.docExists)\n\n\n")
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM-dd-yyyy"
                let arr = document?.get(dateFormatter.string(from: self.date!)) as? [Int]
                if arr != nil{
                    for i in arr!{
                        self.unavailableTimeBlocks.append(i)
                        self.timeCells[i].timeLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                        self.timeCells[i].enabledLabel.text = "- disabled"
                        self.timeCells[i].enabledLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                        
                    }
                }
            }
        }
    }
}

extension SpecificAvailabilityViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return timeCells[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeBlock = timeCells[indexPath.row].timeBlock!
        if !(unavailableTimeBlocks.contains(timeBlock)){
            unavailableTimeBlocks.append(timeBlock)
            timeCells[indexPath.row].timeLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
            timeCells[indexPath.row].enabledLabel.text = "- disabled"
            timeCells[indexPath.row].enabledLabel.textColor = UIColor.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        }
        else{
            let index = unavailableTimeBlocks.firstIndex(of: timeBlock)!
            unavailableTimeBlocks.remove(at: index)
            timeCells[indexPath.row].timeLabel.textColor = UIColor.black
            timeCells[indexPath.row].enabledLabel.text = "- enabled"
            timeCells[indexPath.row].enabledLabel.textColor = UIColor.black
        }
    }
}
