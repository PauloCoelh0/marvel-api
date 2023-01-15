//
//  EventListCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import UIKit
import CoreData

protocol EventsBaseCoordinator: Coordinator {
    func showDetail(viewModel: EventRepresentableViewModel)
//    func showAdvancedSearch(delegate: AdvancedSearchDelegate)
}

final class EventsCoordinator: EventsBaseCoordinator {
    var container: NSPersistentContainer?
    lazy var rootViewController: UIViewController = UIViewController()
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func start() -> UIViewController {
        let presenter = EventListPresenter(coordinator: self)
        let viewController = EventListViewController(presenter: presenter)
        rootViewController = UINavigationController(rootViewController: viewController)
        presenter.view = viewController
        self.setupUseCase(presenter: presenter)
        return rootViewController
    }
    
    func showDetail(viewModel: EventRepresentableViewModel) {
        guard let container = self.container else { return }
        let coordinator = EventDetailCoordinator(viewModel: viewModel, container: container)
        let viewController = coordinator.start()
        rootViewController.present(viewController, animated: true, completion: nil)
    }
    
//    func showAdvancedSearch(delegate: AdvancedSearchDelegate) {
//        let viewController = AdvancedSearchViewCoordinator(delegate: delegate).start()
//        rootViewController.present(viewController, animated: true, completion: nil)
//    }
}

private extension EventsCoordinator {
    func setupUseCase(presenter: EventListPresenter) {
        presenter.getEventListUseCase = GetEventsUseCase(repository: DataRepository(dataSource: NetworkingDataSource()))
        presenter.searchEventUseCase = SearchEventUseCase(repository: DataRepository(dataSource: NetworkingDataSource()))
    }
}
