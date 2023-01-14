//
//  CharacterListPresenter.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

protocol CharacterListPresenterProtocol: AnyObject {
    var view: CharacterListViewProtocol? { get set }
    func viewDidLoad()
    func loadMoreCharacters()
    func didTapCharacter(_ character: CharacterRepresentableViewModel)
//    func didTapOnAdvancedSearch()
}

final class CharacterListPresenter: CharacterListPresenterProtocol {
    weak var view: CharacterListViewProtocol?
    private var coordinator: CharactersBaseCoordinator
    
    private var offset: Int = 0
    private var limit: Int = -1
    private var total: Int = 0
    private var count: Int = 0
    
    init(coordinator: CharactersBaseCoordinator) {
        self.coordinator = coordinator
    }
    
    var getCharacterListUseCase: GetCharactersUseCase?
    var searchCharacterUseCase: SearchCharacterUseCase?
    
    func viewDidLoad() {
        let characters = loadCharacters()
        view?.showCharacters(characters)
    }
    
    func loadMoreCharacters() {
        let characters = loadCharacters()
        view?.appendNewCharacters(characters)
    }
    
    func didTapCharacter(_ character: CharacterRepresentableViewModel) {
        coordinator.showDetail(viewModel: character)
    }
    
//    func didTapOnAdvancedSearch() {
//        coordinator.showAdvancedSearch(delegate: self)
//    }
}

private extension CharacterListPresenter {
    func loadCharacters() -> [CharacterRepresentableViewModel] {
        do {
            guard offset > limit, let charactersDomain = try getCharacterListUseCase?.execute(offset: offset) else {
                return []
            }
            let charactersViewModelRepresentable = charactersDomain
                .characters
                .map { CharacterRepresentableViewModel(
                    characterID: $0.characterID,
                    name: $0.name,
                    description: $0.description ?? "",
                    url: $0.thumbnail?.imageURL ?? "",
                    comics: $0.comics.items.map { $0.name ?? "" },
                    series: $0.series.items.map { $0.name ?? "" },
                    events: $0.event.items.map { $0.name ?? ""}
                )}
            offset += charactersViewModelRepresentable.count
            limit = charactersDomain.limit
            return charactersViewModelRepresentable
        } catch {
            return []
        }
    }
}

//extension CharacterListPresenter: AdvancedSearchDelegate {
//    func search(name: String?, nameStartWithLabel: String?, comics: Int?) {
//        do {
//            let characters = try searchCharacterUseCase?.execute(input: GellAllCharactersInput(name: name,
//                                                                                               nameStartsWith: nameStartWithLabel,
//                                                                                               comics: comics))
//            let charactersViewModelRepresentable = characters?
//                .characters
//                .map { CharacterRepresentableViewModel(
//                    characterID: $0.characterID,
//                    name: $0.name,
//                    description: $0.description ?? "",
//                    url: $0.thumbnail?.imageURL ?? "",
//                    comics: $0.comics.items.map { $0.name ?? "" },
//                    series: $0.series.items.map { $0.name ?? "" },
//                    events: $0.event.items.map { $0.name ?? ""}
//                )} ?? []
//            view?.updatePagination(enable: false)
//            view?.showCharacters(charactersViewModelRepresentable)
//        } catch let error {
//            print("error: \(error)")
//        }
//    }
//
//    func showAllCharacters() {
//        resetValues()
//        let characters = loadCharacters()
//        view?.updatePagination(enable: true)
//        view?.showCharacters(characters)
//    }
//
//    func resetValues() {
//        self.offset = 0
//        self.limit = -1
//        self.total = 0
//        self.count = 0
//    }
//}
