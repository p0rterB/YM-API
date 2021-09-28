//
//  PlaylistVC.swift
//  Rave
//
//  Created by Developer on 17.08.2021.
//

import UIKit
import YmuzApi

class PlaylistVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var playlist: Playlist?
    var playlistTracks: [Track] {
        get {
            var res: [Track] = []
            for track in (playlist?.tracks ?? []) {
                if let g_track = track.track {
                    res.append(g_track)
                }
            }
            return res
        }
    }
    fileprivate var _playingIndex: Int = -1
    fileprivate var playlistQueueKey: Int {
        get {
            return (playlist?.kind ?? 0) + playlistTracks.count + (playlist?.uid ?? 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        playerQueue.setDelegateHandler(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        playerQueue.setDelegateHandler(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = playlist?.title ?? ""
        loadData()
        setupTableView()
    }
    
    fileprivate func loadData() {
        if let g_playlist = playlist, let g_tracks = g_playlist.tracks {
            let count = g_tracks.count
            if (count == 0) {
                return
            }
            if let g_currTrack = playerQueue.currTrack {
                for i in 0 ... g_tracks.count - 1 {
                    guard let playlistTrack = g_tracks[i].track else {continue}
                    if (playlistTrack.id.compare(g_currTrack.id) == .orderedSame) {
                        _playingIndex = i
                        break
                    }
                }
            }
            for i in 0 ... count - 1 {
                if g_tracks[i].track == nil {
                    playlist?.tracks?[i].fetchTrack(completion: { result in
                        do {
                            _ = try result.get()
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
                            }
                        } catch {
                            #if DEBUG
                            print(error)
                            #endif
                        }
                    })
                }
            }
        }
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: PlaylistIntroTVCell.className, bundle: nil), forCellReuseIdentifier: PlaylistIntroTVCell.className)
        tableView.register(UINib(nibName: TrackTVCell.className, bundle: nil), forCellReuseIdentifier: TrackTVCell.className)
        tableView.register(UINib(nibName: LoadingTVCell.className, bundle: nil), forCellReuseIdentifier: LoadingTVCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func isTrackLiked(_ track: Track, likeLib: LikeLibrary) -> Bool {
        return likeLib.contains(track: track)
    }
    
    fileprivate func isTrackDisliked(_ track: Track, dislikeLib: LikeLibrary) -> Bool {
        return dislikeLib.contains(track: track)
    }
    
    fileprivate func likeTrack(_ track: Track) {
        if let g_lib = appService.likedLibrary, isTrackLiked(track, likeLib: g_lib) {
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
        if let g_lib = appService.dislikedLibrary, isTrackDisliked(track, dislikeLib: g_lib) {
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
}

extension PlaylistVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return playlist?.tracks?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            //Intro
            if let g_playlist = playlist {
                let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistIntroTVCell.className, for: indexPath) as! PlaylistIntroTVCell
                cell.initalizeCell(title: g_playlist.title, count: g_playlist.tracks?.count ?? 0, img: nil, onDownloadPress: {
                    //TODO
                    //cache data
                })
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
            return cell
        }
        if (indexPath.section == 1) {
            //Tracks
            if let g_tracks = playlist?.tracks, let g_track = g_tracks[indexPath.row].track {
                let cell = tableView.dequeueReusableCell(withIdentifier: TrackTVCell.className, for: indexPath) as! TrackTVCell
                cell.initializeCell(trackTitle: g_track.trackTitle, artists: g_track.artistsName, cover: nil, available: g_track.available ?? false, onOptionsPress: {
                    //TODO
                    let liked = appService.likedLibrary?.contains(track: g_track) ?? false
                    let disliked = appService.likedLibrary?.contains(track: g_track) ?? false
                    
                    let popupMenuVC = PopupContextMenuVC.initializeTrackMenuVC(liked: liked, disliked: disliked) { index, keys in
                        switch(index) {
                        case 0:
                            self.likeTrack(g_track)
                            break
                        case 1:
                            #if DEBUG
                            print("Download press")
                            #endif
                            break
                        case 2:
                            self.dislikeTrack(g_track)
                            break
                        default: break
                        }
                    }
                    popupMenuVC.initializePopoverVC(sourceControl: cell.btn_options, delegate: self)
                    self.present(popupMenuVC, animated: true, completion: nil)
                })
                if (_playingIndex == indexPath.row) {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if _playingIndex == indexPath.row {
            if let gCurrTrack = playerQueue.currTrack, gCurrTrack.id == (playlist?.tracks?[_playingIndex].track?.id ?? "0") {
                return
            }
        }
        if indexPath.section == 1 {
            if playlistTracks[indexPath.row].available == false {
                tableView.deselectRow(at: indexPath, animated: true)
                if (_playingIndex >= 0) {
                    tableView.selectRow(at: IndexPath(row: _playingIndex, section: 1), animated: true, scrollPosition: .none)
                }
                return
            }
            _playingIndex = indexPath.row
            if (playerQueue.queueKey == playlistQueueKey) {
                playerQueue.setPlayingTrackByIndex(_playingIndex)
                return
            }
            playerQueue.setNewTracks(playlistTracks, queueKey: playlistQueueKey, playIndex: _playingIndex, playNow: true)
        }
    }
}

extension PlaylistVC: PlayerQueueDelegate {
    func trackChanged(_ track: Track, queueIndex: Int) {
        if (playerQueue.queueKey == playlistQueueKey) {
            if (_playingIndex == queueIndex)
            {
                return
            }
            _playingIndex = queueIndex
            DispatchQueue.main.async {
                self.tableView.selectRow(at: IndexPath(row: queueIndex, section: 1), animated: true, scrollPosition: .none)
            }
            
        } else if playlistTracks.count > 0 {
            for i in 0 ... playlistTracks.count - 1 {
                let playlistTrack = playlistTracks[i]
                if (playlistTrack.id.compare(track.id) == .orderedSame) {
                    _playingIndex = i
                    DispatchQueue.main.async {
                        self.tableView.selectRow(at: IndexPath(row: queueIndex, section: 1), animated: true, scrollPosition: .none)
                    }
                    break
                }
            }
        } else  {
            // no index
            _playingIndex = -1
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
        }
    }
    
    func playStateChanged(playing: Bool) {}
    
    func playbackPositionChanged(_ position: TimeInterval) {}
}

extension PlaylistVC: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
