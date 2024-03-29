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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        playerQueue.setDelegateHandler(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
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
            if (g_tracks.count == 0) {
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
            let count = g_tracks.count
            var i: Int = 0, loaded: UInt32 = 0
            let loadCount = count >= 70 ? 70 : count
            while loaded != loadCount && i < count {
                if g_tracks[i].track == nil {
                    loaded += 1
                    let rowIndex = i
                    playlist?.tracks?[rowIndex].fetchTrack(completion: { result in
                        do {
                            _ = try result.get()
                            DispatchQueue.main.async {
                                self.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 1)], with: .automatic)
                            }
                        } catch {
#if DEBUG
                            print(error)
#endif
                        }
                    })
                }
                i += 1
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
                cell.initalizeCell(title: g_playlist.title, count: g_playlist.tracks?.count ?? 0, img: nil)
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
                    let popupMenuVC = PopupTrackMenuVC.initializeVC(parentVC: self, track: g_track, selectHandler: nil)
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
            let loadedTracks = playlistTracks
            if loadedTracks.count < indexPath.row || loadedTracks[indexPath.row].available == false {
                tableView.deselectRow(at: indexPath, animated: true)
                if (_playingIndex >= 0) {
                    tableView.selectRow(at: IndexPath(row: _playingIndex, section: 1), animated: true, scrollPosition: .none)
                }
                return
            }
            
            if (_playingIndex < 0) {
                _playingIndex = indexPath.row
            }
            if (playerQueue.tracks.count >= loadedTracks.count && playerQueue.currTrack?.trackId.compare(loadedTracks[_playingIndex].trackId) == .orderedSame) {
                _playingIndex = indexPath.row
                playerQueue.setPlayingTrackByIndex(_playingIndex)
                return
            }
            
            _playingIndex = indexPath.row
            playerQueue.setNewTracks(playlistTracks, playIndex: _playingIndex, playNow: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let trackShort = playlist?.tracks?[indexPath.row]
            if (trackShort?.track != nil) {
                return
            }
            trackShort?.fetchTrack(completion: { result in
                do {
                    _ = try result.get()
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                } catch {
#if DEBUG
                    print(error)
#endif
                }
            })
        }
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.section == 1, let g_tracks = playlist?.tracks, let g_track = g_tracks[indexPath.row].track {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
                return PopupTrackMenuVC.initializeContextMenu(parentVC: self, track: g_track)
            }
            
        }
        return nil
    }
}

extension PlaylistVC: PlayerQueueDelegate {
    func radioStreamTracksUpdated(_ allTracks: [Track]) {}
    
    func trackChanged(_ track: Track, queueIndex: Int) {
        let loadedTracks = playlistTracks
        let playlistItemsCount = playlist?.tracks?.count ?? 0
        if queueIndex + 2 < playlistItemsCount && queueIndex + 2 >= loadedTracks.count && playlistItemsCount > loadedTracks.count {
            let trackShort = playlist?.tracks?[queueIndex + 2]
            if (trackShort?.track == nil) {
                trackShort?.fetchTrack(completion: { result in
                    do {
                        _ = try result.get()
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [IndexPath(row: queueIndex + 2, section: 1)], with: .automatic)
                        }
                        playerQueue.setNewTracks(self.playlistTracks, playIndex: queueIndex, playNow: true)
                    } catch {
    #if DEBUG
                        print(error)
    #endif
                    }
                })
            }
        }
        if loadedTracks.count > 0 {
            for i in 0 ... loadedTracks.count - 1 {
                let playlistTrack = loadedTracks[i]
                if (playlistTrack.id.compare(track.id) == .orderedSame) {
                    _playingIndex = i
                    DispatchQueue.main.async {
                        self.tableView.selectRow(at: IndexPath(row: queueIndex, section: 1), animated: true, scrollPosition: .none)
                    }
                    return
                }
            }
        }
        // no index
        _playingIndex = -1
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
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
