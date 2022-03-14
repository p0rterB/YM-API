//
//  PopupContextMenuVC.swift
//  QBaR
//
//  Created by Admin on 13.04.2020.
//  Copyright © 2020 Zeit. All rights reserved.
//

import UIKit
import YmuzApi

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
    
    class func initializeVC(keys: [String], values: [String: UIImage?], selectHandler: ((_ index: Int, _ items: [String]) -> Void)?) -> PopupContextMenuVC
    {
        let vc = UIStoryboard(name: "Dialog", bundle: nil).instantiateViewController(withIdentifier: PopupContextMenuVC.className) as! PopupContextMenuVC
        vc.modalPresentationStyle = .popover
        vc.keys = keys
        vc.items = values
        vc.selectHandler = selectHandler
        return vc
    }
    
    func initializePopoverVC(sourceControl: UIView, bounds: CGRect, delegate: UIPopoverPresentationControllerDelegate?)
    {
        let sBounds = bounds
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
    
    func initializePopoverVC(sourceControl: UIView, delegate: UIPopoverPresentationControllerDelegate?)
    {
        initializePopoverVC(sourceControl: sourceControl, bounds: sourceControl.bounds, delegate: delegate)
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
        if (keys.count == 1) {
            cell.textLabel?.textAlignment = .center
            tableView.separatorColor = .clear
        }
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
