//
//  VRViewController.swift
//  RSRVR
//
//  Created by Casper Biemans on 31-05-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit
import AVKit

class VRViewController: UIViewController {
    
    // Declare outlets
    @IBOutlet weak var imageVRView: GVRPanoramaView!
    @IBOutlet weak var videoVRView: GVRVideoView!
    
    var currentView: UIView?
    var currentDisplayMode = GVRWidgetDisplayMode.embedded
    
    var timer = Timer()
    
    let blackView = UIView()
    var popUpView: PopUpView?
    
    enum Media {
        static var photoArray = ["back.jpg", "side.jpg", "front.jpg"]
        static let videoURL = ["http://www.design-style.nl/fiesta-vr.mp4", "http://www.design-style.nl/360Ring.mp4"]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        showPopover()
        print(Media.videoURL)
        videoVRView.load(from: URL(string: Media.videoURL.first!))

        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissPopUp), userInfo: nil, repeats: true)
        
        videoVRView.enableCardboardButton = true
        videoVRView.enableFullscreenButton = true
        videoVRView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        let nibs = Bundle.main.loadNibNamed("PopUpView", owner: nil, options: nil)
        self.popUpView = nibs?[0] as? PopUpView
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.popUpView!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
    }
    
    func setCurrentViewFromTouch(touchPoint point:CGPoint) {
        if imageVRView!.frame.contains(point) {
            currentView = imageVRView
        }
    }
    
    func showPopover() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            // Dismiss blackView on tap
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            blackView.addGestureRecognizer(tapGesture)
            
            // Add blackview
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            
            // Animate in ease-out
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
            }, completion: nil)
        }
        
    }
    
    func handleDismiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
        }, completion: nil)
        
    }
    
    
    func dismissPopUp(){
        self.popUpView?.removeFromSuperview()
        timer.invalidate()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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

extension VRViewController: GVRVideoViewDelegate {

    func videoView(_ videoView: GVRVideoView!, didUpdatePosition position: TimeInterval) {
        print("in function", position)
        OperationQueue.main.addOperation() {
            if position == videoView.duration() {
                self.performSegue(withIdentifier: "showLicense", sender: self)
                print("end of video reached")
            }
        }
    }
    
}

class TouchView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let vrViewController = viewController() as? VRViewController , event?.type == UIEventType.touches {
            vrViewController.setCurrentViewFromTouch(touchPoint: point)
        }
        return true
    }
    
    func viewController() -> UIViewController? {
        if self.next!.isKind(of: VRViewController.self) {
            return self.next as? UIViewController
        } else {
            return nil
        }
    }
}
