//
//  MainCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit
import CoreData

class MainCoordinator{
    lazy var rootViewController: UIViewController = TabBarViewController()
    
    
    func start(container: NSPersistentContainer) -> UIViewController {
        
        let charactersViewController = CharactersCoordinator(container: container)
            .start()
        
        charactersViewController.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3.fill"), tag: 0)
        
        
        let favoriteViewController = FavouritesCoordinator(container: container)
            .start()
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 0)
        
        
        let settingsViewController =  SettingsCoordinator(container: container).start()
        
        settingsViewController.tabBarItem = UITabBarItem(title:"Settings", image: UIImage(systemName: "gearshape.fill"), tag:0)
    
        
        (rootViewController as? TabBarViewController)?.viewControllers = [charactersViewController, favoriteViewController, settingsViewController]
        
            
        UITabBar.appearance().tintColor = UIColor.label
        UITabBar.appearance().isTranslucent =  false
        UITabBar.appearance().barTintColor = UIColor.systemBackground
        
        
        return rootViewController
    }
    
}
