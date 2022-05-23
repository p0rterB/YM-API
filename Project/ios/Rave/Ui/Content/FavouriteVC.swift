//
//  FavouriteVC.swift
//  Rave
//
//  Created by Developer on 17.08.2021.
//

import UIKit
import YmuzApi

class FavouriteVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var likedTracks: LikeLibrary?
    var likedGeneratedPlaylist: Playlist? {
        get {
            guard let g_likedTracks = likedTracks?.tracks else {return nil}
            var tracksData: [TrackShort] = []
            for track in g_likedTracks {
                if let idStr = track.id, let id = Int(idStr) {
                    tracksData.append(TrackShort(id: id, timestamp: track.timestamp ?? "", originalIndex: nil, albumId: track.albumId, playCount: nil, recent: nil, chart: nil, track: nil))
                }
            }
            let playlist = Playlist(owner: nil, cover: nil, madeFor: nil, playCounter: nil, playlistAbsence: nil, uid: appService.properties.uid, kind: -1, title: AppService.localizedString(.playlist_favourite_title), trackCount: g_likedTracks.count, tags: [], revision: nil, snapshot: nil, visibility: nil, collective: nil, urlPart: nil, created: nil, modified: nil, available: nil, isBanner: nil, isPremiere: nil, durationMs: nil, ogImage: nil, ogTitle: nil, ogDescription: nil, image: nil, coverWithoutText: nil, contest: nil, backgroundColor: nil, backgroundImageUrl: nil, textColor: nil, idForFrom: nil, dummyDescription: nil, dummyPageDescription: nil, dummyCover: nil, dummyRolloverCover: nil, ogData: nil, branding: nil, metrikaId: nil, coauthors: nil, topArtist: nil, recentTracks: nil, tracks: tracksData, pager: nil, prerolls: nil, likesCount: nil, similarPlaylists: nil, lastOwnerPlaylists: nil, generatedPlaylistType: nil, animatedCoverUri: nil, everPlayed: nil, description: nil, descriptionFormatted: nil, playlistUuid: nil, type: nil, ready: nil, isForFrom: nil, regions: nil)
            return playlist
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppService.localizedString(.favourite_title)
        setupTableView()
    }
    
    fileprivate func loadData() {
        client.getLikedTracks(modifiedRevision: nil) { result in
            do {
                self.likedTracks = try result.get()
                appService.likedLibrary = self.likedTracks
            } catch {
                self.likedTracks = appService.likedLibrary
                #if DEBUG
                print(error)
                #endif
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: LoadingTVCell.className, bundle: nil), forCellReuseIdentifier: LoadingTVCell.className)
        tableView.register(UINib(nibName: FavouriteIntroTVCell.className, bundle: nil), forCellReuseIdentifier: FavouriteIntroTVCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension FavouriteVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return likedTracks != nil ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let g_likedTracks = likedTracks {
            if (indexPath.section == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteIntroTVCell.className, for: indexPath) as! FavouriteIntroTVCell
                cell.initializeCell(tracksCount: g_likedTracks.tracks?.count ?? 0)
                return cell
            }
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = AppService.localizedString(.general_tracks)
                break
            case 1:
                cell.textLabel?.text = AppService.localizedString(.general_albums)
                break
            case 2:
                cell.textLabel?.text = AppService.localizedString(.general_artists)
                break
            case 3:
                cell.textLabel?.text = AppService.localizedString(.general_playlists)
                break
            case 4:
                cell.textLabel?.text = AppService.localizedString(.general_podcasts)
                break
            case 5:
                cell.textLabel?.text = AppService.localizedString(.general_downloaded_tracks)
                break
            default:
                break
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 1) {
            switch indexPath.row {
            case 0:
                let vc = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: PlaylistVC.className) as! PlaylistVC
                vc.playlist = likedGeneratedPlaylist
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                break
            case 2:
                break
            case 3:
                let vc = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: PlaylistsVC.className) as! PlaylistsVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                break
            case 5:
                break
            default:
                break
            }
        }
    }
}
