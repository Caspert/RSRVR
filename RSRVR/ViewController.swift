//
//  ViewController.swift
//  RSRVR
//
//  Created by Casper Biemans on 30-05-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var driveView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Open VC for image
        let tapExperienceGesture = UITapGestureRecognizer(target: self, action: #selector(displayExperience(tapGestureRecognizer:)))
        experienceView.isUserInteractionEnabled = true
        experienceView.addGestureRecognizer(tapExperienceGesture)
        
        
        let tapDriveGesture = UITapGestureRecognizer(target: self, action: #selector(displayDrive(tapGestureRecognizer:)))
        driveView.isUserInteractionEnabled = true
        driveView.addGestureRecognizer(tapDriveGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to view the selectedImage fullscreen after being tapped
    func displayExperience(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showExperience", sender: self)
    }
    
    func displayDrive(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showDrive", sender: self)
    }


}

