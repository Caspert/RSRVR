//
//  VRViewController.swift
//  RSRVR
//
//  Created by Casper Biemans on 31-05-17.
//  Copyright © 2017 Casper Biemans. All rights reserved.
//

import UIKit

class VRViewController: UIViewController {
    
    // Declare outlets
    @IBOutlet weak var imageVRView: GVRPanoramaView!
    
    enum Media {
        static var photoArray = ["back.jpg", "side.jpg", "front.jpg"]
    }
    
    var currentView: UIView?
    var currentDisplayMode = GVRWidgetDisplayMode.embedded
    
    var timer = Timer()
    
    let blackView = UIView()
    var popUpView: PopUpView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        showPopover()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissPopUp), userInfo: nil, repeats: true)
        

        imageVRView.isHidden = true
        
        imageVRView.load(UIImage(named: Media.photoArray.first!), of: GVRPanoramaImageType.mono)
        
        imageVRView.enableCardboardButton = true
        imageVRView.enableFullscreenButton = true
        imageVRView.delegate = self
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VRViewController: GVRWidgetViewDelegate {
    func widgetView(_ widgetView: GVRWidgetView!, didLoadContent content: Any!) {
        if content is UIImage {
            imageVRView.isHidden = false
        }
    }
    
    func widgetView(_ widgetView: GVRWidgetView!, didFailToLoadContent content: Any!, withErrorMessage errorMessage: String!)  {
        print(errorMessage)
    }
    
    func widgetView(_ widgetView: GVRWidgetView!, didChange displayMode: GVRWidgetDisplayMode) {
        currentView = widgetView
        currentDisplayMode = displayMode
        
        if currentView == imageVRView && currentDisplayMode != GVRWidgetDisplayMode.embedded {
            view.isHidden = true
        } else {
            view.isHidden = false
        }
    }
    
    func widgetViewDidTap(_ widgetView: GVRWidgetView!) {
        guard currentDisplayMode != GVRWidgetDisplayMode.embedded else {return}
        if currentView == imageVRView {
            Media.photoArray.append(Media.photoArray.removeFirst())
            imageVRView?.load(UIImage(named: Media.photoArray.first!), of: GVRPanoramaImageType.mono)
        } else {
        }
    }
}


class TouchView: UIView {
    func viewController() -> UIViewController? {
        if self.next!.isKind(of: ViewController.self) {
            return self.next as? UIViewController
        } else {
            return nil
        }
    }
}


