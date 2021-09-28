//
//  PopPasswordVC.swift
//  Rave
//
//  Created by Developer on 24.05.2021.
//

import UIKit

protocol PasswordProviderDelegate {
    func password(_ pass: String)
}

class PopPasswordVC: UIViewController {
    
    @IBOutlet weak var view_inner: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBAction func btn_close_Tap(_ sender: UIButton) {
        closePopup()
    }
    @IBOutlet weak var tb_pass: UITextField!
    @IBOutlet weak var btn_next: UIButton!
    @IBAction func btn_next_Tap(_ sender: UIButton) {
        if (tb_pass.text?.compare("") == ComparisonResult.orderedSame) {
            let alertVC = UIAlertController(title: AppService.localizedString(.general_error), message: AppService.localizedString(.auth_empty_pass_error), preferredStyle: .alert)
            self.present(alertVC, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                {
                    alertVC.dismiss(animated: true, completion: nil)
                }
            }
            return
        }
        if let g_pass = tb_pass.text {
            delegate?.password(g_pass)
            closePopup()
        }
    }
    
    var login: String = ""
    var delegate: PasswordProviderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view_inner.layer.cornerRadius = 16
        if #available(iOS 11.0, *) {
            btn_next.clipsToBounds = true
            btn_next.layer.cornerRadius = 16
            btn_next.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            let path = UIBezierPath(roundedRect: btn_next.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            btn_next.layer.mask = mask
        }
        var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardAction))
        tapRecognizer.cancelsTouchesInView = false
        self.view_inner.addGestureRecognizer(tapRecognizer)
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closePopup))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        lbl_title.text = AppService.localizedString(.auth_enter_password) + "\n" + login
        tb_pass.placeholder = AppService.localizedString(.general_password)
        tb_pass.delegate = self
    }
    
    @objc fileprivate func hideKeyboardAction()
    {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func closePopup()
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PopPasswordVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        btn_next_Tap(btn_next)
        return true
    }
}
