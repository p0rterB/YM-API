//
//  PropfileVC.swift
//  Rave
//
//  Created by Developer on 29.08.2021.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBAction func barBtn_logout_Tap(_ sender: UIBarButtonItem) {
        logout()
    }
    @IBOutlet weak var imgView_profileAva: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_settingsHeader: UILabel!
    @IBOutlet weak var view_trafficEconomy: UIView!
    @IBOutlet weak var lbl_trafficEconomy: UILabel!
    @IBOutlet weak var slider_trafficEconomy: UISwitch!
    @IBAction func slider_trafficEconomy_Changed(_ sender: UISwitch) {
        appService.properties.trafficEconomy = sender.isOn
        appService.properties.save()
    }
    @IBOutlet weak var lbl_trafficEconomyHint: UILabel!
    @IBOutlet weak var lbl_aboutHeader: UILabel!
    @IBOutlet weak var view_version: UIView!
    @IBOutlet weak var lbl_appVersion: UILabel!
    @IBOutlet weak var lbl_appVersionValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    fileprivate func loadData() {
        client.getAccountStatus { result in
            do {
                let status = try result.get()
                var userName = status.account?.fullName ?? ""
                let login = status.account?.login ?? ""
                if (login.compare("") != .orderedSame) {
                    if (userName.compare("") == .orderedSame) {
                        userName += "(" + login + ")"
                    } else {
                        userName = login
                    }
                }
                DispatchQueue.main.async {
                    self.lbl_userName.text = userName
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    fileprivate func setupUI() {
        self.title = AppService.localizedString(.profile_title)
        lbl_userName.text = ""
        lbl_settingsHeader.text = AppService.localizedString(.general_settings).uppercased()
        view_trafficEconomy.layer.cornerRadius = 16
        lbl_trafficEconomy.text = AppService.localizedString(.profile_traffic_economy)
        slider_trafficEconomy.setOn(appService.properties.trafficEconomy, animated: false)
        lbl_trafficEconomyHint.text = AppService.localizedString(.profile_traffic_economy_hint)
        lbl_aboutHeader.text = AppService.localizedString(.general_about).uppercased()
        view_version.layer.cornerRadius = 16
        lbl_appVersion.text = AppService.localizedString(.general_version)
        lbl_appVersionValue.text = Constants.PSEUDO_BUNDLE_VERSION + " (" + Constants.PSEUDO_BUNDLE_BUILD_NUMBER + ")"
    }
    
    fileprivate func logout() {
        let alertVC = UIAlertController(title: AppService.localizedString(.profile_logout_hint), message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: AppService.localizedString(.general_yes), style: .destructive, handler: { action in
            AppService.saveToken("")
            appService = AppService()
            let navVC = self.navigationController?.navigationController
            let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: LoginWebVC.className) as! LoginWebVC
            navVC?.setViewControllers([loginVC], animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: AppService.localizedString(.general_no), style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
