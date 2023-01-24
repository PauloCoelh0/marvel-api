//
//  CharacterTableViewCell.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView! {
        didSet {
            characterImage.clipsToBounds = true
            characterImage.layer.cornerRadius = 10
            characterImage.contentMode = .scaleToFill
        }
    }

    @IBOutlet weak var characterName: UILabel! {
        didSet {
            characterName.numberOfLines = 2
            characterName.font = UIFont.boldSystemFont(ofSize: 20)
            characterName.textColor = .label
        }
    }
    @IBOutlet weak var characterDescription: UILabel! {
        didSet {
            characterDescription.numberOfLines = 4
            characterDescription.textColor = .label
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel: CharacterRepresentableViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImage.image = nil
        characterImage.cancelImageLoad()
        spinner.isHidden = true
    }
    
    func configure(_ viewModel: CharacterRepresentableViewModel) {
        self.viewModel = viewModel
        characterImage.image = viewModel.image
        characterName.text = viewModel.name
        characterDescription.text = viewModel.description
        
        if viewModel.image == nil {
            loadImage()
        }
    }
    
    func loadImage() {
        spinner.startAnimating()
        spinner.isHidden = false
        guard let viewModel = viewModel,
              let url = viewModel.url else { return }
        characterImage.loadImage(at: url as URL, for: viewModel) { [weak self] in
            self?.spinner.stopAnimating()
            self?.spinner.isHidden = true
        }
    }

}
