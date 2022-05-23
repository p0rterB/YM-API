//
//  PlaylistsVC.swift
//  Rave
//
//  Created by Developer on 12.05.2022.
//

import UIKit
import YmuzApi

class PlaylistsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var _playlists: [Playlist] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (_playlists.count == 0) {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppService.localizedString(.my_playlists_title)
        setupTableView()
    }
    
    fileprivate func loadData() {
        client.getUserPlaylists(userId: String(client.accountUid)) { result in
            do {
                let playlists = try result.get()
                self._playlists = playlists
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                }
                for playlist in self._playlists {
                    playlist.fetchTracks {
                        result in
                        #if DEBUG
                        print(result)
                        #endif
                    }
                }
            }  catch {
#if DEBUG
                print(error)
#endif
            }
        }
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: PersonalPlaylistsTVCell.className, bundle: nil), forCellReuseIdentifier: PersonalPlaylistsTVCell.className)
        tableView.register(UINib(nibName: LoadingTVCell.className, bundle: nil), forCellReuseIdentifier: LoadingTVCell.className)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self        
    }
}

extension PlaylistsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (_playlists.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
            cell.loadingIndicator.startAnimating()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalPlaylistsTVCell.className, for: indexPath) as! PersonalPlaylistsTVCell
        cell.initializeCell(title: AppService.localizedString(.my_playlists_created_title), playlists: _playlists, onSelect: self)
        return cell
    }
}

extension PlaylistsVC: SelectorDelegate {
    func select(index: Int, object: Any?) {
        let vc = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: PlaylistVC.className) as! PlaylistVC
        vc.playlist = _playlists[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
