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



class PodcastDetailedEpisode: UIView {
    
    
    var podcastEpisode: PodcastEpisode! {
        
        didSet{
            episodeTitle.text = podcastEpisode.title
            authorLabel.text = podcastEpisode.author
            guard let url = URL(string: podcastEpisode?.imageUrl ?? "") else {return}
            episodeImage.sd_setImage(with: url, completed: nil)
            fetchPlayer()
        }
        
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
        self.removeFromSuperview()
        
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
            setImageBackToOriginalSize()

    }
    else {
    player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
             scaleDownImage()

    }
    }
    
    
    fileprivate func observeStartResize() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.setImageBackToOriginalSize()
        }
    }
    
    fileprivate func updateSlider() {
    
    let trackingTimeSeconds = CMTimeGetSeconds(player.currentTime())
    
    let TSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
    let percentage =  trackingTimeSeconds / TSeconds
    self.timeSlider.value =  Float(percentage)
    
    }
    
    fileprivate func startEndSlider() {
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (progresstime) in
            
            let currentTime = progresstime.toProgressTime()
            self.startTimeLabel.text = currentTime
            
            guard let podcastDuration = self.player.currentItem?.duration else {return}
            
            self.endTimeLabel.text = podcastDuration.toProgressTime()
//            let trackingTimeSeconds = CMTimeGetSeconds(progresstime)
//             let TSeconds = CMTimeGetSeconds(podcastDuration)
//            self.timeSlider.value =  Float(trackingTimeSeconds / TSeconds)
            self.updateSlider()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeStartResize()
        
        startEndSlider()
    }
    
    
    
    
    //MARK:- IBOutlets setUP
    
    
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
        let seekTime = CMTimeMake(Int64(currentValue), Int32(NSEC_PER_SEC))
    
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
