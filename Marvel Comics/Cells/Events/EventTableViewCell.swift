//
//  EventTableViewCell.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import UIKit

final class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView! {
        didSet {
            eventImage.clipsToBounds = true
            eventImage.layer.cornerRadius = 10
            eventImage.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var containerDetailEventView: UIView! {
        didSet {
            containerDetailEventView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            containerDetailEventView.clipsToBounds = true
            containerDetailEventView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var eventTitle: UILabel! {
        didSet {
            eventTitle.numberOfLines = 2
            eventTitle.font = UIFont.boldSystemFont(ofSize: 18)
            eventTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel: EventRepresentableViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImage.image = nil
        eventImage.cancelImageLoad()
        spinner.isHidden = true
    }
    
    func configure(_ viewModel: EventRepresentableViewModel) {
        self.viewModel = viewModel
        eventImage.image = viewModel.image
        eventTitle.text = viewModel.title
        if viewModel.image == nil {
            loadImageE()
        }
    }
    
    func loadImageE() {
        spinner.startAnimating()
        spinner.isHidden = false
        guard let viewModel = viewModel,
              let url = viewModel.url else { return }
        eventImage.loadImageE(at: url as URL, for: viewModel) { [weak self] in
            self?.spinner.stopAnimating()
            self?.spinner.isHidden = true
        }
    }

}
