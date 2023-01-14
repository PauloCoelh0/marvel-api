//
//  CharacterListViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

protocol CharacterListViewProtocol: AnyObject {
    func showCharacters(_ viewModels: [CharacterRepresentableViewModel])
    func appendNewCharacters(_ characters: [CharacterRepresentableViewModel])
    func updatePagination(enable: Bool)
}

class CharacterListViewController: UITableViewController {
    
    // MARK: - Value Types
    typealias DataSource = UITableViewDiffableDataSource<CharactersSection, CharacterRepresentableViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CharactersSection, CharacterRepresentableViewModel>

    private lazy var tableViewDataSource: DataSource = makeDataSource()
    private lazy var tableViewAdvancedDataSource: UITableViewDiffableDataSource<AdvancedSearchSection, AdvancedSearchViewModel> = makeAdvancedDataSource()
    
    private let presenter: CharacterListPresenterProtocol
    private var characters: [CharacterRepresentableViewModel] = []
    private var filterCharacters: [CharacterRepresentableViewModel] = []
    private var isFetchingMore: Bool = false
    private var isFooterViewEnable: Bool = false
    
    enum AdvancedSearchSection: Int {
        case row = 0
    }
    
    init(presenter: CharacterListPresenterProtocol) {
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
    }
    
    func setUpNavigation() {
        navigationItem.title = "Characters"
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
            if !isFetchingMore && filterCharacters.isEmpty {
                self.beginBatchFetch()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCharacters =  tableViewDataSource.itemIdentifier(for: indexPath) else { return }
        presenter.didTapCharacter(selectedCharacters)
    }
}

extension CharacterListViewController: CharacterListViewProtocol {
    func showCharacters(_ viewModels: [CharacterRepresentableViewModel]) {
        characters = viewModels
        updateDataSource(animatingDifferences: false)
    }
    
    func appendNewCharacters(_ characters: [CharacterRepresentableViewModel]) {
        self.characters.append(contentsOf: characters)
        isFetchingMore = false
        updateDataSource(animatingDifferences: false)
    }

    func updatePagination(enable: Bool) {
        isFetchingMore = !enable
        isFooterViewEnable = enable
    }
}
private extension CharacterListViewController {
    func makeDataSource() -> DataSource {
        return DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell") as? CharacterTableViewCell
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
    
    func updateDataSource(_ characters: [CharacterRepresentableViewModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(characters)
        tableViewDataSource.apply(snapShot, animatingDifferences: false)
    }
    
    func updateDataSource(animatingDifferences: Bool = false) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(characters)
        tableViewDataSource.apply(snapShot, animatingDifferences: animatingDifferences)
    }
}

private extension CharacterListViewController {
    func beginBatchFetch() {
        isFetchingMore = true
        isFooterViewEnable = true
        updateDataSource()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter.loadMoreCharacters()
        }
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterTableViewCell")
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

extension CharacterListViewController: SearchHeaderViewDelegate {
    func updateSearchResults(_ searchText: String) {
        isFooterViewEnable = false
        isFetchingMore = true
        tableView.scrollToTop(animated: true)
        guard !searchText.isEmpty else {
            isFetchingMore = false
            isFooterViewEnable = true
            filterCharacters = []
            updateDataSource(characters)
            return
        }
        filterCharacters = characters.filter { $0.name.contains(searchText) }
        updateDataSource(filterCharacters)
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
