//
//  PersonalPlaylistCVC.swift
//  Rave
//
//  Created by Developer on 10.08.2021.
//

import UIKit

class PersonalPlaylistCVCell: UICollectionViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var lbl_centerTitle: UILabel!
    @IBOutlet weak var lbl_bottomTitle: UILabel!
    @IBOutlet weak var lbl_updateInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 8
    }
    
    func initializeCell(innerViewBgColor: UIColor, title: String, updateInfo: String)
    {
        innerView.backgroundColor = innerViewBgColor
        lbl_centerTitle.text = title
        lbl_bottomTitle.text = title
        lbl_updateInfo.text = updateInfo
    }
}
