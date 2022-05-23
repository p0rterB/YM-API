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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.contentView.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.1) {
            if #available(iOS 13.0, *) {
                self.contentView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
            } else {
                self.contentView.layer.backgroundColor = self.contentView.backgroundColor?.cgColor
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        contentView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.1) {
            if #available(iOS 13.0, *) {
                self.contentView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
            } else {
                self.contentView.layer.backgroundColor = self.contentView.backgroundColor?.cgColor
            }
        }
    }
    
    func setData(coverImg: UIImage?, trackName: String?, artist: String?) {
        trackImage = coverImg
        trackTitle = trackName ?? AppService.localizedString(.player_unknown_track_title)
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
