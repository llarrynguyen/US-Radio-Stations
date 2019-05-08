//
//  SPNowPlayingViewController.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/11/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import MediaPlayer
import Spring
import FRadioPlayer


protocol NowPlayingViewControllerDelegate: class {
    func didPressPlayingButton()
    func didPressStopButton()
    func didPressNextButton()
    func didPressPreviousButton()
}

class SPNowPlayingViewController: UIViewController {
    
    weak var delegate: NowPlayingViewControllerDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var albumHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumImageView: SpringImageView!
    @IBOutlet weak var playingButton: UIButton!
    @IBOutlet weak var songLabel: SpringLabel!
    @IBOutlet weak var stationDescLabel: UILabel!
    @IBOutlet weak var volumeParentView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addToCollectionButton: UIButton!
    

    
    var currentStation: RadioStation!
    var currentTrack: Track!
    
    var newStation = true
    var nowPlayingImageView: UIImageView!
    let radioPlayer = FRadioPlayer.shared
    
    var mpVolumeSlider: UISlider?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createNowPlayingAnimation()
        
        optimizeForDeviceSize()

        self.title = currentStation.name
        
        albumImageView.image = currentTrack.artworkImage
        stationDescLabel.isHidden = currentTrack.artworkLoaded
        
        newStation ? stationDidChange() : playerStateDidChange(radioPlayer.state, animate: false)
        stationDidChange()
        setupVolumeSlider()
        
        previousButton.isHidden = false
        nextButton.isHidden = false
        addToCollectionButton.layer.cornerRadius = addToCollectionButton.frame.height/2
        
        favoriteChangeState(isFavorite: currentStation.isFavorite)
        
    }
    
    func favoriteChangeState(isFavorite: Bool?) {
        if isFavorite == true {
            
            addToCollectionButton.backgroundColor = .gray
        } else {
          
            addToCollectionButton.backgroundColor = SPConstants.ColorPaletteHex.mainBlue.color
            
        }
    }
    

    func setupVolumeSlider() {
        for subview in MPVolumeView().subviews {
            guard let volumeSlider = subview as? UISlider else { continue }
            mpVolumeSlider = volumeSlider
        }
        
        guard let mpVolumeSlider = mpVolumeSlider else { return }
        
        volumeParentView.addSubview(mpVolumeSlider)
        
        mpVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
        mpVolumeSlider.leftAnchor.constraint(equalTo: volumeParentView.leftAnchor).isActive = true
        mpVolumeSlider.rightAnchor.constraint(equalTo: volumeParentView.rightAnchor).isActive = true
        mpVolumeSlider.centerYAnchor.constraint(equalTo: volumeParentView.centerYAnchor).isActive = true
        
        mpVolumeSlider.setThumbImage(#imageLiteral(resourceName: "slider-ball"), for: .normal)
    }
    
    func stationDidChange() {
        radioPlayer.radioURL = URL(string: currentStation.url)
        albumImageView.image = currentTrack.artworkImage
        stationDescLabel.isHidden = currentTrack.artworkLoaded
        title = currentStation.name
    }
    
  
    @IBAction func playingPressed(_ sender: Any) {
        delegate?.didPressPlayingButton()
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        delegate?.didPressStopButton()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        delegate?.didPressNextButton()
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        delegate?.didPressPreviousButton()
    }
    
    func load(station: RadioStation?, track: Track?, isNewStation: Bool = true) {
        guard let station = station else { return }
        
        print(station.url)
        currentStation = station
        currentGlobalStation = station
        currentTrack = track
        newStation = isNewStation
    }
    
    func updateTrackMetadata(with track: Track?) {
        guard let track = track else { return }
        currentTrack.title = track.title
        
        updateLabels()
    }
    
    // Update track with new artwork
    func updateTrackArtwork(with track: Track?) {
        guard let track = track else { return }
        
        // Update track struct
        currentTrack.artworkImage = track.artworkImage
        currentTrack.artworkLoaded = track.artworkLoaded
        
        albumImageView.image = currentTrack.artworkImage
        
        if track.artworkLoaded {
            // Animate artwork
            albumImageView.animation = "wobble"
            albumImageView.duration = 2
            albumImageView.animate()
            stationDescLabel.isHidden = true
        } else {
            stationDescLabel.isHidden = false
        }
        
        view.setNeedsDisplay()
    }
    
    private func isPlayingDidChange(_ isPlaying: Bool) {
        playingButton.isSelected = isPlaying
        startNowPlayingAnimation(isPlaying)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState, animate: Bool) {
        
        let message: String?
        
        switch playbackState {
        case .paused:
            message = "Station Paused..."
        case .playing:
            message = nil
        case .stopped:
            message = "Station Stopped..."
        }
        
        updateLabels(with: message, animate: animate)
        isPlayingDidChange(radioPlayer.isPlaying)
    }
    
    func playerStateDidChange(_ state: FRadioPlayerState, animate: Bool) {
        
        let message: String?
        
        switch state {
        case .loading:
            message = "Loading Station ..."
        case .urlNotSet:
            message = "Station URL not valid"
        case .readyToPlay, .loadingFinished:
            playbackStateDidChange(radioPlayer.playbackState, animate: animate)
            return
        case .error:
            message = "Error Playing"
        }
        
        updateLabels(with: message, animate: animate)
    }
    
    func optimizeForDeviceSize() {
        let deviceHeight = self.view.bounds.height
        
        if deviceHeight == 480 {
            albumHeightConstraint.constant = 106
            view.updateConstraints()
        } else if deviceHeight == 667 {
            albumHeightConstraint.constant = 230
            view.updateConstraints()
        } else if deviceHeight > 667 {
            albumHeightConstraint.constant = 260
            view.updateConstraints()
        }
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {
        
        guard let statusMessage = statusMessage else {
            songLabel.text = currentTrack.title

            shouldAnimateSongLabel(animate)
            return
        }
        
        guard songLabel.text != statusMessage else { return }
        
        songLabel.text = statusMessage
        
        if animate {
//            songLabel.animation = "flash"
//            songLabel.repeatCount = 3
//            songLabel.animate()
        }
    }

    
    func shouldAnimateSongLabel(_ animate: Bool) {
        guard animate, currentTrack.title != currentStation.name else { return }
//
//        songLabel.animation = "zoomIn"
//        songLabel.duration = 1.5
//        songLabel.damping = 1
//        songLabel.animate()
    }
    
    func createNowPlayingAnimation() {
        
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
        nowPlayingImageView.autoresizingMask = []
        nowPlayingImageView.contentMode = UIView.ContentMode.center
        
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
      
        let button = UIButton(type: .custom)
       
        button.frame = CGRect(x: 8, y: 10, width: 40, height: 40)
        button.isOpaque = true
        button.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = button.center
       
        self.view.addSubview(button)
        
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
    @IBAction func addToCollectionTapped(_ sender: Any) {
        
        if currentStation.isFavorite == true {
            currentStation.isFavorite = false
        } else {
            currentStation.isFavorite = true
        }
        
        favoriteChangeState(isFavorite: currentStation.isFavorite)
        
        currentStation.write(dataSource: RealmDataPersistence.shared)
        
        
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let songToShare = "I'm listening to \(currentTrack.title) on \(currentStation.name)"
        let activityViewController = UIActivityViewController(activityItems: [songToShare, currentTrack.artworkImage!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                // do something on completion if you want
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

