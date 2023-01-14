//
//  SettingsCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit
import CoreData

final class SettingsCoordinator: Coordinator {
    var rootViewController: UIViewController = UIViewController()
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func start() -> UIViewController {
        let presenter = SettingsPresenter(container: container)
        let viewController = SettingsViewController(presenter: presenter)
        presenter.view = viewController as? any SettingsViewProtocol
        rootViewController = viewController
        return rootViewController
    }
}
