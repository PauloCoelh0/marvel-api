//
//  EventDetailCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import UIKit
import CoreData

final class EventDetailCoordinator: Coordinator {
    var rootViewController: UIViewController = UIViewController()
    private let viewModel: EventRepresentableViewModel
    private let container: NSPersistentContainer
    
    init(viewModel: EventRepresentableViewModel, container: NSPersistentContainer) {
        self.viewModel = viewModel
        self.container = container
    }
    
    func start() -> UIViewController {
        let presenter = EventDetailPresenter(viewModel, container: container)
        let viewController = EventDetailViewController(presenter: presenter)
        presenter.view = viewController
        rootViewController = viewController
        return rootViewController
    }
}
