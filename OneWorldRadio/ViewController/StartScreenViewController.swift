//
//  StartScreenViewController.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/24/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    @IBOutlet weak var rectangleImageView: UIImageView!
    
    @IBOutlet weak var leafImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLeafToBox()
    }
    
    fileprivate func animateLeafToBox(){
        let start = self.leafImageView.center
        let end = self.rectangleImageView.center
        
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.rectangleImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.rectangleImageView.transform = CGAffineTransform(scaleX: 1/1.2, y: 1/1.2)
            }
            
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.leafImageView.center = CGPoint(x: self.leafImageView.center.x + 120, y: self.leafImageView.center.y + 15)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                self.leafImageView.center = CGPoint(x: self.leafImageView.center.x - 15, y: self.leafImageView.center.y + 50)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.leafImageView.center = end
            }
        },completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                 self.navigateToTabBar()
            })
        })
        
    }
    
    fileprivate func navigateToTabBar(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabbarIdentifier") as! UITabBarController
        
        
        self.present(tabbarVC, animated: false, completion: nil)
    }
}
