//
//  NotificationCell.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/25/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    
    var notificationID: String?
}
