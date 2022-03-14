//
//  AudioPlayerVC.swift
//  Rave
//
//  Created by Developer on 24.08.2021.
//

import UIKit
import YmuzApi

class AudioPlayerVC: UIViewController {
    
    @IBAction func btn_dismiss_Tap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_toggleView_Tap(_ sender: UIButton) {
        toggleView()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imagevView_trackCover: UIImageView!
    @IBOutlet weak var lbl_trackTitle: UILabel!
    @IBOutlet weak var lbl_trackArtists: UILabel!
    @IBOutlet weak var slider_trackPlaybackPosition: UISlider!
    @IBAction func slider_trackPlaybackPosition_Changed(_ sender: UISlider) {
        lbl_trackPlaybackPosition.text = DateUtil.formattedTrackTime(TimeInterval(sender.value))
        _refreshTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.refreshPlaybackSlider), userInfo: nil, repeats: true)
        let result = playerQueue.setPlaybackPosition(position: TimeInterval(slider_trackPlaybackPosition.value))
#if DEBUG
        print("Track playback position change:" + String(result))
#endif
    }
    @IBAction func slider_trackPlaybackPosition_DragInside(_ sender: UISlider) {
        _refreshTimer.invalidate()
        lbl_trackPlaybackPosition.text = DateUtil.formattedTrackTime(TimeInterval(sender.value))
    }
    @IBAction func slider_trackPlaybackPosition_DragOutside(_ sender: UISlider) {
        _refreshTimer.invalidate()
        lbl_trackPlaybackPosition.text = DateUtil.formattedTrackTime(TimeInterval(sender.value))
    }
    @IBOutlet weak var lbl_trackPlaybackPosition: UILabel!
    @IBOutlet weak var lbl_trackDuration: UILabel!
    @IBOutlet weak var btn_trackDislike: UIButton!
    @IBAction func btn_trackDislike_Tap(_ sender: UIButton) {
        if let g_track = playerQueue.currTrack {
            dislikeTrack(g_track)
        }
    }
    @IBOutlet weak var btn_prevTrack: UIButton!
    @IBAction func btn_prevTrack_Tap(_ sender: UIButton) {
        let result = playerQueue.playPreviousTrack()
#if DEBUG
        print("Previous track setup:" + String(result))
#endif
    }
    @IBOutlet weak var btn_playPauseTrack: UIButton!
    @IBAction func btn_playPauseTrack_Tap(_ sender: UIButton) {
        if (sender.isSelected) {
            //playing
            let result = playerQueue.pauseTrack()
            if (result) {
                sender.isSelected = false
            }
#if DEBUG
            print("Pause track:" + String(result))
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
    @IBOutlet weak var btn_nextTrack: UIButton!
    @IBAction func btn_nextTrack_Tap(_ sender: UIButton) {
        let result = playerQueue.playNextTrack()
#if DEBUG
        print("Next track setup:" + String(result))
#endif
    }
    @IBOutlet weak var btn_trackLike: UIButton!
    @IBAction func btn_trackLike_Tap(_ sender: UIButton) {
        if let g_track = playerQueue.currTrack {
            likeTrack(g_track)
            btn_trackLike.isSelected = !btn_trackLike.isSelected
        }
    }
    @IBOutlet weak var btn_playRepeat: UIButton!
    @IBAction func btn_playRepeat_Tap(_ sender: UIButton) {
        playerQueue.toggleRepeatMode()
        repeatRepeatShuffleModesRefreshUI()
    }
    @IBOutlet weak var btn_playShuffle: UIButton!
    @IBAction func btn_playShuffle_Tap(_ sender: UIButton) {
        playerQueue.toggleShuffleTracks()
        repeatRepeatShuffleModesRefreshUI()
    }
    
    fileprivate var _parentPlayerDelegate: PlayerQueueDelegate?
    fileprivate var _refreshTimer: Timer = Timer()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _refreshTimer.invalidate()
        playerQueue.setDelegateHandler(_parentPlayerDelegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_playPauseTrack.layer.cornerRadius = 32
        imagevView_trackCover.layer.cornerRadius = 16
        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(trackTitleLblLongPress))
        longPressRecognizer.cancelsTouchesInView = false
        lbl_trackTitle.addGestureRecognizer(longPressRecognizer)
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(trackArtistsLblLongPress))
        longPressRecognizer.cancelsTouchesInView = false
        lbl_trackArtists.addGestureRecognizer(longPressRecognizer)
        
        if playerQueue.playing {
            btn_playPauseTrack.isSelected = true
        } else {
            btn_playPauseTrack.isSelected = false
        }
        
        if let g_currTrack = playerQueue.currTrack {
            likeDislikeRefreshUI(currTrack: g_currTrack)
        }
        initRefreshTimer()
        _parentPlayerDelegate = playerQueue.playerDelegate
        playerQueue.setDelegateHandler(self)
        
        refreshUI()
        repeatRepeatShuffleModesRefreshUI()
        setupTableView()
    }
    
    @objc fileprivate func trackTitleLblLongPress() {
        let popCopyVC = PopupContextMenuVC.initializeVC(keys: [AppService.localizedString(.general_copy)], values: [AppService.localizedString(.general_copy): nil]) { index, items in
            if (index == 0) {
                UIPasteboard.general.string = self.lbl_trackTitle.text
            }
        }
        popCopyVC.initializePopoverVC(sourceControl: lbl_trackTitle, delegate: self)
        self.present(popCopyVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func trackArtistsLblLongPress() {
        let popCopyVC = PopupContextMenuVC.initializeVC(keys: [AppService.localizedString(.general_copy)], values: [AppService.localizedString(.general_copy): nil]) { index, items in
            if (index == 0) {
                UIPasteboard.general.string = self.lbl_trackArtists.text
            }
        }
        popCopyVC.initializePopoverVC(sourceControl: lbl_trackArtists, delegate: self)
        self.present(popCopyVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func initRefreshTimer() {
        _refreshTimer.invalidate()
        _refreshTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.refreshPlaybackSlider), userInfo: nil, repeats: true)
    }
    
    fileprivate func repeatRepeatShuffleModesRefreshUI() {
        if (playerQueue.repeatSingleTrack) {
            btn_playRepeat.setImage(UIImage(named: "ic_repeat_on_single"), for: .selected)
            btn_playRepeat.isSelected = true
        }
        else if (playerQueue.repeatTracks) {
            btn_playRepeat.setImage(UIImage(named: "ic_repeat_on"), for: .selected)
            btn_playRepeat.isSelected = true
        }
        else {
            btn_playRepeat.setImage(UIImage(named: "ic_repeat_on"), for: .selected)
            btn_playRepeat.isSelected = false
        }
        btn_playShuffle.isSelected = playerQueue.shuffleTracks
    }
    
    fileprivate func likeDislikeRefreshUI(currTrack: Track) {
        if let g_lib = appService.likedLibrary {
            btn_trackLike.isSelected = g_lib.contains(track: currTrack)
        } else {
            btn_trackLike.isSelected = false
        }
        if let g_lib = appService.dislikedLibrary {
            btn_trackDislike.isSelected = g_lib.contains(track: currTrack)
        } else {
            btn_trackDislike.isSelected = false
        }
    }
    
    fileprivate func likeTrack(_ track: Track) {
        if let g_lib = appService.likedLibrary, g_lib.contains(track: track) {
            //remove like
            let removeSuccess = appService.likedLibrary?.remove(track: track) ?? false
#if DEBUG
            print("Delete like status for track with id " + track.id + ":" + String(removeSuccess))
#endif
            track.removeLike { result in
#if DEBUG
                print(result)
#endif
            }
        } else {
            let addSuccess = appService.likedLibrary?.add(track: track) ?? false
#if DEBUG
            print("Add like status for track with id " + track.id + ":" + String(addSuccess))
#endif
            track.like { result in
#if DEBUG
                print(result)
#endif
            }
        }
    }
    
    fileprivate func dislikeTrack(_ track: Track) {
        if let g_lib = appService.dislikedLibrary, g_lib.contains(track: track) {
            //remove dislike
            let removeSuccess = appService.dislikedLibrary?.remove(track: track) ?? false
#if DEBUG
            print("Delete dislike status for track with id " + track.id + ":" + String(removeSuccess))
#endif
            track.removeDislike { result in
#if DEBUG
                print(result)
#endif
            }
        } else {
            let res = playerQueue.dislikeTrack(track)
#if DEBUG
            print("Player queue delete track by dislike:" + String(res))
#endif
            let addSuccess = appService.dislikedLibrary?.add(track: track) ?? false
#if DEBUG
            print("Add dislike status for track with id " + track.id + ":" + String(addSuccess))
#endif
            track.dislike { result in
#if DEBUG
                print(result)
#endif
            }
        }
    }
    
    fileprivate func refreshUI() {        
        lbl_trackTitle.text = playerQueue.currTrack?.trackTitle ?? AppService.localizedString(.player_unknown_track_title)
        lbl_trackArtists.text = playerQueue.currTrack?.artistsName.joined(separator: ",") ?? AppService.localizedString(.player_unknown_track_artists)
        refreshPlaybackSlider()
    }
    
    @objc fileprivate func refreshPlaybackSlider() {
        slider_trackPlaybackPosition.minimumValue = 0
        slider_trackPlaybackPosition.maximumValue = Float(playerQueue.trackDuration)
        slider_trackPlaybackPosition.value = Float(playerQueue.trackPlaybackPosition)
        lbl_trackPlaybackPosition.text = playerQueue.trackPlaybackPositionFormatted
        lbl_trackDuration.text = playerQueue.trackDurationFormatted
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: TrackTVCell.className, bundle: nil), forCellReuseIdentifier: TrackTVCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func toggleView() {
        if (tableView.isHidden) {
            tableView.alpha = 0
            tableView.isHidden = false
            tableView.scrollToRow(at: IndexPath(row: playerQueue.currIndex, section: 0), at: .top, animated: false)
            UIView.animate(withDuration: TimeInterval(0.5))
            {
                self.tableView.alpha = 1
            }
        } else {
            tableView.alpha = 1
            UIView.animate(withDuration: TimeInterval(0.5), animations: {
                self.tableView.alpha = 0
            }) {
                finished in
                if (finished) {
                    self.tableView.isHidden = true
                }
            }
        }
    }
}

extension AudioPlayerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerQueue.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = playerQueue.tracks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTVCell.className, for: indexPath) as! TrackTVCell
        cell.initializeCell(trackTitle: track.trackTitle, artists: track.artistsName, cover: nil, available: track.available ?? false, onOptionsPress: {
            let popupMenuVC = PopupTrackMenuVC.initializeVC(parentVC: self, track: track) { index, keys in
                if let g_currTrack = playerQueue.currTrack {
                    self.likeDislikeRefreshUI(currTrack: g_currTrack)
                }
            }
            popupMenuVC.initializePopoverVC(sourceControl: cell.btn_options, delegate: self)
            self.present(popupMenuVC, animated: true, completion: nil)
        })
        if (playerQueue.currIndex == indexPath.row) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if playerQueue.currIndex == indexPath.row {
            return
        }
        if playerQueue.tracks[indexPath.row].available == false {
            tableView.deselectRow(at: indexPath, animated: true)
            if (playerQueue.currIndex >= 0) {
                tableView.selectRow(at: IndexPath(row: playerQueue.currIndex, section: 0), animated: true, scrollPosition: .none)
            }
            return
        }
        playerQueue.setPlayingTrackByIndex(indexPath.row)
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let track = playerQueue.tracks[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            return PopupTrackMenuVC.initializeContextMenu(parentVC: self, track: track)
        }
    }
}

extension AudioPlayerVC: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AudioPlayerVC: PlayerQueueDelegate {
    func trackChanged(_ track: Track, queueIndex: Int) {
        DispatchQueue.main.async {
            self.tableView.selectRow(at: IndexPath(row: queueIndex, section: 0), animated: true, scrollPosition: .none)
            self._parentPlayerDelegate?.trackChanged(track, queueIndex: queueIndex)
            self.likeDislikeRefreshUI(currTrack: track)
            self.refreshUI()
        }
    }
    
    func playStateChanged(playing: Bool) {
        DispatchQueue.main.async {
            self.btn_playPauseTrack.isSelected = playing
        }
    }
    
    func playbackPositionChanged(_ position: TimeInterval) {
        DispatchQueue.main.async {
            self.refreshPlaybackSlider()
        }
    }
}
