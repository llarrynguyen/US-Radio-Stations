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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var nowPlayingButton: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var bg: UIImageView!
    
    var buttonBar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        segment.backgroundColor = .clear
        segment.tintColor = .clear
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Bold", size: 26),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)

        segment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Bold", size: 26),
            NSAttributedString.Key.foregroundColor: SPConstants.ColorPaletteHex.shinySkyBlue.color
            ], for: .selected)
        

        createNowPlayingAnimation()
        
        
        buttonBar = UIView()
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = SPConstants.ColorPaletteHex.shinySkyBlue.color
        self.addSubview(buttonBar)
        
       
        buttonBar.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segment.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segment.widthAnchor, multiplier: 1 / CGFloat(segment.numberOfSegments)).isActive = true
    }
    
    var addClosure: VoidClosureParameter?
    var myCollectionClosure: VoidClosureParameter?
    var nowPlayingClosure: VoidClosureParameter?
    var searchClosure: VoidClosureParameter?
    
    func createNowPlayingAnimation() {
        nowPlayingAnimationImageView.image = UIImage(named: "NowPlayingBars-3")
        nowPlayingAnimationImageView.autoresizingMask = []
        nowPlayingAnimationImageView.tintColor = .orange
        nowPlayingAnimationImageView.contentMode = UIView.ContentMode.center
        
        nowPlayingAnimationImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingAnimationImageView.animationDuration = 0.7
        
        startNowPlayingAnimation(true)
    }
    
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingAnimationImageView.startAnimating() : nowPlayingAnimationImageView.stopAnimating()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addClosure?()
    }
    
    @IBAction func myRadioStationsTapped(_ sender: Any) {
        myCollectionClosure?()
    }
    
    @IBAction func goToNowPlaying(_ sender: Any) {
        nowPlayingClosure?()
    }
    @IBAction func searchTapped(_ sender: Any) {
        searchClosure?()
    }
    
}

