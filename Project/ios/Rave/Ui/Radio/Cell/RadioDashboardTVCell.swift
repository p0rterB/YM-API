//
//  RadioDashboardTVCell.swift
//  Rave
//
//  Created by Developer on 27.08.2021.
//

import UIKit
import YmuzApi

class RadioDashboardTVCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var collectionView_stations: UICollectionView!
    
    fileprivate var _stations: [StationResult] = []
    fileprivate var _selector: SelectorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        collectionView_stations.dataSource = self
        collectionView_stations.delegate = self
        collectionView_stations.register(UINib(nibName: RadioCVCell.className, bundle: nil), forCellWithReuseIdentifier: RadioCVCell.className)
    }
    
    func initializeCell(stations: [StationResult], onSelect: SelectorDelegate) {
        _stations = stations
        _selector = onSelect
        lbl_title.text = AppService.localizedString(.radio_recommended_stations)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension RadioDashboardTVCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _stations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let station = _stations[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RadioCVCell.className, for: indexPath) as! RadioCVCell
        let title = station.station?.name ?? station.rupTitle ?? AppService.localizedString(.radio_title)
        if (!playerQueue.stationStream) {
            cell.initializeCell(innerViewBgColor: UIColor.purple, stationImg: nil, title: title)
        } else if (!playerQueue.stationId.isEmpty && playerQueue.stationId.compare(station.station?.radioId ?? "") == .orderedSame) {
            cell.initializeCell(innerViewBgColor: UIColor.blue, stationImg: nil, title: title)
        } else {
            cell.initializeCell(stationImg: nil, title: title)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selector?.select(index: indexPath.row, object: nil)
    }
}
