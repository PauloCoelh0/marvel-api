//
//  CharacterDetailPresenter.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import CoreData

protocol CharacterDetailPresenterProtocol {
    var view: CharacterDetailViewProtocol? { get set }
    func viewDidLoad()
    func saveFavourite(isFavourite: Bool)
    
}

final class CharacterDetailPresenter: CharacterDetailPresenterProtocol {
    weak var view: CharacterDetailViewProtocol?
    private let viewModel: CharacterRepresentableViewModel
    private let container: NSPersistentContainer
    
    init(_ viewModel: CharacterRepresentableViewModel, container: NSPersistentContainer) {
        self.viewModel = viewModel
        self.container = container
    }
    
    func viewDidLoad() {
        viewModel.isFavourite = (try? PersistentFavouriteContainer
            .isFavourite(
                Int32(viewModel.characterID),
                context: container.viewContext
            )
        ) ?? false
        view?.show(viewModel)
    }
    
    func saveFavourite(isFavourite: Bool) {
        let favouriteViewModel = FavouriteCharacterRepresentableViewModel(
            id: Int32(viewModel.characterID),
            image: viewModel.image?.pngData(),
            name: viewModel.name)
        if isFavourite {
            PersistentFavouriteContainer.saveFavourite(favouriteViewModel, context: container.viewContext)
        } else {
            try? PersistentFavouriteContainer.removeFavourite(favouriteViewModel, backgroundContext: container.viewContext)
        }
    }
    
}
