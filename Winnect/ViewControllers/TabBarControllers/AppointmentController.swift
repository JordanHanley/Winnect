//
//  AppointmentController.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/2/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit
import FSCalendar

class AppointmentController: UIViewController, FSCalendarDelegate {

    var currDate: Date?
    var uid: String?
    
    @IBOutlet weak var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        
        calendar.appearance.headerTitleColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        calendar.appearance.weekdayTextColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        
        currDate = calendar.today
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        super.viewWillAppear(animated)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = date as NSDate
        if selectedDate.timeIntervalSinceNow > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy?"
            let alert = UIAlertController(title: "Schedule Appointment For "+dateFormatter.string(from: date), message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let appointmentTimeVC = mainStoryboard.instantiateViewController(withIdentifier: "AppointmentTimeVC") as! AppointmentTimeController
                appointmentTimeVC.date = date
                appointmentTimeVC.uid = self.uid
                self.navigationController?.pushViewController(appointmentTimeVC, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        
    }
    
    
    
  

}
