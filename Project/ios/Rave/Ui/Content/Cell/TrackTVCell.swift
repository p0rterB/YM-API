//
//  TrackTVCell.swift
//  Rave
//
//  Created by Developer on 17.08.2021.
//

import UIKit

class TrackTVCell: UITableViewCell {
    
    @IBOutlet weak var imgView_trackCover: UIImageView!
    @IBOutlet weak var lbl_trackTitle: UILabel!
    @IBOutlet weak var lbl_artists: UILabel!
    @IBOutlet weak var btn_options: UIButton!
    @IBAction func btn_options_Tap(_ sender: UIButton) {
        _selector?()
    }
    
    fileprivate var _selector: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
    }
    
    func initializeCell(trackTitle: String, artists: [String], cover: UIImage?, available: Bool, onOptionsPress: @escaping () -> Void) {
        if (trackTitle.isEmpty) {
            lbl_trackTitle.text = AppService.localizedString(.player_unknown_track_title)
        } else {
            lbl_trackTitle.text = trackTitle
        }
        if (artists.count == 0) {
            lbl_artists.text = AppService.localizedString(.player_unknown_track_artists)
        } else {
            lbl_artists.text = artists.joined(separator: ",")
        }
        if let g_img = cover {
            imgView_trackCover.image = g_img
        } else {
            imgView_trackCover.image = UIImage(named: "ic_track_template")
        }
        if (available) {
            if #available(iOS 13.0, *) {
                lbl_trackTitle.textColor = UIColor.label
                btn_options.tintColor = UIColor.label
            } else {
                lbl_trackTitle.textColor = UIColor.black
                btn_options.tintColor = UIColor.black
            }
            lbl_artists.textColor = UIColor.systemGray
            imgView_trackCover.tintColor = UIColor.systemBlue
            _selector = onOptionsPress
        } else {
            lbl_trackTitle.textColor = UIColor.systemGray
            lbl_artists.textColor = UIColor.systemGray
            btn_options.tintColor = UIColor.systemGray
            imgView_trackCover.tintColor = UIColor.systemGray
            _selector = nil
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            if #available(iOS 11.0, *) {
                self.backgroundColor = UIColor(named: "TrackPlayingColor")
            } else {
                self.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            }
        } else {
            if #available(iOS 13.0, *) {
                self.backgroundColor = UIColor.systemBackground
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
}
