//
//  CharacterListCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit
import CoreData

protocol CharactersBaseCoordinator: Coordinator {
    func showDetail(viewModel: CharacterRepresentableViewModel)
//    func showAdvancedSearch(delegate: AdvancedSearchDelegate)
}

final class CharactersCoordinator: CharactersBaseCoordinator {
    var container: NSPersistentContainer?
    lazy var rootViewController: UIViewController = UIViewController()
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func start() -> UIViewController {
        let presenter = CharacterListPresenter(coordinator: self)
        let viewController = CharacterListViewController(presenter: presenter)
        rootViewController = UINavigationController(rootViewController: viewController)
        presenter.view = viewController
        self.setupUseCase(presenter: presenter)
        return rootViewController
    }
    
    func showDetail(viewModel: CharacterRepresentableViewModel) {
        guard let container = self.container else { return }
        let coordinator = CharacterDetailCoordinator(viewModel: viewModel, container: container)
        let viewController = coordinator.start()
        rootViewController.present(viewController, animated: true, completion: nil)
    }
    
//    func showAdvancedSearch(delegate: AdvancedSearchDelegate) {
//        let viewController = AdvancedSearchViewCoordinator(delegate: delegate).start()
//        rootViewController.present(viewController, animated: true, completion: nil)
//    }
}

private extension CharactersCoordinator {
    func setupUseCase(presenter: CharacterListPresenter) {
        presenter.getCharacterListUseCase = GetCharactersUseCase(repository: DataRepository(dataSource: NetworkingDataSource()))
        presenter.searchCharacterUseCase = SearchCharacterUseCase(repository: DataRepository(dataSource: NetworkingDataSource()))
    }
}
