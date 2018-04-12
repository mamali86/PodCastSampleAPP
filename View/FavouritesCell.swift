//
//  FavouritesCell.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 05/04/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class FavouritesCell: UICollectionViewCell {
    
    
    var savedPodcast: Podcast?{
        
        didSet{
            
            podcastNamelabel.text = savedPodcast?.trackName
            authorNamelabel.text = savedPodcast?.artistName
            guard let url = URL(string: savedPodcast?.artworkUrl600 ?? "") else {return}
            favouriteImage.sd_setImage(with: url)
            
            
        }
    }
    
    
    let favouriteImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "appicon")
        return image
    }()
    
    let podcastNamelabel: UILabel = {
        let label = UILabel()
        label.text = "podCastName"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let authorNamelabel: UILabel = {
        let label = UILabel()
        label.text = "authorName"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()
    
    
    fileprivate func setupAnchors() {
        let stackView = UIStackView(arrangedSubviews: [favouriteImage, podcastNamelabel, authorNamelabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        favouriteImage.heightAnchor.constraint(equalTo: favouriteImage.widthAnchor).isActive = true
        
        
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAnchors() 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
