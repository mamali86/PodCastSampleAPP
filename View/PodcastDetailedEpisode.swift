//
//  PodcastDetailedEpisode.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 06/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
//import SDWebImage
import AVKit
import MediaPlayer



class PodcastDetailedEpisode: UIView  {
    
    var podcastEpisode: PodcastEpisode! {
        
        didSet{
            episodeTitle.text = podcastEpisode.title
            miniEpisodeTitle.text = podcastEpisode.title
            authorLabel.text = podcastEpisode.author
            guard let url = URL(string: podcastEpisode?.imageUrl ?? "") else {return}
            episodeImage.sd_setImage(with: url, completed: nil)
            minimisedEpisodeImage.sd_setImage(with: url) { (image, _, _, _) in
                
                var nowPlaying = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                let image = self.episodeImage.image ?? UIImage()
                
                let artWorkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (_) -> UIImage in
                    return image
                })
                nowPlaying?[MPMediaItemPropertyArtwork] = artWorkItem
                
                
                 MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
            }
            
            setupPlayingNowInfo()
            fetchPlayer()
        }
    }
    
    
    fileprivate func setupPlayingNowInfo() {
        
        var nowPlaying = [String: Any]()
        
        nowPlaying[MPMediaItemPropertyTitle] = podcastEpisode.title
        nowPlaying[MPMediaItemPropertyArtist] = podcastEpisode.author
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
        
    }
    
        let player: AVPlayer = {
            let avpPlayer = AVPlayer()
            avpPlayer.automaticallyWaitsToMinimizeStalling = false
            return avpPlayer
        }()
    
    
    fileprivate func fetchPlayer(){
        guard let url = URL(string: podcastEpisode.podCastUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }

    
    @IBAction func handleDismiss(_ sender: Any) {
//        self.removeFromSuperview()

        UIApplication.mainTabBarController()?.minimisePlayerDetails(podcastEpisode: podcastEpisode)
        
    }
    
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    fileprivate func setImageBackToOriginalSize() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImage.transform = CGAffineTransform.identity

        }, completion: nil)
    }
    
    
    fileprivate func scaleDownImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImage.transform = self.shrunkenTransform
            
        }, completion: nil)
    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet{
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handleplayPause), for: .touchUpInside)
        }
    }
    
    @objc func handleplayPause() {
        if player.timeControlStatus == .paused {
    player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPausePlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            setImageBackToOriginalSize()

    }
    else {
    player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPausePlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)

             scaleDownImage()

    }
    }
    
    
    fileprivate func observeStartResize() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
//        player has refrence to self
//        self has  a refrence to player
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.setImageBackToOriginalSize()
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.setupLockScreenCurrentTime()
        }
    }
    
    
    static func initFromNib() -> PodcastDetailedEpisode {
        return Bundle.main.loadNibNamed("PodcastDetailedEpisode", owner: self, options: nil)?.first as! PodcastDetailedEpisode
    }
    
    
    deinit {
        print("podcastDeialedEpisode being reclaimed ")
    }
    
    
    
    fileprivate func updateSlider() {
    
    let trackingTimeSeconds = CMTimeGetSeconds(player.currentTime())
    
    let TSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
    let percentage =  trackingTimeSeconds / TSeconds
    self.timeSlider.value =  Float(percentage)
    
    }
    
    fileprivate func startEndSlider() {
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self]  (progresstime) in
            
            let currentTime = progresstime.toProgressTime()
            self?.startTimeLabel.text = currentTime
            
            guard let podcastDuration = self?.player.currentItem?.duration else {return}
            
            
            self?.endTimeLabel.text = podcastDuration.toProgressTime()

            self?.updateSlider()
            
        }
    }
    
    
    var panGesture: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpRemoteControll()
        setUpAudioSession()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        minimisedStackView.addGestureRecognizer(panGesture)
        
        MaximisedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleMaximisedPan)))
        
        observeStartResize()
        startEndSlider()
        
        

    }
    
    fileprivate func setupLockScreenCurrentTime(){
        
        guard let currentItem = player.currentItem else {return}
        let durationSeconds = CMTimeGetSeconds(currentItem.duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    fileprivate func setUpRemoteControll() {
    UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCentre = MPRemoteCommandCenter.shared()
        
        commandCentre.playCommand.isEnabled = true
        commandCentre.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.miniPausePlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.setupElapsedTime()
            return .success
        }
        
        
        commandCentre.pauseCommand.isEnabled = true
        commandCentre.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.player.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.miniPausePlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.setupElapsedTime()
            return .success
        }
        
        
        commandCentre.togglePlayPauseCommand.isEnabled = true
        commandCentre.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handleplayPause()
            return .success
        }
        
        
        commandCentre.nextTrackCommand.isEnabled = true
        
        commandCentre.nextTrackCommand.addTarget(self, action: #selector(handleNextEpisode))
        
        
        commandCentre.previousTrackCommand.isEnabled = true
        commandCentre.previousTrackCommand.addTarget(self, action: #selector(handlePreviousEpisode))
    
    }
    
    var podcastPlayListEpisodes = [PodcastEpisode]()
    
    @objc fileprivate func handlePreviousEpisode(){
        
        if podcastPlayListEpisodes.count == 0 {
            return
        }
        var previousEpisode: PodcastEpisode?
        let currentEpisodeIndex = podcastPlayListEpisodes.index { (episode) -> Bool in
            return self.podcastEpisode.title == episode.title && self.podcastEpisode.author == episode.author
        }

        guard let index = currentEpisodeIndex else {return}
        
        if index == 0 {
            previousEpisode = podcastPlayListEpisodes[podcastPlayListEpisodes.count - 1]
            
            } else {
            
            previousEpisode = podcastPlayListEpisodes[index - 1]
        }
        
         self.podcastEpisode = previousEpisode
    }
    
    
    @objc fileprivate func handleNextEpisode(){
     
//        podcastPlayListEpisodes.forEach({print($0.title)})
        
        if podcastPlayListEpisodes.count == 0 {
            return
        }
        var nextEpisode: PodcastEpisode?
        let currentEpisodeIndex = podcastPlayListEpisodes.index { (episode) -> Bool in
            return self.podcastEpisode.title == episode.title && self.podcastEpisode.author == episode.author
        }
        
        guard let index = currentEpisodeIndex else {return}
        
        if index == podcastPlayListEpisodes.count - 1 {
           nextEpisode = podcastPlayListEpisodes[0]
        }
        else {
            nextEpisode = podcastPlayListEpisodes[index + 1]
        }
        
        self.podcastEpisode = nextEpisode
        
        
    }
    
    
    fileprivate func setupElapsedTime(){
                let elapsedTime = CMTimeGetSeconds(player.currentTime())
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime


        
    }
    
    fileprivate func setUpAudioSession() {
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

        } catch let sessionErr {
            print("failed to activate session", sessionErr)
            
        }
        
    }
    

    @objc func handleMaximisedPan(gesture: UIPanGestureRecognizer) {
    
        let translation = gesture.translation(in: self.superview)
        
        
        if gesture.state == .changed {
            
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            
            self.transform = CGAffineTransform.identity

            if translation.y > 50 {
                
             UIApplication.mainTabBarController()?.minimisePlayerDetails(podcastEpisode: nil)
                
                
            }
            
        }
    }
    
    @objc func handleTapMaximize() {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        UIApplication.mainTabBarController()?.maximisePlayerDetails(podcastEpisode: nil)
        }, completion: nil)
        }
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        
        if gesture.state == .changed {
            
            handleGestureChanged(gesture: gesture)
            
        } else if gesture.state == .ended {
            
            handleGestureEnded(gesture: gesture)
        
        }
    }
    
    func handleGestureChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        minimisedStackView.alpha = 1 + translation.y / 200
        MaximisedStackView.alpha = -translation.y / 200
        
    }
    
    func handleGestureEnded(gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.translation(in: self.superview)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = CGAffineTransform.identity

            
            if translation.y < -200 || velocity.y < -500 {
                
                UIApplication.mainTabBarController()?.maximisePlayerDetails(podcastEpisode: nil)
            } else {
            self.minimisedStackView.alpha = 1
            self.MaximisedStackView.alpha = 0
            
            }
        }, completion: nil)
        
    }
    
    
    
    
    //MARK:- IBOutlets setUP
    
    
    
    @IBOutlet weak var minimisedStackView: UIView!
    
    
    @IBOutlet weak var minimisedEpisodeImage: UIImageView! {
        
        didSet{
            
            minimisedEpisodeImage.layer.cornerRadius = 5
            minimisedEpisodeImage.clipsToBounds = true

            minimisedEpisodeImage.clipsToBounds = true
        }
    }
    

    @IBOutlet weak var miniEpisodeTitle: UILabel!
    
    
    @IBOutlet weak var miniPausePlay: UIButton!{
        
        didSet{
            
            miniPausePlay.addTarget(self, action: #selector(handleplayPause), for: .touchUpInside)
        }
        
    }
    
    
    @IBAction func miniFastForward(_ sender: Any) {
         seekToCurrentTime(delta: 15)
    }
    
    
    
    @IBOutlet weak var MaximisedStackView: UIStackView!

    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel! {
        
        didSet{
            endTimeLabel.text = "--:--:--"
        }
    }
    
    @IBOutlet weak var timeSlider: UISlider! {
        didSet {
            timeSlider.value = 0
            
        }
        
    }
    
    
    @IBAction func handleSliderCurrentTime(_ sender: Any) {
        
        if let duration = player.currentItem?.duration {
        let totalSeconds = CMTimeGetSeconds(duration)
        let currentValue =  totalSeconds * Float64(timeSlider.value)
        let seekTime = CMTimeMake(Int64(currentValue), 1)
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentValue
            
            
    
        player.seek(to: seekTime) { (completedSeek) in
            
        }
    }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    

    @IBAction func fastForward(_ sender: Any) {
     seekToCurrentTime(delta: 15)
    }
    
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let currentTime = player.currentTime()
        let changeTime = CMTimeMake(delta, 1)
        let moveTo = CMTimeAdd(currentTime, changeTime)
        player.seek(to: moveTo) { (completedSeek) in
            
        }
        
    }
    
    
    @IBOutlet weak var episodeImage: UIImageView!{
        
        didSet{
            episodeImage.layer.cornerRadius = 5
            episodeImage.clipsToBounds = true
            episodeImage.transform = shrunkenTransform
            
        }
        
    }
    @IBOutlet weak var episodeTitle: UILabel! {
        
        didSet{
            episodeTitle.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        
        player.volume = sender.value
    }
    
    
    
    
}
