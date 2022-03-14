//
//  SearchVC.swift
//  Rave
//
//  Created by Developer on 25.08.2021.
//

import UIKit
import YmuzApi

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var _suggestion: Suggestion?
    fileprivate var _searchResult: Search?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (_searchResult == nil) {
            searchBar.becomeFirstResponder()
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRec.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRec)
        setupTableView()
    }
    
    @objc fileprivate func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    fileprivate func suggestion(_ searchString: String) {
        client.getSearchSugggestion(text: searchString) { result in
            do {
                self._suggestion = try result.get()
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
    
    fileprivate func search(_ searchString: String) {
        client.search(text: searchString, noCorrect: true, type: .track, page: 0, includeBestPlaylists: false) { result in
            do {
                self._searchResult = try result.get()
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
        tableView.register(UINib(nibName: LoadingTVCell.className, bundle: nil), forCellReuseIdentifier: LoadingTVCell.className)
        tableView.register(UINib(nibName: TrackTVCell.className, bundle: nil), forCellReuseIdentifier: TrackTVCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let g_search = _searchResult, let g_tracks = g_search.tracks?.results {
            return g_tracks.count
        }
        if let g_suggestion = _suggestion {
            return g_suggestion.suggestions.count
        }
        return (searchBar.text?.isEmpty ?? true) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let g_tracks = _searchResult?.tracks {
            let track = g_tracks.results[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackTVCell.className, for: indexPath) as! TrackTVCell
            cell.initializeCell(trackTitle: track.title ?? "", artists: track.artistsName, cover: nil, available: track.available ?? false, onOptionsPress: {
                let popupMenuVC = PopupTrackMenuVC.initializeVC(parentVC: self, track: track, selectHandler: nil)
                popupMenuVC.initializePopoverVC(sourceControl: cell.btn_options, delegate: self)
                self.present(popupMenuVC, animated: true, completion: nil)
            })
            return cell
        }
        if let g_suggestion = _suggestion {
            let cell = UITableViewCell()
            if (g_suggestion.suggestions.count > indexPath.row) {
                cell.textLabel?.text = g_suggestion.suggestions[indexPath.row]
            }            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTVCell.className, for: indexPath) as! LoadingTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let g_search = _searchResult, let g_tracks = g_search.tracks?.results {
            playerQueue.setNewTracks(g_tracks, queueKey: 100, playIndex: indexPath.row, playNow: true)
            return
        }
        if let g_suggestion = _suggestion {
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at: indexPath)
            if let g_text = cell?.textLabel?.text {
                _suggestion = nil
                searchBar.text = g_suggestion.suggestions[indexPath.row]
                tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                search(g_text)
                return
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if let g_tracks = _searchResult?.tracks {
            let track = g_tracks.results[indexPath.row]
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
                return PopupTrackMenuVC.initializeContextMenu(parentVC: self, track: track)
            }
        }
        return nil
    }
}

extension SearchVC: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        _suggestion = nil
        _searchResult = nil
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        if let g_text = searchBar.text {
            search(g_text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _searchResult = nil
        suggestion(searchText)
    }
}
