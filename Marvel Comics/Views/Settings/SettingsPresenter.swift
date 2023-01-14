//
//  SettingsPresenter.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import CoreData

protocol SettingsPresenterProtocol {
    var view: SettingsViewProtocol? { get set }
//    func viewDidLoad()

    
}

final class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol?
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
//    func viewDidLoad() {
//        viewModel.isFavourite = (try? PersistentFavouriteContainer
//            .isFavourite(
//                Int32(viewModel.characterID),
//                context: container.viewContext
//            )
//        ) ?? false
//        view?.show(viewModel)
//    }
    
//    func saveFavourite(isFavourite: Bool) {
//        let favouriteViewModel = FavouriteCharacterRepresentableViewModel(
//            id: Int32(viewModel.characterID),
//            image: viewModel.image?.pngData(),
//            name: viewModel.name)
//        if isFavourite {
//            PersistentFavouriteContainer.saveFavourite(favouriteViewModel, context: container.viewContext)
//        } else {
//            try? PersistentFavouriteContainer.removeFavourite(favouriteViewModel, backgroundContext: container.viewContext)
//        }
//    }
    
}
