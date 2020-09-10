//
//  TimeCell.swift
//  Winnect
//
//  Created by Jordan Hanley on 7/2/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var enabledLabel: UILabel!
    var timeBlock: Int?
    var disabled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
