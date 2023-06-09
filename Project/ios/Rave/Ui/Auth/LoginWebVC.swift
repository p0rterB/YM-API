//
//  AmLoginVC.swift
//  Rave
//
//  Created by Developer on 04.06.2023.
//

import UIKit
import WebKit
import YmuzApi

class LoginWebVC: UIViewController {
    
    @IBOutlet weak var webView_auth: WKWebView!
    @IBOutlet weak var btn_restart: UIButton!
    @IBOutlet weak var indicator_auth: UIActivityIndicatorView!
    @IBOutlet weak var lbl_auth: UILabel!
    @IBAction func btn_restart_tap(_ sender: UIButton) {
        initAuthorization()
    }
    
    fileprivate var _trackId: String = ""
    fileprivate var _yaCookie: String = ""
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    fileprivate func setupUI() {
        btn_restart.setTitle(AppService.localizedString(.general_restart), for: .normal)
        lbl_auth.text = AppService.localizedString(.auth_generating_access_token)
        
        initAuthorization()
    }
    
    fileprivate func initAuthorization() {
        _trackId = ""
        _yaCookie = "";
        lbl_auth.isHidden = true
        indicator_auth.isHidden = true
        btn_restart.isHidden = true
        
        let pair = client.generateInitAuthSessionRequest()
        guard let req = pair.1 else {
            let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
            self.present(alertVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                {
                    alertVC.dismiss(animated: true, completion: nil)
                    self.authErrorState()
                }
            }
            return
        }
        webView_auth.navigationDelegate = self
        webView_auth.load(req)
    }
    
    fileprivate func authErrorState() {
        btn_restart.isHidden = false
        lbl_auth.isHidden = true
        indicator_auth.isHidden = true
    }
    
    fileprivate func finishAuthorization() {
        lbl_auth.isHidden = false
        indicator_auth.isHidden = false
        indicator_auth.startAnimating()
        btn_restart.isHidden = true
        client.generateXTokenFromChallengeTrackId(trackId: _trackId, yaClientCookie: _yaCookie) {
            result in
            do {
                let dict = try result.get()
                let xToken: String = dict[.access_token] ?? ""
                if (xToken.isEmpty) {
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
                        self.present(alertVC, animated: true) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                            {
                                alertVC.dismiss(animated: true, completion: nil)
                                self.authErrorState()
                            }
                        }
                    }
                    return
                }
                self.generateYMToken(xToken: xToken)
            } catch {
#if DEBUG
                print(error)
#endif
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
                    self.present(alertVC, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            alertVC.dismiss(animated: true, completion: nil)
                            self.authErrorState()
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func generateYMToken(xToken: String) {
        client.generateYMTokenFromXToken(xToken: xToken) { result in
            do {
                let dict = try result.get()
                let uid = Int(dict[.uid] ?? "") ?? -1
                let actualToken: String = dict[.access_token] ?? ""
                if (uid == -1 && actualToken.isEmpty) {
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
                        self.present(alertVC, animated: true) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                            {
                                alertVC.dismiss(animated: true, completion: nil)
                                self.authErrorState()
                            }
                        }
                    }
                    return
                }
                appService.properties.uid = uid
                appService.properties.save()
                AppService.saveToken(actualToken)
                DispatchQueue.main.async {
                    let clientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuTBC") as! UITabBarController
                    self.navigationController?.setViewControllers([clientVC], animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
                    self.present(alertVC, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            alertVC.dismiss(animated: true, completion: nil)
                            self.authErrorState()
                        }
                    }
                }
            }
        }
    }
}

extension LoginWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if _trackId.isEmpty, let g_url = webView.url, let g_trackId = extractTrackId(g_url) {
            _trackId = g_trackId
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                var iterator = cookies.makeIterator()
                if let g_next = iterator.next() {
                    self._yaCookie = g_next.name + "=" + g_next.value
                }
                while(true) {
                    guard let g_next = iterator.next() else { break }
                    self._yaCookie += "; " + g_next.name + "=" + g_next.value
                }
                self.finishAuthorization()
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if _trackId.isEmpty, let g_response = navigationResponse.response as? HTTPURLResponse, let g_url = g_response.url, let g_trackId = extractTrackId(g_url) {
            _trackId = g_trackId
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                var iterator = cookies.makeIterator()
                if let g_next = iterator.next() {
                    self._yaCookie = g_next.name + "=" + g_next.value
                }
                while(true) {
                    guard let g_next = iterator.next() else { break }
                    self._yaCookie += "; " + g_next.name + "=" + g_next.value
                }
                self.finishAuthorization()
            }
        }
        decisionHandler(.allow)
    }
    
    fileprivate func extractTrackId(_ url: URL) -> String? {
        let urlStr = url.absoluteString
        if (!urlStr.contains("passport.yandex.ru/am/finish") || !urlStr.contains("status=ok")) {
            return nil
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let g_queryItems = components?.queryItems else {return nil}
        for item in g_queryItems {
            guard let g_val = item.value else {continue}
            if (g_val.isEmpty) {
                continue
            }
            if (item.name != "track_id" && item.name != "trackId") {
                continue
            }
            
            return g_val
        }
        
        return nil
    }
}
