//
//  SPSearchViewController.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/26/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit
import FRadioPlayer
import MediaPlayer
import AVFoundation
import ProgressHUD

class SPHomeViewController: UIViewController {
    weak var mainCollectionView: UICollectionView!
    private var homeViewModel: SPHomeViewModel?
    weak var nowPlayingViewController: SPNowPlayingViewController?
    weak var headerView: NewsViewReuse?
    var nowPlayingImageView: UIImageView!
    
    private var newChannel = false
   
    let radioPlayer = RadioPlayer()
    
    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
   
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.width , height: 180)
        return layout
    }()
    
    override func loadView() {
        super.loadView()
        setupMainCollectionView()

        setupViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel = viewModel as? SPHomeViewModel {
            homeViewModel = viewModel
            viewModel.delegate = self
        }
        
        homeViewModel?.loadStationsFromJSON()
       
        radioPlayer.delegate = self
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.title = "Search"
       
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "ONEWORLDRADIO"
      
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
  
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.register(UINib(nibName: Resources.reusableIdentifiers.NewsViewReuse, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Resources.reusableIdentifiers.NewsViewReuse)
        
        self.mainCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: Resources.reusableIdentifiers.searchCell)
        
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPlayerStatus()
        nowPlayingButtonTitleAnimate()
    }
    
    private func checkPlayerStatus() {
        var headerDesc = ""
        let sharedPlayer = FRadioPlayer.shared
        let playerStatus = sharedPlayer.playbackState.description
        let url = sharedPlayer.radioURL
      
        guard let viewModel = homeViewModel else {return}
        for station in viewModel.stations  {
            if let playingUrl = url?.absoluteString, station.url == playingUrl {
                headerDesc = station.name
            }
        }
        
        if playerStatus == "Player is playing"{
            self.headerView?.nowPlayingAnimationImageView.isHidden = false
            self.headerView?.nowPlayingButton.isUserInteractionEnabled = true
        } else {
            self.headerView?.nowPlayingAnimationImageView.isHidden = true
            self.headerView?.nowPlayingButton.isUserInteractionEnabled = false
        }
        
        self.headerView?.nowPlayingButton.setTitle(headerDesc, for: .normal)
  
    }
    
    private func nowPlayingButtonTitleAnimate() {
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 2
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        headerView?.nowPlayingButton.layer.add(pulseAnimation, forKey: "animateOpacity")
    }
    
    private func checkFontNames() {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    

    private func setupMainCollectionView() {
        let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.isScrollEnabled = true
        mainCollectionView.alwaysBounceVertical = true
        mainCollectionView.frame = CGRect(x: 0, y: -60, width: self.view.width, height: self.view.height)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainCollectionView)
        
        self.mainCollectionView = mainCollectionView
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        if headerView != nil {
            headerView!.buttonBar.frame.origin.x = (headerView!.frame.width / CGFloat(headerView!.segment.numberOfSegments)) * CGFloat(headerView!.segment.selectedSegmentIndex)
        }
        
        ProgressHUD.show()
        
        guard let homeViewModel = homeViewModel else {return}
        switch headerView?.segment.selectedSegmentIndex
        {
        case 0:
            homeViewModel.selectedCountry =  homeViewModel.countryList[0]
            gSelectedCountry = homeViewModel.countryList[0]
        case 1:
            homeViewModel.selectedCountry =  homeViewModel.countryList[1]
            gSelectedCountry = homeViewModel.countryList[1]
        default:
            break
        }
        
    }
    
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor.white])
        refreshControl.backgroundColor = .black
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mainCollectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        homeViewModel?.loadStationsFromJSON()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
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
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Next Command
        commandCenter.nextTrackCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Previous Command
        commandCenter.previousTrackCommand.addTarget { event in
            return .success
        }
    }
    
    private func resetCurrentStation() {
        radioPlayer.resetRadioPlayer()
        
        //self.headerView?.playButton.imageView?.stopAnimating()
        self.headerView?.nowPlayingButton.setTitle("Choose a station above to begin", for: .normal)
        self.headerView?.nowPlayingButton.isEnabled = false
    
        navigationItem.rightBarButtonItem = nil
    }
    
    private func updateNowPlayingButton(station: RadioStation?, track: Track?) {
        guard let station = station else { resetCurrentStation(); return }
        
        var playingTitle = station.name + ": "
        
        if track?.title == station.name {
            playingTitle += "Now playing ..."
        } else if let track = track {
            playingTitle += track.title
        }
        
        self.headerView?.nowPlayingButton.setTitle(playingTitle, for: .normal)
        self.headerView?.nowPlayingButton.isEnabled = true
        //self.headerView?.playButton.setImage(UIImage(named: "btn-nowPlaying"), for: .normal)
        //self.headerView?.playButton.addTarget(self, action: #selector(nowPlayingPressed), for: .touchUpInside)
    }
    
    @objc func nowPlayingBarButtonPressed() {
        let radioStoryboard = UIStoryboard.init(name: Resources.StoryboardName.radioStoryboard, bundle: nil)
        let viewController = radioStoryboard.instantiateViewController(withIdentifier: Resources.ViewControllerIds.SPNowPlayingViewController) as! SPNowPlayingViewController
        
        viewController.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: newChannel)
        nowPlayingViewController = viewController
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func nowPlayingPressed(_ sender: UIButton) {
        let radioStoryboard = UIStoryboard.init(name: Resources.StoryboardName.radioStoryboard, bundle: nil)
        let viewController = radioStoryboard.instantiateViewController(withIdentifier: Resources.ViewControllerIds.SPNowPlayingViewController) as! SPNowPlayingViewController
        viewController.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: newChannel)
        nowPlayingViewController = viewController
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    

    func startNowPlayingAnimation(_ animate: Bool) {
        //animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
    private func getIndex(of station: RadioStation?) -> Int? {
        guard let homeViewModel = homeViewModel else {return nil}
        guard let station = station, let index = homeViewModel.stations.index(of: station) else { return nil }
        return index
    }
    
}

extension SPHomeViewController: ViewControllerable {
    var name: String {
        return ViewControllerType.searchViewController
    }
    
    var tabItemImageString: String {
        return Resources.ImageNames.search
    }
    
    var viewModel: Any? {
        return SPHomeViewModel()
    }
    
    func setupViewController() {
        self.view.backgroundColor = AppColor.tabBar.value
    }
}

extension SPHomeViewController: SPHomeViewModelProtocol {
    func haveUpdateStations() {
        mainQueue {
            self.mainCollectionView.reloadData()
            ProgressHUD.showSuccess()
        }
    }
}

extension SPHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.numberOfCategories() ?? 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.reusableIdentifiers.searchCell, for: indexPath) as? HomeCollectionViewCell {
            guard let homeViewModel = self.homeViewModel else {
                return UICollectionViewCell()
            }
            
            switch indexPath.row {
            case 0:
                cell.stations = homeViewModel.usStations
                cell.categoryString = RadioStationCategory.US.categoryName
            case 1:
                cell.stations = homeViewModel.ukStations
                cell.categoryString = RadioStationCategory.UK.categoryName
            default:
                print("Nothing here")
            }
            
            cell.homeViewModel = self.homeViewModel
            
            cell.stationSelectVoidClosure = { [weak self] in
                let station = self?.homeViewModel?.stations[indexPath.row]
                self?.radioPlayer.station =  station
                self?.nowPlayingBarButtonPressed()
                self?.newChannel = false
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension SPHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Resources.reusableIdentifiers.NewsViewReuse, for: indexPath)
            view.backgroundColor = UIColor.white
        self.headerView = view as? NewsViewReuse
        self.headerView?.segment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.headerView?.nowPlayingClosure = { [weak self] in
            self?.newChannel = false
            self?.radioPlayer.station = currentGlobalStation
            self?.nowPlayingBarButtonPressed()
        }
        
        self.headerView?.searchClosure = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
            
        }
        
        self.headerView?.myCollectionClosure = { [weak self] in
            self?.tabBarController?.selectedIndex = 2
            
        }
        
    
            
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension SPHomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Resources.Sizes.halfInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: Resources.Sizes.halfInset, left: Resources.Sizes.halfInset, bottom: Resources.Sizes.halfInset, right: Resources.Sizes.halfInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 250)
    }
    
}


extension SPHomeViewController: RadioPlayerDelegate {
    
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

extension SPHomeViewController {
    
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

extension SPHomeViewController: NowPlayingViewControllerDelegate {
    
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
