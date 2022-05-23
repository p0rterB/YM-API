//
//  RadioVC.swift
//  Rave
//
//  Created by Developer on 27.08.2021.
//

import UIKit
import YmuzApi

class RadioVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var _dashboard: RadioDashboard?
    fileprivate var _stations: [StationResult] = []
    fileprivate var _selectedIndex = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupTableView()
    }
    
    fileprivate func loadData() {
        client.getRadioStationsDashboard { result in
            do {
                let dashboard = try result.get()
                self._dashboard = dashboard
                self._stations = []
                for station in dashboard.stations
                {
                    self._stations.append(station)
                }
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
        tableView.register(UINib(nibName: RadioDashboardTVCell.className, bundle: nil), forCellReuseIdentifier: RadioDashboardTVCell.className)
        tableView.register(UINib(nibName: LoadingTVCell.className, bundle: nil), forCellReuseIdentifier: LoadingTVCell.className)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension RadioVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (_dashboard == nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioDashboardTVCell.className, for: indexPath) as! RadioDashboardTVCell
        cell.initializeCell(stations: _stations, onSelect: self)
        return cell
    }
}

extension RadioVC: SelectorDelegate {
    func select(index: Int, object: Any?) {
        if (_selectedIndex != index) {
            _selectedIndex = index
            client.getRadioStationTracksBatch(stationId: _stations[index].station?.radioId ?? "", lastTrackId: nil) { result in
                do {
                    let batch = try result.get()
                    var tracks: [Track] = []
                    for seqItem in batch.sequence {
                        if let g_track = seqItem.track {
                            tracks.append(g_track)
                        }
                    }
                    if (tracks.count > 0) {
                        playerQueue.setStationStream(stationId: self._stations[index].station?.radioId ?? "", startBatchId: batch.batchId, startTracks: tracks)                        
                    }
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                }
            }
        }
    }
}
