//
//  PopUpView.swift
//  RSRVR
//
//  Created by Casper Biemans on 31-05-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit

class PopUpView: UIView {
    
    // Declare outlets
    @IBOutlet weak var countNumber: UILabel!
    
    @IBAction func handleDismiss(_ sender: Any) {
        VRViewController().dismissPopUp()
        print("Dismiss")
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
