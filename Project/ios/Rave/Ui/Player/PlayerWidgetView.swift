//
//  PlayerWidgetView.swift
//  Rave
//
//  Created by Developer on 21.05.2021.
//

import UIKit
import YmuzApi

class PlayerWidgetView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var imageView_songPic: UIImageView!
    @IBOutlet var lbl_trackName: UILabel!
    @IBOutlet var lbl_trackArtists: UILabel!
    
    @IBOutlet var btn_playPause: UIButton!
    @IBAction func btn_playPause_Tap(_ sender: UIButton) {
        if (sender.isSelected) {
            //playing
            let result = playerQueue.pauseTrack()
            if (result) {
                sender.isSelected = false
            }
            #if DEBUG
            print("Pause track success:" + String(result))
            #endif
        } else {
            //paused
            let result = playerQueue.playTrack()
            if (result) {
                sender.isSelected = true
            }
            #if DEBUG
            print("Play track success:" + String(result))
            #endif
        }
    }
    
    @IBAction func btn_forward_Tap(_ sender: UIButton) {
        let result = playerQueue.playNextTrack(play: playerQueue.playing)
        #if DEBUG
        print("Next track setup:" + String(result))
        #endif
    }
    
    @IBInspectable var trackImage: UIImage? {
        get { return imageView_songPic.image}
        set { imageView_songPic.image = newValue}
    }
    
    @IBInspectable var trackTitle: String {
        get {return lbl_trackName.text ?? ""}
        set {lbl_trackName.text = newValue}
    }
    
    @IBInspectable var trackArtists: String {
        get {return lbl_trackArtists.text ?? ""}
        set {lbl_trackArtists.text = newValue}
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed(PlayerWidgetView.className, owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.frame = contentView.frame;
        self.addSubview(contentView);
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed(PlayerWidgetView.className, owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        contentView.frame = contentView.frame;
        self.addSubview(contentView);
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        setupUI()
    }
    
    func setData(coverImg: UIImage?, trackName: String?, artist: String?) {
        trackImage = coverImg
        trackTitle = trackName ?? AppService.localizedString(.player_unknown_track_title)
        trackArtists = artist ?? AppService.localizedString(.player_unknown_track_artists)
        setupUI()
    }
    
    fileprivate func setupUI() {
        if (playerQueue.playing) {
            btn_playPause.isSelected = true
        } else {
            btn_playPause.isSelected = false
        }
    }
}
