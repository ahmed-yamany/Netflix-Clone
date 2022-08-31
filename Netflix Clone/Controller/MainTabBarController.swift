//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 31/08/2022.
//

import UIKit



class MainTabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewControllers()
       
    }
    
    func setViewControllers(){
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        setupTabBarItem(of: homeViewController, withIcon: "house", withTitle: "Home")
        
        let UpcomingViewController = UINavigationController(rootViewController: UpComingViewController())
        setupTabBarItem(of: UpcomingViewController, withIcon: "play.circle", withTitle: "Coming Soon")
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        setupTabBarItem(of: searchViewController, withIcon: "magnifyingglass", withTitle: "Top Search")
        
        let downloadsViewController = UINavigationController(rootViewController: DownloadsViewController())
        setupTabBarItem(of: downloadsViewController, withIcon: "arrow.down.to.line", withTitle: "Downloads")
        
        let viewControllers = [homeViewController, UpcomingViewController, searchViewController, downloadsViewController]
     
        tabBar.tintColor = .label
        setViewControllers(viewControllers, animated: false)
    }
    
    func setupTabBarItem(of viewController: UIViewController, withIcon iconName: String, withTitle title: String){
        viewController.tabBarItem.image = UIImage(systemName: iconName)
        viewController.title = title
        
        
    }
    


}

