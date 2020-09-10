//
//  ViewController.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/17/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//
import FSCalendar
import UIKit
import Firebase

class CalendarController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var clientSideAppointments: [ClientAppointment] = []
    var tutorSideAppointments: [TutorAppointment] = []
    var currentUserPFP: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        calendar.appearance.headerTitleColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        calendar.appearance.weekdayTextColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        loadClientSideAppointments()
        loadTutorSideAppointments()
        getCurrentUserPFP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
                            self?.currentUserPFP = UIImage(data: data)
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
    
    func loadClientSideAppointments(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("users").document(uid).collection("appointments")
        storageRef.getDocuments(){(snapshot, error) in
            if error != nil{
                print("Couldnt load clientside appointments!")
            }
            else{
                for document in snapshot!.documents{
                    let appointment = ClientAppointment()
                    appointment.docID = document.documentID
                    appointment.tutorUID = document.get("tutorUID") as? String
                    appointment.timeBlock = document.get("timeBlock") as? Int
                    appointment.dateStr = document.get("date") as? String
                    self.getClientAppointmentPFP(appointment, document.get("pfpURL") as? String)
                    appointment.name = document.get("name") as? String
                    appointment.rate = document.get("rate") as? Int
                    
                    self.clientSideAppointments.append(appointment)
                    self.calendar.reloadData()
                }
            }
        }
    }
    
    func loadTutorSideAppointments(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        let storageRef = db.collection("tutors").document(uid).collection("appointments")
        storageRef.getDocuments(){(snapshot, error) in
            if error != nil{
                print("Couldnt load clientside appointments!")
            }
            else{
                for document in snapshot!.documents{
                    let appointment = TutorAppointment()
                    appointment.docID = document.documentID
                    appointment.clientUID = document.get("clientUID") as? String
                    appointment.timeBlock = document.get("timeBlock") as? Int
                    appointment.dateStr = document.get("date") as? String
                    self.getTutorAppointmentPFP(appointment, document.get("pfpURL") as? String)
                    appointment.name = document.get("name") as? String
                    appointment.rate = document.get("rate") as? Int
                    
                    self.tutorSideAppointments.append(appointment)
                    self.calendar.reloadData()
                }
            }
        }
        
    }
    
    func getClientAppointmentPFP(_ appointment: ClientAppointment, _ url: String?){
        self.getData(from: URL(string: url!)!) {data, response, error in
            guard let data = data, error == nil else {return}
            print(response?.suggestedFilename ?? URL(string: url!)!.lastPathComponent)
            DispatchQueue.main.async {
                [weak self] in
                    appointment.pfp = UIImage(data: data)
            }
                        
        }
        
    }
    
    func getTutorAppointmentPFP(_ appointment: TutorAppointment, _ url: String?){
        self.getData(from: URL(string: url!)!) {data, response, error in
            guard let data = data, error == nil else {return}
            print(response?.suggestedFilename ?? URL(string: url!)!.lastPathComponent)
            DispatchQueue.main.async {
                [weak self] in
                appointment.pfp = UIImage(data: data)
            }
            
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        for appointment in clientSideAppointments{
            if(dateFormatter.string(from: date) == appointment.dateStr){
                return UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
            }
        }
        
        for appointment in tutorSideAppointments{
            if(dateFormatter.string(from: date) == appointment.dateStr){
                return UIColor.init(red: 252/255, green: 186/255, blue: 3/255, alpha: 1)
            }
        }
        
        if(dateFormatter.string(from: date) == dateFormatter.string(from: Date())){
            return UIColor.init(red: 0.698, green: 0.133, blue: 0.133, alpha: 1)
        }
        return UIColor.white
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        
        
        var appointments: [Appointment] = []
        
        for appointment in clientSideAppointments{
            if(dateFormatter.string(from: date) == appointment.dateStr){
                appointments.append(appointment)
            }
        }
        
        for appointment in tutorSideAppointments{
            if(dateFormatter.string(from: date) == appointment.dateStr){
                appointments.append(appointment)
            }
        }
        
        if(appointments.count == 0){return}
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let appointmentPopupVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentPopVC") as! AppointmentPopupViewController
        appointmentPopupVC.appointments = appointments
        appointmentPopupVC.parentController = self
        self.present(appointmentPopupVC, animated: true)
        
        
        
    }
    
}


class Appointment{}

class ClientAppointment: Appointment{
    var tutorUID: String?
    var timeBlock: Int?
    var dateStr: String?
    var pfp: UIImage?
    var name: String?
    var rate: Int?
    var docID: String?
}

class TutorAppointment: Appointment{
    var clientUID: String?
    var timeBlock: Int?
    var dateStr: String?
    var pfp: UIImage?
    var name: String?
    var rate: Int?
    var docID: String?
}

class AppointmentPopupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    
    var appointments: [Appointment]?
    var appointmentCells: [AppointmentTableViewCell] = []
    var parentController: CalendarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
        createAppointmentCells()
    }
    
    func createAppointmentCells(){
        for appointment in appointments!{
            if let clientAppointment = appointment as? ClientAppointment{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell") as! AppointmentTableViewCell
                cell.name = clientAppointment.name
                cell.timeBlock = clientAppointment.timeBlock
                cell.rate = clientAppointment.rate
                cell.pfp = clientAppointment.pfp
                cell.docID = clientAppointment.docID
                cell.appID = clientAppointment.tutorUID
                cell.isClientSide = true
                cell.parentContainer = self
                cell.outletSetup()
                appointmentCells.append(cell)
            }
            if let tutorAppointment = appointment as? TutorAppointment{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell") as! AppointmentTableViewCell
                cell.name = tutorAppointment.name
                cell.timeBlock = tutorAppointment.timeBlock
                cell.rate = tutorAppointment.rate
                cell.pfp = tutorAppointment.pfp
                cell.docID = tutorAppointment.docID
                cell.appID = tutorAppointment.clientUID
                cell.isClientSide = false
                cell.parentContainer = self
                cell.outletSetup()
                appointmentCells.append(cell)
            }
            tableView.reloadData()
        }
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(appointmentCells.count > 1){
            bottomAnchor.constant = -100
        }
        else{
            bottomAnchor.constant = -390
        }
        
        return appointmentCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return appointmentCells[indexPath.row]
    }
    
    
}

class AppointmentTableViewCell: UITableViewCell{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var name: String?
    var appID: String?
    var timeBlock: Int?
    var rate: Int?
    var pfp: UIImage?
    var docID: String?
    var isClientSide: Bool?
    var parentContainer: AppointmentPopupViewController?
    
    
   override func awakeFromNib() {
        self.selectionStyle = .none
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 20
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        Utilities.styleFilledButton(messageButton)
        Utilities.styleFilledButton(cancelButton)
    
    
    }
    
    func outletSetup(){
        nameLabel.text = name
        rateLabel.text = "$\(rate!)/hr"
        if(pfp != nil){profileImageView.image = pfp}
        convertTimeBlockToLabel(timeBlock)
        if(!isClientSide!){
            messageButton.setTitle("Message Client", for: .normal)
        }
    }
    
    
    func convertTimeBlockToLabel(_ timeBlock: Int?){
        if(timeBlock == nil){return}
        let totalMins = timeBlock! * 15
        var ext = "AM"
        var hours = totalMins / 60
        var mins = totalMins % 60
        
        if hours > 12 {
            hours = hours - 12
            ext = "PM"
        }
        if("\(mins)".count == 1){
           timeLabel.text = "\(hours):\(mins)0 \(ext)"
        }
        else{
            timeLabel.text = "\(hours):\(mins) \(ext)"
        }
        
        
        
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageController
        vc.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "Me", pfp: self.parentContainer?.parentController?.currentUserPFP)
        vc.messagedUser = Sender(senderId: appID!, displayName: name!, pfp: profileImageView.image)
        self.parentContainer?.parentController?.navigationController?.setNavigationBarHidden(false, animated: true)
        vc.navigationItem.title = name
        self.parentContainer?.parentController?.navigationController!.pushViewController(vc, animated: true)
       
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Do You Really Want To Cancel?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        if(self.isClientSide!){
            let storageRef = db.collection("users").document(uid).collection("appointments").document(self.docID!)
            storageRef.delete(){(error) in
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: "Please Try Again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Please Try Again!", style: .default, handler: nil))
                    self.parentContainer!.present(alert, animated: true)
                }
                else{
                    
                    for appointment in self.parentContainer!.appointments!{
                        
                        if let clientAppointment = appointment as? ClientAppointment{
                            if clientAppointment.docID == self.docID{
                                let index = self.parentContainer!.appointments?.firstIndex{$0 === appointment}
                                self.parentContainer!.appointments!.remove(at: index!)
                                self.parentContainer?.appointmentCells.remove(at: index!)
                                let calendarIndex = self.parentContainer?.parentController?.clientSideAppointments.firstIndex{$0 === appointment}
                                self.parentContainer?.parentController?.clientSideAppointments.remove(at: calendarIndex!)
                                self.parentContainer!.tableView.reloadData()
                                break
                            }
                        }
                    }
                }
            }
        
        
        }
        else{
            
            let storageRef = db.collection("tutors").document(uid).collection("appointments").document(self.docID!)
            storageRef.delete(){(error) in
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: "Please Try Again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Please Try Again!", style: .default, handler: nil))
                    self.parentContainer!.present(alert, animated: true)
                }
                else{
                   
                    for appointment in self.parentContainer!.appointments!{
                        
                        if let tutorAppointment = appointment as? TutorAppointment{
                            if tutorAppointment.docID == self.docID{
                                let index = self.parentContainer!.appointments?.firstIndex{$0 === appointment}
                                self.parentContainer!.appointments!.remove(at: index!)
                                self.parentContainer?.appointmentCells.remove(at: index!)
                                let calendarIndex = self.parentContainer?.parentController?.tutorSideAppointments.firstIndex{$0 === appointment}
                                self.parentContainer?.parentController?.tutorSideAppointments.remove(at: calendarIndex!)
                                self.parentContainer!.tableView.reloadData()
                                break
                            }
                        }
                    }
                }
            }
        }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        parentContainer!.present(alert, animated: true)
    }
    
}
