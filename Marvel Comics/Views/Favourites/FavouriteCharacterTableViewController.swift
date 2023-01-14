//
//  FavouriteCharacterTableViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

protocol FavouriteCharacterViewProtocol: AnyObject {
    func showCharacters(_ characters: [FavouriteCharacterRepresentableViewModel])
    func updateDeleteCharacter(_ characters: [FavouriteCharacterRepresentableViewModel], index: IndexPath)
    func showError(_ error: String)
}

final class FavouriteCharacterTableViewController: UITableViewController, FavouriteCharacterViewProtocol {
    private var characters: [FavouriteCharacterRepresentableViewModel] = []
    private let presenter: FavouriteCharacterPresenterProtocol
    
    init(presenter: FavouriteCharacterPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setUpNavigation()
    }
    
    func setUpNavigation() {
        navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor  = .systemBackground
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func showCharacters(_ characters: [FavouriteCharacterRepresentableViewModel]) {
        self.characters = characters
        tableView.reloadData()
    }

    func updateDeleteCharacter(_ characters: [FavouriteCharacterRepresentableViewModel], index: IndexPath) {
        self.characters = characters
        tableView.deleteRows(at: [index], with: .automatic)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.isEmpty ? 0 : characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if characters.isEmpty {
            cell.textLabel?.text = "No favourite found"
        } else {
            cell.imageView?.image = UIImage(data: characters[indexPath.row].image ?? Data())
            cell.layer.borderColor = UIColor.systemGray6.cgColor
            cell.layer.borderWidth = 3
            cell.backgroundColor = .systemGray5
//            cell.layer.backgroundColor = UIColor.green.cgColor
            cell.textLabel?.text = characters[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && characters.indices.contains(indexPath.row) {
            presenter.removeFavourite(indexPath)
      }
    }
    
}

private extension FavouriteCharacterTableViewController {
    func configureTableView() {
        
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
    }
}

