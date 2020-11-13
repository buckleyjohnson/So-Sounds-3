//
// Created by Dave Brown on 9/11/19.
// Copyright (c) 2019 So Sound. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, NetworkManagerAuthDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var adminPassword: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var authenticateButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!

    @IBOutlet var demoModeSwitch: UISwitch!
    @IBOutlet var musicBackgroundSwitch: UISwitch!
    @IBOutlet var adminPasswordSwitch: UISwitch!

    var viewWidth: CGFloat = 500
    var viewHeight: CGFloat = 500

    override func viewDidLoad() {

        view.layer.cornerRadius = 15.0
        view.backgroundColor = UIColor.black

        statusLabel.isHidden = true
        spinner.isHidden = true

        if let application = ApplicationDao.instance.application() {
            username.text = application.wordpressUsername
            password.text = application.wordpressPassword
            musicBackgroundSwitch.isOn = application.runInBackground
            adminPasswordSwitch.isOn = application.enableAdminPassword
            adminPassword.text = application.adminPassword
        }

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.frame = CGRect(x: (UIScreen.main.bounds.width - viewWidth) / 2, y:  10, width: viewWidth, height: viewHeight)
//        preferredContentSize = CGSize(width: viewWidth, height: viewHeight)
    }

    @IBAction func authenticateTapped(_ sender: Any) {

        spinner.startAnimating()

        if (username.text?.count == 0 || password.text?.count == 0) {
            self.updateStatusLabel(text: "Username and password fields are required.")
            return
        }

        NetworkManager.authenticateWordPressUser(username: username.text!, password: password.text!, delegate: self)
    }

    @IBAction func saveTapped(_ sender: Any) {

        if let application = ApplicationDao.instance.application() {

            application.enableAdminPassword = adminPasswordSwitch.isOn
            if adminPasswordSwitch.isOn {
                application.adminPassword = adminPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if let wordpressUsername = username.text, let wordpressPassword = password.text,
               wordpressUsername.count > 0, wordpressPassword.count > 0 {
                application.wordpressUsername = wordpressUsername
                application.wordpressPassword = wordpressPassword
            }
            application.runInBackground = musicBackgroundSwitch.isOn
            ApplicationDao.instance.save()
            dismiss(animated: true)
        }
    }

    func authStatus(success: Bool, errorDescription: String?) {

        if success {
            updateStatusLabel(text: "Authentication successful.")
        } else {
            updateStatusLabel(text: errorDescription!)
        }
    }

    func updateStatusLabel(text: String) {

        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.authenticateButton.isEnabled = true
            self.statusLabel.isHidden = false
            self.statusLabel.text = text
        }
    }

    @IBAction func adminPasswordValueChanged(_ sender: Any) {

        adminPassword.isHidden = !adminPasswordSwitch.isOn
    }
    @IBAction func closeTapped(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
}
