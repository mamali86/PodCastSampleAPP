//
//  MainTabBarController.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 21/02/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var routeManager: RouteManager?
//    var podcastEpisode: PodcastEpisode?

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewControllers()
        setupPlayerDetailsView()

//        perform(#selector(minimisePlayerDetails), with: nil, afterDelay: 1)
//        perform(#selector(maximisePlayerDetails), with: nil, afterDelay: 1)
    }
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        viewControllers = [generateNavigationController(for: PodCastsSearchController(), image: #imageLiteral(resourceName: "favorites"), title: "Favourites"),generateNavigationController(for: ViewController(), image: #imageLiteral(resourceName: "search"), title: "Search"), generateNavigationController(for: ViewController(), image: #imageLiteral(resourceName: "downloads"), title: "Downloads")]
    }
    
    
    let podcastEpisodePlay = PodcastEpisodesController.loadNib()
    var topAnchorAnimation: NSLayoutConstraint!
    var topAnchorMinimisedAnimation: NSLayoutConstraint!
    var bottomAnchorAnimation: NSLayoutConstraint!
    
    func minimisePlayerDetails(podcastEpisode: PodcastEpisode?) {
       
        topAnchorAnimation.isActive = false
        topAnchorMinimisedAnimation.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.tabBar.transform = CGAffineTransform.identity
            
            self.podcastEpisodePlay.minimisedStackView.alpha = 1
            self.podcastEpisodePlay.MaximisedStackView.alpha = 0 
            
        }, completion: nil)
    }
    
    
     func maximisePlayerDetails(podcastEpisode: PodcastEpisode?) {
        topAnchorAnimation.isActive = true
        topAnchorAnimation.constant = 0
        topAnchorMinimisedAnimation.isActive = false
        
        bottomAnchorAnimation.constant = 0 
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.podcastEpisodePlay.minimisedStackView.alpha = 0
            self.podcastEpisodePlay.MaximisedStackView.alpha = 1
            
            
        }, completion: nil)
    
    }
    

    
    func setupPlayerDetailsView() {
        view.insertSubview(podcastEpisodePlay, belowSubview: tabBar)
        podcastEpisodePlay.translatesAutoresizingMaskIntoConstraints = false
        topAnchorAnimation = podcastEpisodePlay.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        topAnchorAnimation.isActive = true
         topAnchorMinimisedAnimation = podcastEpisodePlay.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        topAnchorAnimation.isActive = true
        bottomAnchorAnimation = podcastEpisodePlay.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomAnchorAnimation.isActive = true
        podcastEpisodePlay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        podcastEpisodePlay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
    }
    
    
    //MARK:- Helper Functions
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let NavController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        NavController.tabBarItem.title = title
        NavController.tabBarItem.image = image
        return NavController
        
    }
    
    
    
}
