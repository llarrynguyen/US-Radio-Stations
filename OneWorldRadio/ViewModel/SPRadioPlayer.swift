//
//  SPRadioPlayer.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/11/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import FRadioPlayer

protocol RadioPlayerDelegate: class {
    func playerStateDidChange(_ playerState: FRadioPlayerState)
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState)
    func trackDidUpdate(_ track: Track?)
    func trackArtworkDidUpdate(_ track: Track?)
}


class RadioPlayer {
    
    weak var delegate: RadioPlayerDelegate?
    
    let player = FRadioPlayer.shared
    
    var station: RadioStation? {
        didSet { resetTrack(with: station) }
    }
    
    private(set) var track: Track?
    
    init() {
        player.delegate = self
    }
    
    func resetRadioPlayer() {
        station = nil
        track = nil
        player.radioURL = nil
    }
    
 
    func updateTrackMetadata(trackName: String) {
        if track == nil {
            track = Track(title: trackName)
        } else {
            track?.title = trackName
        }
        
        delegate?.trackDidUpdate(track)
    }
    
    // Update the track artwork with a UIImage
    func updateTrackArtwork(with image: UIImage, artworkLoaded: Bool) {
        track?.artworkImage = image
        track?.artworkLoaded = artworkLoaded
        delegate?.trackArtworkDidUpdate(track)
    }
    
    // Reset the track metadata and artwork to use the current station infos
    func resetTrack(with station: RadioStation?) {
        guard let station = station else { track = nil; return }
        updateTrackMetadata(trackName: station.name)
        resetArtwork(with: station)
    }
    
    // Reset the track Artwork to current station image
    func resetArtwork(with station: RadioStation?) {
        guard let station = station else { track = nil; return }
        getStationImage(from: station) { image in
            self.updateTrackArtwork(with: image, artworkLoaded: false)
        }
    }
    
    //*****************************************************************
    // MARK: - Private helpers
    //*****************************************************************
    
    private func getStationImage(from station: RadioStation, completionHandler: @escaping (_ image: UIImage) -> ()) {
        
        if station.logo.range(of: "http") != nil {
            // load current station image from network
            ImageDownloader.sharedLoader.imageForUrl(urlString: station.logo) { (image, stringURL) in
                completionHandler(image ?? #imageLiteral(resourceName: "albumArt"))
            }
        } else {
            // load local station image
            let image = UIImage(named: station.logo) ?? #imageLiteral(resourceName: "albumArt")
            completionHandler(image)
        }
    }
}

extension RadioPlayer: FRadioPlayerDelegate {
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        delegate?.playerStateDidChange(state)
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        delegate?.playbackStateDidChange(state)
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        guard
            let artistName = artistName, !artistName.isEmpty,
            let trackName = trackName, !trackName.isEmpty else {
                resetTrack(with: station)
                return
        }
        
        updateTrackMetadata(trackName: trackName)
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        guard let artworkURL = artworkURL else { resetArtwork(with: station); return }
        
        ImageDownloader.sharedLoader.imageForUrl(urlString: artworkURL.absoluteString) { (image, stringURL) in
            guard let image = image else { self.resetArtwork(with: self.station); return }
            self.updateTrackArtwork(with: image, artworkLoaded: true)
        }
    }
}

