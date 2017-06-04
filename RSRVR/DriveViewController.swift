//
//  DriveViewController.swift
//  RSRVR
//
//  Created by Casper Biemans on 30-05-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DriveViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var driveFlagView: UIView!
    
    
    // A reference to the location manager
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    
    // 1 mile = 5280 feet
    // Meter to miles = m * 0.00062137
    // 1 meter = 3.28084 feet
    // 1 foot = 0.3048 meters
    // km = m / 1000
    // m = km * 1000
    // ft = m / 3.28084
    // 1 mile = 1609 meters

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeLocationManager()
        
        driveFlagView.backgroundColor = UIColor.yellow
        blinkAnimate()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: InitializeLocationManager
    
    private func initializeLocationManager() {
        // Configure and start the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: LocationManager didUpdateLocations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // If we have the coordinates from the locationManager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            // Set location region
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            
//            let speedToMPH = ((locationManager.location?.speed)! * 2.23694)
            let speedToKPH = ((locationManager.location?.speed)! * 3.6)
//            speedToKPH.rounded(.down)
            var speedToKPHRound = String(format: "%.2f", speedToKPH)
            speedLabel.text = "\(speedToKPHRound) km"

        }
        
    }
    
    func blinkAnimate() {
        driveFlagView.backgroundColor = UIColor.clear
        
        UIView.animate(withDuration: 0.5, animations: {
            self.driveFlagView.backgroundColor = UIColor.yellow
        }, completion: {
            (value: Bool) in
            self.blinkAnimate()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
