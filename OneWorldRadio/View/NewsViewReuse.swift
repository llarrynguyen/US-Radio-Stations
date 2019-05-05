//
//  MainCollectionReusableView.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/9/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class NewsViewReuse: UICollectionReusableView {

    @IBOutlet weak var nowPlayingAnimationImageView: UIImageView!

    @IBOutlet weak var nowPlayingButton: UIButton!


    @IBOutlet weak var stationImageView: UIImageView!
    
    @IBOutlet weak var myCollectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
       
        let currentStationImage = UIImage(named: "icons8-radio_filled")
        currentStationImage?.withRenderingMode(.alwaysOriginal)
        
        
        stationImageView.tintColor = SPConstants.ColorPaletteHex.mainBlue.color
        stationImageView.image = currentStationImage
        stationImageView.layer.cornerRadius = stationImageView.frame.height/2
        stationImageView.layer.masksToBounds = true
        stationImageView.contentMode  = .scaleAspectFit
        stationImageView.borderWidth = 1
        stationImageView.borderColor = SPConstants.ColorPaletteHex.mainBlue.color
        
        let collectionImage = UIImage(named: "icons8-video_paylist_filled")
        collectionImage?.withRenderingMode(.alwaysOriginal)
        myCollectionButton.setImage(collectionImage, for: .normal)
        myCollectionButton.tintColor = SPConstants.ColorPaletteHex.mainBlue.color
        myCollectionButton.layer.cornerRadius = myCollectionButton.frame.height/2
        myCollectionButton.imageView?.layer.masksToBounds = true
        
        createNowPlayingAnimation()
        
    }
    
    var addClosure: VoidClosureParameter?
    var myCollectionClosure: VoidClosureParameter?
    var nowPlayingClosure: VoidClosureParameter?
    var searchClosure: VoidClosureParameter?
    
    func createNowPlayingAnimation() {
        nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars-3")
        nowPlayingAnimationImageView.autoresizingMask = []
        nowPlayingAnimationImageView.tintColor = .black
        nowPlayingAnimationImageView.contentMode = UIView.ContentMode.center
        
        nowPlayingAnimationImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingAnimationImageView.animationDuration = 0.7
        
        startNowPlayingAnimation(true)
    }
    
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingAnimationImageView.startAnimating() : nowPlayingAnimationImageView.stopAnimating()
    }

    @IBAction func myRadioStationsTapped(_ sender: Any) {
        myCollectionClosure?()
    }
    
    @IBAction func goToNowPlaying(_ sender: Any) {
        nowPlayingClosure?()
    }
  
}

