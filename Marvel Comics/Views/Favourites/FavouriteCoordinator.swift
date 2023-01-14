//
//  FavouriteCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import UIKit
import CoreData


protocol FavouritesBaseCoordinator: Coordinator {
    var container: NSPersistentContainer? { get set }
}

final class FavouritesCoordinator: FavouritesBaseCoordinator {
    var container: NSPersistentContainer?
    lazy var rootViewController: UIViewController = UIViewController()

    init(container: NSPersistentContainer) {
        self.container = container
        
    }
    
    func start() -> UIViewController {
        guard let container = container else { return UIViewController() }
        let presenter = FavouriteCharacterPresenter(container: container)
        let viewController = FavouriteCharacterTableViewController(presenter: presenter)
        rootViewController = UINavigationController(rootViewController: viewController)
        presenter.view = viewController
        return rootViewController
    }
}
