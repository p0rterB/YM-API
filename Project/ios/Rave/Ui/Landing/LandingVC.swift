//
//  LandingVC.swift
//  Rave
//
//  Created by Developer on 10.08.2021.
//

import UIKit
import YmuzApi

class LandingVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var _feed: Feed?
    fileprivate var _playlists: [Playlist] = []
    fileprivate var _playlistLoadTimestamp: TimeInterval = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (_playlists.count > 0) {
            let loadDate = Date(timeIntervalSince1970: _playlistLoadTimestamp)
            let loadDay = Calendar.current.dateComponents([.day], from: loadDate).day ?? 0
            let nowDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
            if (loadDay != nowDay) {
                _playlists = []
                _feed = nil
                tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                loadData()
            }
        } else {
            loadData()
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppService.localizedString(.landing_title)
        setupTableView()
    }
    
    fileprivate func loadData() {
        client.getFeed { result in
            do {
                let feed = try result.get()
                self._feed = feed
                self._playlists = []
                for playlist in feed.generatedPlaylists
                {
                    if let g_playlist = playlist.data {
                        self._playlists.append(g_playlist)
                    }
                }
                self._playlistLoadTimestamp = Date().timeIntervalSince1970
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: PersonalPlaylistsTVCell.className, bundle: nil), forCellReuseIdentifier: PersonalPlaylistsTVCell.className)
        tableView.register(UINib(nibName: LoadingTVCell.className, bundle: nil), forCellReuseIdentifier: LoadingTVCell.className)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension LandingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (_feed == nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalPlaylistsTVCell.className, for: indexPath) as! PersonalPlaylistsTVCell
        cell.initializeCell(playlists: _playlists, onSelect: self)
        return cell
    }
}

extension LandingVC: SelectorDelegate {
    func select(index: Int, object: Any?) {
        let vc = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: PlaylistVC.className) as! PlaylistVC
        vc.playlist = _playlists[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
