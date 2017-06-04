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
    @IBOutlet weak var videoVRView: GVRVideoView!
    
    var currentView: UIView?
    var currentDisplayMode = GVRWidgetDisplayMode.embedded
    
    var timer = Timer()
    
    let blackView = UIView()
    var popUpView: PopUpView?
    
    var videoArray = ["http://www.design-style.nl/fiesta-1.mp4", "http://www.design-style.nl/fiesta-2.mp4", "http://www.design-style.nl/fiesta-3.mp4", "http://www.design-style.nl/fiesta-4.mp4"]
    var videoCount: Int?
    var curPosition: TimeInterval?
    var duration: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        showPopover()
        videoVRView.load(from: URL(string: videoArray.first!))

        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissPopUp), userInfo: nil, repeats: true)
        
        videoVRView.enableCardboardButton = true
        videoVRView.enableFullscreenButton = true
        videoVRView.delegate = self
        
        videoCount = videoArray.count
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
    
    func setCurrentViewFromTouch(touchPoint point:CGPoint) {
        if videoVRView!.frame.contains(point) {
            currentView = videoVRView
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
        print("position", position)
        curPosition = position
        duration = videoView.duration()
        OperationQueue.main.addOperation() {
            if position == videoView.duration() {
                self.performSegue(withIdentifier: "showLicense", sender: self)
                print("end of video reached")
            }
        }
    }
    
    func widgetView(_ widgetView: GVRWidgetView!, didFailToLoadContent content: Any!, withErrorMessage errorMessage: String!)  {
        print(errorMessage)
    }
    
    func widgetView(_ widgetView: GVRWidgetView!, didChange displayMode: GVRWidgetDisplayMode) {
        currentView = widgetView
        currentDisplayMode = displayMode
        
        if currentView == videoVRView && currentDisplayMode != GVRWidgetDisplayMode.embedded {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
    }
    
    func widgetViewDidTap(_ widgetView: GVRWidgetView!) {
        guard currentDisplayMode != GVRWidgetDisplayMode.embedded else {return}
        if currentView == videoVRView {
            
            if videoCount == 4 && (curPosition! >= TimeInterval(16) && curPosition! <= TimeInterval(20)) {
                videoArray.append(videoArray.removeFirst())
                print("front view")
                videoVRView?.load(from: URL(string: videoArray.first!))
            }
            
            if videoCount == 3 && (curPosition! >= TimeInterval(13) && curPosition! <= TimeInterval(17)) {
                videoArray.append(videoArray.removeFirst())
                print("side view")
                videoVRView?.load(from: URL(string: videoArray.first!))
            }
            
            if videoCount == 2 && (curPosition! >= TimeInterval(6) && curPosition! <= TimeInterval(10)) {
                videoArray.append(videoArray.removeFirst())
                print("back view")
                videoVRView?.load(from: URL(string: videoArray.first!))
            }
            
            if videoCount == 1 && curPosition! >= TimeInterval(0) {
                videoArray.append(videoArray.removeFirst())
                print("back view")
                videoVRView?.load(from: URL(string: videoArray.first!))
            }
            
        
            if curPosition == duration {
                videoArray = []

                self.performSegue(withIdentifier: "showLicense", sender: self)
            }
            
        } else {
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
