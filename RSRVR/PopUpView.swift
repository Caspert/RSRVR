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
    
    var timer = Timer()
    var count = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
//        countNumber?.text = "2"
    }
    
    
    func countDown() {
        if(count > 0) {
            count -= 1
            countNumber?.text = String(count)
        }
    }


    
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
