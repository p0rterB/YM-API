//
//  FavouriteIntroTVCell.swift
//  Rave
//
//  Created by Developer on 17.08.2021.
//

import UIKit

class FavouriteIntroTVCell: UITableViewCell {
    
    @IBOutlet weak var lbl_playlistTitle: UILabel!
    @IBOutlet weak var lbl_playlistTracksCount: UILabel!
    @IBOutlet weak var imgView_playlistCover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        imgView_playlistCover.layer.cornerRadius = 16
    }
    
    func initializeCell(tracksCount: Int) {
        lbl_playlistTitle.text = AppService.localizedString(.playlist_favourite_title)
        lbl_playlistTracksCount.text = AppService.localizedString(.playlist_tracks_count) + " - " + String(tracksCount)
        imgView_playlistCover.image = UIImage(named: "playlist_liked_template")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
