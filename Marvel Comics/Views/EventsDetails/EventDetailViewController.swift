//
//  EventDetailViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import UIKit

protocol EventDetailViewProtocol: AnyObject {
    func show(_ viewModel: EventRepresentableViewModel)
}

class EventDetailViewController: UIViewController, EventDetailViewProtocol, UITableViewDelegate {
    
    @IBOutlet weak var eventImage: UIImageView! {
        didSet {
            eventImage.contentMode = .scaleAspectFill
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImage))
             tap.numberOfTapsRequired = 2
            eventImage.addGestureRecognizer(tap)
            eventImage.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var heartButton: UIButton! {
        didSet {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heartForegroundImage: UIImageView! {
        didSet {
            heartForegroundImage.tintColor = .white
            heartForegroundImage.alpha = 0.0
            heartForegroundImage.layer.shadowColor = UIColor.black.cgColor
            heartForegroundImage.layer.shadowOpacity = 0.5
            heartForegroundImage.layer.shadowOffset = .zero
            heartForegroundImage.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    private var tableViewData = [[String]] ()
    private var hiddenSections = Set<Int>()
    private let presenter: EventDetailPresenterProtocol
    private var viewModel: EventRepresentableViewModel?
    
    enum SectionTable: Int {
        case comics
        case series
        case events
        
        func getTitle() -> String {
            switch self {
            case .comics: return "Comics"
            case .series: return "Series"
            case .events: return "Events"
            }
        }
    }
    init(presenter: EventDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "EventDetailViewController", bundle: Bundle(for: EventDetailViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    func show(_ viewModel: EventRepresentableViewModel) {
        self.viewModel = viewModel
        eventImage.image = viewModel.image
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        tableViewData.append(contentsOf:
                                    [viewModel.comics,
                                     viewModel.series,
                                     viewModel.characters])
        heartButton.isSelected = viewModel.isFavourite
        tableView.reloadData()
    }
    
    @IBAction func didTapHeart(_ sender: Any) {
        heartButton.isSelected.toggle()
        updateFavourite()
    }
}

extension EventDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hiddenSections.contains(section) {
            return 0
        }
        
        return tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tableViewData[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionTable = SectionTable(rawValue: section) else { return UIView() }
        let sectionButton = UIButton()
        sectionButton.setTitle(String(sectionTable.getTitle() + " #\(tableViewData[section].count)"),
                               for: .normal)
        sectionButton.backgroundColor = .systemBlue
        sectionButton.tag = section
        sectionButton.addTarget(self,
                                action: #selector(hideSection(sender:)),
                                for: .touchUpInside)
        return sectionButton
    }
}

private extension EventDetailViewController {
    @objc
    func hideSection(sender: UIButton)  {
        let section = sender.tag
        var indexPath: [IndexPath] {
            var indexPaths = [IndexPath]()
            for row in 0 ..< tableViewData[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            return indexPaths
        }
        
        if hiddenSections.contains(section) {
            hiddenSections.remove(section)
            tableView.insertRows(at: indexPath, with: .fade)
        } else {
            hiddenSections.insert(section)
            tableView.deleteRows(at: indexPath, with: .fade)
        }
    }
    
    @objc
    func doubleTapImage() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            self.heartForegroundImage.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            self.heartForegroundImage.alpha = 1.0
        }) { finished in
            self.heartForegroundImage.alpha = 0.0
            self.heartForegroundImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        heartButton.isSelected.toggle()
        updateFavourite()
    }
    
    func updateFavourite() {
        viewModel?.isFavourite =  heartButton.isSelected
        presenter.saveFavourite(isFavourite: heartButton.isSelected)
    }
}
