//
//  TutorCell.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/20/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit

class TutorCell: UITableViewCell {

    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var subjectsLabel: UILabel!
    @IBOutlet weak var tutorPageButton: UIButton!
    @IBOutlet weak var gpsIcon: UIImageView!
    @IBOutlet weak var gpsLabel: UILabel!
    
    
    var parentViewController: UIViewController?
    var tutor: Tutor?
    var uid: String?
    var bioText: String?

    
    override func awakeFromNib() {
        gpsIcon.alpha = 0
        gpsLabel.alpha = 0
    }
    
    @IBAction func tutorPageButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tutorPageVC = mainStoryboard.instantiateViewController(withIdentifier: "TutorPageVC") as! TutorPageController
        
        
        tutorPageVC.profileImage = profileImage.image
        tutorPageVC.educationText = educationLabel.text
        tutorPageVC.nameText = nameLabel.text
        tutorPageVC.subjectsText = subjectsLabel.text
        tutorPageVC.rateText = rateLabel.text
        tutorPageVC.uid = uid
        tutorPageVC.bioText = bioText
        parentViewController?.navigationController?.pushViewController(tutorPageVC, animated: true)
        
    }
    
    func showGPSDistance(_ text:String){
        gpsIcon.alpha = 1
        gpsLabel.alpha = 1
        gpsLabel.text = text
    }
    
}
