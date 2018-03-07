//
//  PodcastDetailedEpisode.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 06/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
import SDWebImage



class PodcastDetailedEpisode: UIView {
    
    var podcastEpisode: PodcastEpisode! {
        
        didSet{
            
            episodeTitle.text = podcastEpisode.title
            authorLabel.text = podcastEpisode.author
            guard let url = URL(string: podcastEpisode?.imageUrl ?? "") else {return}
            episodeImage.sd_setImage(with: url, completed: nil)
        }
        
    }
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeTitle: UILabel! {
        
        didSet{
            episodeTitle.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    
}
