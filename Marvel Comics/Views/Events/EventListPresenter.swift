//
//  EventListPresenter.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

protocol EventListPresenterProtocol: AnyObject {
    var view: EventListViewProtocol? { get set }
    func viewDidLoad()
    func loadMoreEvents()
    func didTapEvent(_ event: EventRepresentableViewModel)
//    func didTapOnAdvancedSearch()
}

final class EventListPresenter: EventListPresenterProtocol {
    weak var view: EventListViewProtocol?
    private var coordinator: EventsBaseCoordinator
    
    private var offset: Int = 0
    private var limit: Int = -1
    private var total: Int = 0
    private var count: Int = 0
    
    init(coordinator: EventsBaseCoordinator) {
        self.coordinator = coordinator
    }
    
    var getEventListUseCase: GetEventsUseCase?
    var searchEventUseCase: SearchEventUseCase?
    
    func viewDidLoad() {
        let events = loadEvents()
        view?.showEvents(events)
    }
    
    func loadMoreEvents() {
        let events = loadEvents()
        view?.appendNewEvents(events)
    }
    
    func didTapEvent(_ character: EventRepresentableViewModel) {
        coordinator.showDetail(viewModel: character)
    }
    
//    func didTapOnAdvancedSearch() {
//        coordinator.showAdvancedSearch(delegate: self)
//    }
}

private extension EventListPresenter {
    func loadEvents() -> [EventRepresentableViewModel] {
        do {
            guard offset > limit, let eventsDomain = try getEventListUseCase?.execute(offset: offset) else {
                return []
            }
            let eventsViewModelRepresentable = eventsDomain
                .events
                .map { EventRepresentableViewModel(
                    eventID: $0.eventID,
                    title: $0.title,
                    description: $0.description ?? "",
                    url: $0.thumbnail?.imageURL ?? "",
                    comics: $0.comics.items.map { $0.name ?? "" },
                    series: $0.series.items.map { $0.name ?? "" },
                    characters: $0.characters.items.map { $0.name ?? ""}
                )}
            offset += eventsViewModelRepresentable.count
            limit = eventsDomain.limit
            return eventsViewModelRepresentable
        } catch {
            return []
        }
    }
}
