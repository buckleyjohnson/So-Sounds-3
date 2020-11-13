//
// Created by Dave Brown on 2018-09-25.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class AdministrativePasswordController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet var passwordVerify: UITextField!
    @IBOutlet weak var authenticateStatusLabel: UILabel!
    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet var usePasswordSwitch: UISwitch!

    override required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = CGSize(width: 450, height: 320)

        if let application = ApplicationDao.instance.application() {

            password.text = application.wordpressPassword
            usePasswordSwitch.isOn = application.enableAdminPassword
            password.text = application.adminPassword
            passwordVerify.text = application.adminPassword
        }
        view.layer.cornerRadius = 15.0
    }

    @IBAction func closeButtonTapped(_ sender: Any) {

        // authenticate?
        dismiss(animated: true)
    }

    @IBAction func usePasswordChanged(_ sender: Any) {

        password.isEnabled = usePasswordSwitch.isOn
        passwordVerify.isEnabled = usePasswordSwitch.isOn
    }

    @IBAction func saveTapped(_ sender: Any) {

        if usePasswordSwitch.isOn && (password.text == nil || password.text?.count == 0) {
            let alert = UIAlertController(title: "Error", message: "Password cannot be blank.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            // check passwords
            if let application = ApplicationDao.instance.application() {
                if password.text != passwordVerify.text {
                    let alert = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    present(alert, animated: true, completion: nil)
                } else {
                    application.enableAdminPassword = usePasswordSwitch.isOn
                    application.adminPassword = password.text
                }
            }
//        }
        }
    }
}