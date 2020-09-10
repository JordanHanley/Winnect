//
//  Utilities.swift
//  Winnect
//
//  Created by Jordan Hanley on 6/14/20.
//  Copyright © 2020 Jordan Hanley. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    //UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
    static func styleTextField(_ textfield:UITextField){
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x:0, y:textfield.frame.height - 2, width:textfield.frame.width, height:2)
        
        bottomLine.backgroundColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton){
        
        button.backgroundColor = UIColor.init(red: 77/255, green: 122/255, blue: 221/255, alpha: 1)
        
        button.layer.cornerRadius = 25.0
        
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton){
        
        button.layer.borderWidth = 2
        
        button.layer.borderColor = UIColor.black.cgColor
        
        button.layer.cornerRadius = 25
        
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password:String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
}

