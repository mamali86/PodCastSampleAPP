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
    
    
    func fetchPlayer(){
        
        guard let url = URL(string: podcastEpisode.podCastUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        
    }

    
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    
    fileprivate func setImageBackToOriginalSize() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImage.transform = CGAffineTransform.identity

        }, completion: nil)
    }
    
    
    fileprivate func scaleDownImage() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.7
            self.episodeImage.transform = CGAffineTransform(scaleX: scale, y: scale)
            
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
    
    
    @IBOutlet weak var episodeImage: UIImageView!{
        
        didSet{
            let scale: CGFloat = 0.7
            episodeImage.layer.cornerRadius = 5
            episodeImage.clipsToBounds = true
            episodeImage.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
        
    }
    @IBOutlet weak var episodeTitle: UILabel! {
        
        didSet{
            episodeTitle.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    
}
