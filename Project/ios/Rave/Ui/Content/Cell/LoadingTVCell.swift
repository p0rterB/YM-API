//
//  LoadingTVCell.swift
//  Rave
//
//  Created by Developer on 17.08.2021.
//

import UIKit

class LoadingTVCell: UITableViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .large
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
