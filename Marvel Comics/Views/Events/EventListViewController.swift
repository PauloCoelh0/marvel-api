//
//  EventListViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import UIKit
import UserNotifications


protocol EventListViewProtocol: AnyObject {
    func showEvents(_ viewModels: [EventRepresentableViewModel])
    func appendNewEvents(_ events: [EventRepresentableViewModel])
    func updatePagination(enable: Bool)
}

class EventListViewController: UITableViewController {
    
    // MARK: - Value Types
    typealias DataSource = UITableViewDiffableDataSource<EventsSection, EventRepresentableViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventsSection, EventRepresentableViewModel>

    private lazy var tableViewDataSource: DataSource = makeDataSource()
    private lazy var tableViewAdvancedDataSource: UITableViewDiffableDataSource<AdvancedSearchSection, AdvancedSearchViewModel> = makeAdvancedDataSource()
    
    private let presenter: EventListPresenterProtocol
    private var events: [EventRepresentableViewModel] = []
    private var filterEvents: [EventRepresentableViewModel] = []
    private var isFetchingMore: Bool = false
    private var isFooterViewEnable: Bool = false
    
    enum AdvancedSearchSection: Int {
        case row = 0
    }
    
    init(presenter: EventListPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.viewDidLoad()
        setUpNavigation()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }

    }
    
    func setUpNavigation() {
        navigationItem.title = "Events"
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        
//        self.navigationController?.navigationBar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        
//        self.navigationController?.navigationBar.topAnchor.constraint(equalTo:view.topAnchor, constant:-10).isActive = true
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchHeaderView") as? SearchHeaderView
        view?.delegate = self
        view?.configureView()
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LoadingTableViewCell") as? LoadingTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isFetchingMore && isFooterViewEnable {
            return UITableView.automaticDimension
        } else {
            return .leastNonzeroMagnitude
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isFetchingMore && filterEvents.isEmpty {
                self.beginBatchFetch()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedEvents =  tableViewDataSource.itemIdentifier(for: indexPath) else { return }
        presenter.didTapEvent(selectedEvents)
    }
}

extension EventListViewController: EventListViewProtocol {
    func showEvents(_ viewModels: [EventRepresentableViewModel]) {
        events = viewModels
        updateDataSource(animatingDifferences: false)
    }
    
    func appendNewEvents(_ events: [EventRepresentableViewModel]) {
        self.events.append(contentsOf: events)
        isFetchingMore = false
        updateDataSource(animatingDifferences: false)
    }

    func updatePagination(enable: Bool) {
        isFetchingMore = !enable
        isFooterViewEnable = enable
    }
    
    
    
    //Notifications implemented but it will not work, explanation in my native language bellow:
    
    // Esta notfication feature não vai funcionar porque esta API não fornece dados suficientes para que a notificação sequer faça sentido. E apesar de o elemento se chamar "Events" eles não se referem por exemplo a "eventos festivos" que ocorrem numa determinada data e localização, mas sim a eventos que ocorrem no mundo da ficção comic.
    
//    private func scheduleNotification(event: EventRepresentableViewModel) {
//        let content = UNMutableNotificationContent()
//        content.title = "New event starting"
//        content.body = "\(event.title) is starting today"
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//
//        let date = event.startDate
//        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let request = UNNotificationRequest(identifier: event.eventID, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("Error scheduling notification: \(error)")
//            }
//        }
//    }
//
//    func showEvents(_ viewModels: [EventRepresentableViewModel]) {
//        self.events = viewModels
//        self.filterEvents = viewModels
//        self.scheduleNotification(event: viewModels[0])
//        updateTableView(with: viewModels)
//    }
//
    
}
private extension EventListViewController {
    func makeDataSource() -> DataSource {
        return DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as? EventTableViewCell
                cell?.configure(item)
                return cell
            }
        )
    }
    
    func makeAdvancedDataSource() -> UITableViewDiffableDataSource<AdvancedSearchSection, AdvancedSearchViewModel> {
        return UITableViewDiffableDataSource<AdvancedSearchSection, AdvancedSearchViewModel>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: AdvancedSearchViewModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdvancedSearchCell", for: indexPath)
            return cell
        }
    }
    
    func updateDataSource(_ events: [EventRepresentableViewModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(events)
        tableViewDataSource.apply(snapShot, animatingDifferences: false)
    }
    
    func updateDataSource(animatingDifferences: Bool = false) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(events)
        tableViewDataSource.apply(snapShot, animatingDifferences: animatingDifferences)
    }
}

private extension EventListViewController {
    func beginBatchFetch() {
        isFetchingMore = true
        isFooterViewEnable = true
        updateDataSource()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter.loadMoreEvents()
        }
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        tableView.register(UINib(nibName: "SearchHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchHeaderView")
        tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "LoadingTableViewCell")
        tableView.register(UINib(nibName: "AdvancedSearchCell", bundle: nil), forCellReuseIdentifier: "AdvancedSearchCell")
    }
    
    func configureTableView() {
        registerCells()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableViewDataSource.defaultRowAnimation = .fade
        tableView.tableFooterView?.isHidden = true
        
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true

    }
}

extension EventListViewController: SearchHeaderViewDelegate {
    func updateSearchResults(_ searchText: String) {
        isFooterViewEnable = false
        isFetchingMore = true
        tableView.scrollToTop(animated: true)
        guard !searchText.isEmpty else {
            isFetchingMore = false
            isFooterViewEnable = true
            filterEvents = []
            updateDataSource(events)
            return
        }
        filterEvents = events.filter { $0.title.contains(searchText) }
        updateDataSource(filterEvents)
    }
    
//    func didTapOnAdvancedSearch() {
//        self.presenter.didTapOnAdvancedSearch()
//    }
}

private extension UITableView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        if hasRowAtIndexPath(indexPath: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
