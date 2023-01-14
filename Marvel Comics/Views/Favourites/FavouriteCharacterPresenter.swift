//
//  FavouriteCharacterPresenter.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import CoreData

protocol FavouriteCharacterPresenterProtocol: AnyObject {
    var view: FavouriteCharacterViewProtocol? { get set }
    func viewWillAppear()
    func removeFavourite(_ index: IndexPath)
}

final class FavouriteCharacterPresenter: FavouriteCharacterPresenterProtocol {
    weak var view: FavouriteCharacterViewProtocol?
    private var characters: [FavouriteCharacterRepresentableViewModel] = []
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func viewWillAppear() {
        characters = PersistentFavouriteContainer.fetchFavourites(context: container.viewContext)
        view?.showCharacters(characters)
    }
    
    func removeFavourite(_ indexPath: IndexPath) {
        do {
            try PersistentFavouriteContainer.removeFavourite(characters[indexPath.row], backgroundContext: container.viewContext)
            characters = PersistentFavouriteContainer.fetchFavourites(context: container.viewContext)
            view?.updateDeleteCharacter(characters, index: indexPath)
        } catch let error {
            view?.showError(error.localizedDescription)
        }
    }
}
