//
//  PersonalPlaylistsTVCell.swift
//  Rave
//
//  Created by Developer on 10.08.2021.
//

import UIKit
import YmuzApi

class PersonalPlaylistsTVCell: UITableViewCell{

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var collectionView_playlists: UICollectionView!
    
    fileprivate var _playlists: [Playlist] = []
    fileprivate var _selector: SelectorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        collectionView_playlists.dataSource = self
        collectionView_playlists.delegate = self
        collectionView_playlists.register(UINib(nibName: PersonalPlaylistCVCell.className, bundle: nil), forCellWithReuseIdentifier: PersonalPlaylistCVCell.className)
    }
    
    func initializeCell(playlists: [Playlist], onSelect: SelectorDelegate) {
        _playlists = playlists
        _selector = onSelect
        lbl_title.text = AppService.localizedString(.landing_personal_playlists_title)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension PersonalPlaylistsTVCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let playlist = _playlists[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalPlaylistCVCell.className, for: indexPath) as! PersonalPlaylistCVCell
        var updateInfo = AppService.localizedString(.playlist_updated) + " "
        if let g_dt = playlist.modifyDate {
            let offset = Date().timeIntervalSince(g_dt)
            if (offset < 3600 * 24) {
                updateInfo += AppService.localizedString(.general_today)
            }
            else if (offset > 3600 * 24 && offset < 3600 * 48) {
                updateInfo += AppService.localizedString(.general_yesterday)
            } else {
                let dateComponents = Calendar.current.dateComponents([.month, .day], from: g_dt)
                let day = dateComponents.day ?? 1
                let dayStr = day < 10 ? "0" + String(day) : String(day)
                let month = dateComponents.month ?? 1
                let monthStr = month < 10 ? "0" + String(month) : String(month)
                updateInfo += dayStr + "." + monthStr
            }
        } else {
            updateInfo += AppService.localizedString(.general_today)
        }
        cell.initializeCell(innerViewBgColor: UIColor.purple, title: playlist.title, updateInfo: updateInfo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selector?.select(index: indexPath.row, object: nil)
    }
}
