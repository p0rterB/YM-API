//
//  PlaylistIntroTVCell.swift
//  Rave
//
//  Created by Developer on 17.08.2021.
//

import UIKit

class PlaylistIntroTVCell: UITableViewCell {
    
    @IBOutlet weak var imgView_playlistLogo: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_tracksCount: UILabel!
    @IBOutlet weak var btn_download: UIButton!
    
    @IBAction func btn_download_Tap(_ sender: UIButton) {
        _selector?()
    }
    
    fileprivate var _selector: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        imgView_playlistLogo.layer.cornerRadius = 16
        btn_download.layer.cornerRadius = 12
    }
    
    func initalizeCell(title: String, count: Int, img: UIImage?, onDownloadPress: @escaping () -> Void) {
        lbl_title.text = title
        lbl_tracksCount.text = AppService.localizedString(.playlist_tracks_count) + " - " + String(count)
        btn_download.setTitle(AppService.localizedString(.general_download), for: .normal)
        if let g_img = img {
            imgView_playlistLogo.image = g_img
        } else {
            imgView_playlistLogo.image = UIImage(named: "playlist_template")
        }
        _selector = onDownloadPress
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
