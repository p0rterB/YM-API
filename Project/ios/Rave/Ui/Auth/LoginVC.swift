//
//  LoginVC.swift
//  Rave
//
//  Created by Developer on 24.05.2021.
//

import UIKit
import YmuzApi

class LoginVC: UIViewController {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tb_login: UITextField!
    @IBAction func tb_login_Edited(_ sender: UITextField) {
        _pass = ""
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btn_next: UIButton!
    @IBAction func btn_next_Tap(_ sender: UIButton) {
        view.endEditing(true)
        if (_pass != "") {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            UIView.animate(withDuration: 0.2) {
                self.loadingIndicator.transform = CGAffineTransform(translationX: 0, y: self.loadingIndicator.frame.height * 1.5)
            }
            client.authByCredentials(login: tb_login.text ?? "", pass: _pass, captchaAnswer: nil, captchaKey: nil, captchaCallback: nil) { result in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.loadingIndicator.transform = .identity
                    } completion: { (finished) in
                        if (finished) {
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.isHidden = true
                        }
                    }
                }
                do {
                    let dict = try result.get()
                    let uid = Int(dict[.uid] ?? "") ?? -1
                    let actualToken: String = dict[.access_token] ?? ""
                    if (uid == -1 && actualToken.compare("") == .orderedSame) {
                        self._pass = ""
                        DispatchQueue.main.async {
                            let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
                            self.present(alertVC, animated: true) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                                {
                                    alertVC.dismiss(animated: true, completion: nil)
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
                } catch YMError.invalidResponseStatusCode(let errCode, let description) {
                    self._pass = ""
                    let msg: String = "No actual response value of auth: code " + String(errCode) + " - " + description
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: msg, preferredStyle: .alert)
                        self.present(alertVC, animated: true) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                            {
                                alertVC.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                    } catch {
                        #if DEBUG
                        print(error)
                        #endif
                        self._pass = ""
                        DispatchQueue.main.async {
                            let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.general_error), preferredStyle: .alert)
                            self.present(alertVC, animated: true) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                                {
                                    alertVC.dismiss(animated: true, completion: nil)
                                }
                            }
                        }                        
                    }
            }
            return
        }
        if (validateLogin())
        {
            let passVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: PopPasswordVC.className) as! PopPasswordVC
            passVC.login = tb_login.text ?? ""
            passVC.delegate = self
            passVC.modalTransitionStyle = .crossDissolve
            passVC.modalPresentationStyle = .overFullScreen
            self.present(passVC, animated: true)
        }
    }
    
    fileprivate var _pass: String = ""
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .large
        }
        setupUI()
    }
    
    fileprivate func setupUI() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        lbl_title.text = AppService.localizedString(.auth_login_title)
        tb_login.placeholder = AppService.localizedString(.auth_login_hint)
        tb_login.delegate = self
        btn_next.setTitle(AppService.localizedString(.general_next), for: .normal)
        btn_next.layer.cornerRadius = 16
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardAction))
        tapRecognizer.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func validateLogin() -> Bool
    {
        if (tb_login.text?.compare("") == ComparisonResult.orderedSame) {
            let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.auth_empty_login_error), preferredStyle: .alert)
            self.present(alertVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                {
                    alertVC.dismiss(animated: true, completion: nil)
                }
            }
            return false
        }
        return true
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let ns_keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let ns_keyboardRect_other = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardHeight = max(ns_keyboardRect.cgRectValue.height, ns_keyboardRect_other.cgRectValue.height) - 8
        let difference = -keyboardHeight
        self.btn_next.transform = CGAffineTransform(translationX: 0, y: CGFloat(difference))
    }
    @objc func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.btn_next.transform = .identity
        })
    }
    
    @objc func hideKeyboardAction() {
        view.endEditing(true)
    }
}

extension LoginVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        btn_next_Tap(btn_next)
        return true
    }
}

extension LoginVC: PasswordProviderDelegate
{
    func password (_ pass: String)
    {
        _pass = pass
        btn_next_Tap(btn_next)
    }
}
