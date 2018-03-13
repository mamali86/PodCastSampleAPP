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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewControllers()
        setupPlayerDetailsView()
        
//        perform(#selector(minimisePlayerDetails), with: nil, afterDelay: 1)
        perform(#selector(maximisePlayerDetails), with: nil, afterDelay: 1)
        
    }
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        
        viewControllers = [generateNavigationController(for: PodCastsSearchController(), image: #imageLiteral(resourceName: "favorites"), title: "Favourites"),generateNavigationController(for: ViewController(), image: #imageLiteral(resourceName: "search"), title: "Search"), generateNavigationController(for: ViewController(), image: #imageLiteral(resourceName: "downloads"), title: "Downloads")]
        
    }
    
    
    var topAnchorAnimation: NSLayoutConstraint!
    var bottomAnchorAnimation: NSLayoutConstraint!
    
    @objc func minimisePlayerDetails() {
       
        topAnchorAnimation.isActive = false
        bottomAnchorAnimation.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()

        }, completion: nil)
        
        
    }
    
    
    @objc func maximisePlayerDetails() {
        
        topAnchorAnimation.isActive = true
        topAnchorAnimation.constant = 0
        topAnchorAnimation.isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    
    }
    

    
    func setupPlayerDetailsView() {
        let podcastEpisodePlay = PodcastEpisodesController.loadNib()
        podcastEpisodePlay.backgroundColor = .red
        view.insertSubview(podcastEpisodePlay, belowSubview: tabBar)
        podcastEpisodePlay.translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchorAnimation = podcastEpisodePlay.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        topAnchorAnimation.isActive = true
//         topAnchorAnimation = podcastEpisodePlay.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
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
