//
//  EventDetailPresenter.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation
import CoreData

protocol EventDetailPresenterProtocol {
    var view: EventDetailViewProtocol? { get set }
    func viewDidLoad()
    func saveFavourite(isFavourite: Bool)
    
}

final class EventDetailPresenter: EventDetailPresenterProtocol {
    weak var view: EventDetailViewProtocol?
    private let viewModel: EventRepresentableViewModel
    private let container: NSPersistentContainer
    
    init(_ viewModel: EventRepresentableViewModel, container: NSPersistentContainer) {
        self.viewModel = viewModel
        self.container = container
    }
    
    func viewDidLoad() {
        viewModel.isFavourite = (try? PersistentFavouriteContainer
            .isFavourite(
                Int32(viewModel.eventID),
                context: container.viewContext
            )
        ) ?? false
        view?.show(viewModel)
    }
    
    func saveFavourite(isFavourite: Bool) {
        let favouriteViewModel = FavouriteCharacterRepresentableViewModel(
            id: Int32(viewModel.eventID),
            image: viewModel.image?.pngData(),
            name: viewModel.title)
        if isFavourite {
            PersistentFavouriteContainer.saveFavourite(favouriteViewModel, context: container.viewContext)
        } else {
            try? PersistentFavouriteContainer.removeFavourite(favouriteViewModel, backgroundContext: container.viewContext)
        }
    }
    
}

