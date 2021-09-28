//
//  PopupContextMenuVC.swift
//  QBaR
//
//  Created by Admin on 13.04.2020.
//  Copyright © 2020 Zeit. All rights reserved.
//

import UIKit

class PopupContextMenuVC: UIViewController {
    
    fileprivate static let ITEM_ROW_HEIGHT: CGFloat = 54
    fileprivate static let ITEM_IMAGE_WIDTH: CGFloat = 40
    fileprivate static let ITEM_CHARACTER_WIDTH: CGFloat = 20

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var keys: [String] = []
    fileprivate var items: [String: UIImage?] = [:]
    var selectHandler: ((_ index: Int, _ items: [String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    class func initializeGeneralVC(keys: [String], values: [String: UIImage?], selectHandler: ((_ index: Int, _ items: [String]) -> Void)?) -> PopupContextMenuVC
    {
        let vc = UIStoryboard(name: "Dialog", bundle: nil).instantiateViewController(withIdentifier: PopupContextMenuVC.className) as! PopupContextMenuVC
        vc.modalPresentationStyle = .popover
        vc.keys = keys
        vc.items = values
        vc.selectHandler = selectHandler
        return vc
    }
    
    class func initializeTrackMenuVC(liked: Bool, disliked: Bool, selectHandler: ((_ index: Int, _ items: [String]) -> Void)?) -> PopupContextMenuVC {
        let vc = UIStoryboard(name: "Dialog", bundle: nil).instantiateViewController(withIdentifier: PopupContextMenuVC.className) as! PopupContextMenuVC
        vc.modalPresentationStyle = .popover
        vc.keys = [
            AppService.localizedString(.track_option_like),
            AppService.localizedString(.track_option_download),
            AppService.localizedString(.track_option_dislike)
        ]
        
        vc.items = [
            AppService.localizedString(.track_option_download): UIImage(named: "ic_download"),
        ]
        vc.items[AppService.localizedString(.track_option_like)] = liked && !disliked ? UIImage(named: "ic_liked") : UIImage(named: "ic_like")
        vc.items[AppService.localizedString(.track_option_dislike)] = disliked && !liked ? UIImage(named: "ic_stopped") : UIImage(named: "ic_stop")
        vc.selectHandler = selectHandler
        return vc
    }
    
    func initializePopoverVC(sourceControl: UIView, delegate: UIPopoverPresentationControllerDelegate?)
    {
        let sBounds = sourceControl.bounds
        guard let popOverVC = self.popoverPresentationController else {return}
        popOverVC.permittedArrowDirections = .up.union(.down)
        popOverVC.delegate = delegate
        popOverVC.sourceView = sourceControl
        popOverVC.passthroughViews = nil
        var contentWidth: CGFloat = 0
        for title in keys
        {
            let width: CGFloat = PopupContextMenuVC.ITEM_IMAGE_WIDTH + (CGFloat(title.count) * PopupContextMenuVC.ITEM_CHARACTER_WIDTH)
            if (width > contentWidth)
            {
                contentWidth = width
            }
        }
        let height = PopupContextMenuVC.ITEM_ROW_HEIGHT * CGFloat(items.count)
        popOverVC.sourceRect = CGRect(x: sBounds.maxX / 2, y: sBounds.maxY / 2, width: 0, height: 0)
        self.preferredContentSize = CGSize(width: contentWidth, height: height)
    }
}

extension PopupContextMenuVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let key = keys[indexPath.row]
        cell.textLabel?.text = key
        cell.imageView?.image = items[key] ?? UIImage()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        {
            self.selectHandler?(indexPath.row, self.keys)
        }
    }
}
