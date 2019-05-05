//
//  SPSectorViewController.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/26/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import FRadioPlayer
import MediaPlayer
import AVFoundation

class SPMyCollectionViewController: UIViewController {

    
    let radioPlayer = RadioPlayer()
    weak var nowPlayingViewController: SPNowPlayingViewController?
    
    weak var topView: NewsView!
    weak var mainCollectionView: UICollectionView!
    
    private var myCollectionViewModel: SPMyCollectionViewModel?
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
        layout.itemSize = CGSize(width: (self.view.width - 24)/3, height: 170)
        return layout
    }()
    
    
    override func loadView() {
        super.loadView()
        setupTopView()
        setupMainCollectionView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel = viewModel as? SPMyCollectionViewModel {
            myCollectionViewModel = viewModel
            
        }
        
        setupViewController()
        
        self.mainCollectionView.register(UINib(nibName: Resources.NibName.StationNib, bundle: nil), forCellWithReuseIdentifier: Resources.reusableIdentifiers.stationCell)
        
        setup()
        
         NotificationCenter.default.addObserver(self, selector: #selector(radioDidUpdate), name: .radioDataChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topView.searchBar.placeholder = "Search radio stations in your collection"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func radioDidUpdate(_ sender: Any) {
        self.mainCollectionView.reloadData()
    }
    
    private func setup() {
        radioPlayer.delegate = self
        
       
    }
    
    private func setupMainCollectionView() {
        let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.isScrollEnabled = true
        mainCollectionView.alwaysBounceVertical = true
        mainCollectionView.frame = CGRect(x: 0, y: topView.frame.height, width: self.view.width, height: self.view.height)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        self.view.addSubview(mainCollectionView)
        
        self.mainCollectionView = mainCollectionView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.mainCollectionView.isUserInteractionEnabled = true
        self.mainCollectionView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    fileprivate func setupTopView(){
        let topView = NewsView()
        topView.frame = CGRect(x: 0, y: -60, width: self.view.frame.width, height: 250)
        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -60),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            ])
        
        self.topView = topView
        self.topView.titleLabel.text = "MY COLLECTION"
        self.topView.searchBar.placeholder = "Search in your collection..."
        self.topView.searchBar.delegate = self
    }
    
    @objc func nowPlayingBarButtonPressed() {
        let radioStoryboard = UIStoryboard.init(name: Resources.StoryboardName.radioStoryboard, bundle: nil)
        let viewController = radioStoryboard.instantiateViewController(withIdentifier: Resources.ViewControllerIds.SPNowPlayingViewController) as! SPNowPlayingViewController
        viewController.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: true)
        
        nowPlayingViewController = viewController
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
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
    
    private func getIndex(of station: RadioStation?) -> Int? {
        guard let myCollectionViewModel = myCollectionViewModel else {return nil}
        guard let station = station, let index = myCollectionViewModel.yourStations.index(of: station) else { return nil }
        return index
    }
    
    
    
}

extension SPMyCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCollectionViewModel?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let station = myCollectionViewModel?.yourStations[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.reusableIdentifiers.stationCell, for: indexPath) as? StationCollectionViewCell {
            if let station = station {
                cell.update(station: station)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension SPMyCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let station = myCollectionViewModel?.yourStations[indexPath.row] {
            radioPlayer.station =  station
            nowPlayingBarButtonPressed()
        }
    }
}

extension SPMyCollectionViewController: ViewControllerable {
    var name: String {
        return ViewControllerType.sectorViewController
    }
    
    var tabItemImageString: String {
        return Resources.ImageNames.sector
    }
    
    var viewModel: Any? {
        return SPMyCollectionViewModel()
        
    }
    
    func setupViewController() {
        self.view.backgroundColor = AppColor.mainBackgroud.value
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

extension SPMyCollectionViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        myCollectionViewModel?.searchText = searchText
        self.mainCollectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}


extension SPMyCollectionViewController: RadioPlayerDelegate {
    
    func playerStateDidChange(_ playerState: FRadioPlayerState) {
        nowPlayingViewController?.playerStateDidChange(playerState, animate: true)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState) {
        nowPlayingViewController?.playbackStateDidChange(playbackState, animate: true)
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

extension SPMyCollectionViewController {
    
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

extension SPMyCollectionViewController: NowPlayingViewControllerDelegate {
    
    func didPressPlayingButton() {
        radioPlayer.player.togglePlaying()
    }
    
    func didPressStopButton() {
        radioPlayer.player.stop()
    }
    
    func didPressNextButton() {
        guard let myCollectionViewModel = myCollectionViewModel else {return}
        guard let index = getIndex(of: radioPlayer.station) else { return }
        radioPlayer.station = (index + 1 == myCollectionViewModel.yourStations.count) ? myCollectionViewModel.yourStations[0] : myCollectionViewModel.yourStations[index + 1]
        handleRemoteStationChange()
    }
    
    func didPressPreviousButton() {
        guard let myCollectionViewModel = myCollectionViewModel else {return}
        guard let index = getIndex(of: radioPlayer.station) else { return }
        radioPlayer.station = (index == 0) ? myCollectionViewModel.yourStations.last : myCollectionViewModel.yourStations[index - 1]
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


