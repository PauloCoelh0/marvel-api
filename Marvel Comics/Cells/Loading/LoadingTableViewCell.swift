//
//  LoadingTableViewCell.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

class LoadingTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.startAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.startAnimating()
        contentView.backgroundColor = .systemBackground
    }
}
