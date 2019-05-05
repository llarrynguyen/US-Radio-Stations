//
//  SearchCollectionViewCell.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/21/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import FRadioPlayer
import MediaPlayer
import AVFoundation

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    
    var homeViewModel: SPHomeViewModel?
    
    weak var nowPlayingViewController: SPNowPlayingViewController?
    private var newChannel = false
    
    let radioPlayer = RadioPlayer()
    
    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    var stations = [RadioStation]() {
        didSet {
            guard stations != oldValue else { return }
            mainQueue {
                self.collectionView.reloadData()
            }
        }
    }
    
    var stationSelectVoidClosure: VoidClosureParameter?
    
    weak var collectionView: UICollectionView!
    weak var label: UILabel!
    weak var bgImageView: UIImageView!
    
    var categoryString: String = "" {
        didSet {
            label.text = categoryString
        }
    }
    
    lazy var layout : UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBG()
        setupCategoryLabel()
        setupCollectionView()
        setup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBG()
        setupCategoryLabel()
        setupCollectionView()
        setup()
    }
    
    private func setup() {
        
        self.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.backgroundColor = .black
        self.contentView.backgroundColor = .clear
        
        radioPlayer.delegate = self
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            fatalError()
        }
    }
    
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor.white])
        refreshControl.backgroundColor = .black
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        homeViewModel?.loadStationsFromJSON()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.setNeedsDisplay()
        }
    }
    
    private func updateLockScreen(with track: Track?) {
        
        var nowPlayingInfo = [String : Any]()
        
        if let image = track?.artworkImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size -> UIImage in
                return image
            })
        }
        
        if let title = track?.title {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupRemoteCommandCenter() {
    
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { event in
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { event in
            return .success
        }
    }
    
    private func resetCurrentStation() {
        radioPlayer.resetRadioPlayer()
        
//        self.headerView?.playButton.imageView?.stopAnimating()
//        self.headerView?.nowPlayingButton.setTitle("Choose a station above to begin", for: .normal)
//        self.headerView?.nowPlayingButton.isEnabled = false
//
//        navigationItem.rightBarButtonItem = nil
    }
    
    private func updateNowPlayingButton(station: RadioStation?, track: Track?) {
        guard let station = station else { resetCurrentStation(); return }
        
        var playingTitle = station.name + ": "
        
        if track?.title == station.name {
            playingTitle += "Now playing ..."
        } else if let track = track {
            playingTitle += track.title
        }
        
//        self.headerView?.nowPlayingButton.setTitle(playingTitle, for: .normal)
//        self.headerView?.nowPlayingButton.isEnabled = true
//        self.headerView?.playButton.setImage(UIImage(named: "btn-nowPlaying"), for: .normal)
//        self.headerView?.playButton.addTarget(self, action: #selector(nowPlayingPressed), for: .touchUpInside)
    }
    
    
    func startNowPlayingAnimation(_ animate: Bool) {
        //animate ? self.headerView?.playButton.imageView?.startAnimating() : self.headerView?.playButton.imageView?.stopAnimating()
    }
    
    @objc func nowPlayingBarButtonPressed() {
        let radioStoryboard = UIStoryboard.init(name: Resources.StoryboardName.radioStoryboard, bundle: nil)
        let viewController = radioStoryboard.instantiateViewController(withIdentifier: Resources.ViewControllerIds.SPNowPlayingViewController) as! SPNowPlayingViewController
        viewController.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: newChannel)
        
        nowPlayingViewController = viewController
        viewController.delegate = self
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func nowPlayingPressed(_ sender: UIButton) {
        let radioStoryboard = UIStoryboard.init(name: Resources.StoryboardName.radioStoryboard, bundle: nil)
        let viewController = radioStoryboard.instantiateViewController(withIdentifier: Resources.ViewControllerIds.SPNowPlayingViewController) as! SPNowPlayingViewController
        viewController.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: newChannel)
        nowPlayingViewController = viewController
        viewController.delegate = self
        self.parentViewController?.present(viewController, animated: true, completion: nil)
    }
    
    
    private func getIndex(of station: RadioStation?) -> Int? {
        guard let homeViewModel = homeViewModel else {return nil}
        guard let station = station, let index = homeViewModel.stations.index(of: station) else { return nil }
        return index
    }

    private func setupCategoryLabel() {
        let label = UILabel(frame: CGRect(x: 16 , y: 0, width: 100, height: 100))
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        let arrowImage = UIImageView(frame: CGRect(x: label.width - 56, y: 0, width: 40, height: 40))
        arrowImage.image = UIImage(named: "icons8-expand_arrow_filled")
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        label.addSubview(arrowImage)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            arrowImage.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0),
            arrowImage.heightAnchor.constraint(equalToConstant: 30),
            arrowImage.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -16),
            arrowImage.widthAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 80),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
            ])
        
        self.label = label
        
    }
    
    private func setupCollectionView(){
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 10
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
       
        
        collectionView.register(UINib(nibName: Resources.NibName.StationNib, bundle: nil), forCellWithReuseIdentifier: Resources.reusableIdentifiers.stationCell)
    
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.setNeedsUpdateConstraints()
        
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        
    self.collectionView = collectionView
    self.collectionView.isHidden = true
    }
    
    private func setupBG(){
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
    
        
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
            ])
        
        self.bgImageView = imageView
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
}

extension HomeCollectionViewCell: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        radioPlayer.station =  station
        nowPlayingBarButtonPressed()
    }
}

extension HomeCollectionViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let station = stations[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.reusableIdentifiers.stationCell, for: indexPath) as? StationCollectionViewCell {
           
            cell.update(station: station)
            
            return cell
        }
        return UICollectionViewCell()
    }
}


extension HomeCollectionViewCell: RadioPlayerDelegate {
    
    func playerStateDidChange(_ playerState: FRadioPlayerState) {
        nowPlayingViewController?.playerStateDidChange(playerState, animate: true)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState) {
        nowPlayingViewController?.playbackStateDidChange(playbackState, animate: true)
        startNowPlayingAnimation(radioPlayer.player.isPlaying)
    }
    
    func trackDidUpdate(_ track: Track?) {
        updateLockScreen(with: track)
        updateNowPlayingButton(station: radioPlayer.station, track: track)
        updateHandoffUserActivity(userActivity, station: radioPlayer.station, track: track)
        nowPlayingViewController?.updateTrackMetadata(with: track)
    }
    
    func trackArtworkDidUpdate(_ track: Track?) {
        updateLockScreen(with: track)
        nowPlayingViewController?.updateTrackArtwork(with: track)
    }
}

extension HomeCollectionViewCell {
    
    func setupHandoffUserActivity() {
        userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity?.becomeCurrent()
    }
    
    func updateHandoffUserActivity(_ activity: NSUserActivity?, station: RadioStation?, track: Track?) {
        guard let activity = activity else { return }
        activity.webpageURL = (track?.title == station?.name) ? nil : getHandoffURL(from: track)
        updateUserActivityState(activity)
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
    }
    
    private func getHandoffURL(from track: Track?) -> URL? {
        guard let track = track else { return nil }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "google.com"
        components.path = "/search"
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: "q", value: track.title))
        return components.url
    }
}

extension HomeCollectionViewCell: NowPlayingViewControllerDelegate {
    
    func didPressPlayingButton() {
        radioPlayer.player.togglePlaying()
    }
    
    func didPressStopButton() {
        radioPlayer.player.stop()
    }
    
    func didPressNextButton() {
        guard let homeViewModel = homeViewModel else {return}
        guard let index = getIndex(of: radioPlayer.station) else { return }
        radioPlayer.station = (index + 1 == homeViewModel.stations.count) ? homeViewModel.stations[0] : homeViewModel.stations[index + 1]
        handleRemoteStationChange()
    }
    
    func didPressPreviousButton() {
        guard let homeViewModel = homeViewModel else {return}
        guard let index = getIndex(of: radioPlayer.station) else { return }
        radioPlayer.station = (index == 0) ? homeViewModel.stations.last : homeViewModel.stations[index - 1]
        handleRemoteStationChange()
    }
    
    func handleRemoteStationChange() {
        if let nowPlayingVC = nowPlayingViewController {
            // If nowPlayingVC is presented
            nowPlayingVC.load(station: radioPlayer.station, track: radioPlayer.track)
            nowPlayingVC.stationDidChange()
        } else if let station = radioPlayer.station {
            // If nowPlayingVC is not presented (change from remote controls)
            radioPlayer.player.radioURL = URL(string: station.url)
        }
    }
}
