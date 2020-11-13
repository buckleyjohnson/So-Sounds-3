//
// Created by Dave Brown on 2018-09-25.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class ServerConfigController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var authenticateStatusLabel: UILabel!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet weak var authenticateButton: UIButton!

    var _application: Application?

    override required init?(coder aDecoder: NSCoder) {

        _application = ApplicationDao.instance.application()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = CGSize(width: 450, height: 400)

        if let application = _application {
            username.text = application.wordpressUsername
            password.text = application.wordpressPassword
        }
        self.spinnerView.hidesWhenStopped = true
        self.view.layer.cornerRadius = 15.0
    }

    @IBAction func closeButtonTapped(_ sender: Any) {

        // authenticate?
        self.dismiss(animated: true)
    }

    @IBAction func authenticateTapped(_ sender: Any) {

        spinnerView.startAnimating()
        authenticateButton.isEnabled = false

        // check fields
        if (((username.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == nil) || ((password.text?.trimmingCharacters(in: .whitespacesAndNewlines)) == nil)) {
            self.updateStatusLabel(text: "Username and password fields are required.")
            return
        }

        self.authenticateStatusLabel.isHidden = true
        let url: String = "https://www.staging.sosoundsolutions.com/wp-content/plugins/so-sound/restapi/api.php?request=auth&action=login&username=" + username.text! + "&password=" + password.text!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in

            var authResponse: AuthResult
            if let _error = error {
                log("Error authenticating user. Error: " + _error.localizedDescription)
                self.updateStatusLabel(text: "Error connecting to server.")
            } else {
                guard let dataResponse = data, error == nil else {
                    log("Error encountered authenticating user")
                    self.updateStatusLabel(text: "Error encountered authenticating user")
                    return
                }
                do {
                    authResponse = try JSONDecoder().decode(AuthResult.self, from: dataResponse);
                    if authResponse.data == AuthResultStatus.SUCCESS.rawValue as Int {
                        // save it
                        if let application = self._application {
                            application.wordpressUsername = self.username.text
                            application.wordpressPassword = self.password.text
                        }
                        self.updateStatusLabel(text: "Authentication successful.")
                        if( !ApplicationDao.instance.save() ) {
                            let alert = UIAlertController(title: "Database error", message: "Error saving application record.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        self.updateStatusLabel(text: "Authentication failed.")
                    }
                } catch let error {
                    log("Error authenticating user. Error: " + error.localizedDescription)
                    self.updateStatusLabel(text: "Error during authentication operation.")
                }
            }
        })
        task.resume()
    }

    func updateStatusLabel(text: String) {

        DispatchQueue.main.async {
            self.spinnerView.stopAnimating()
            self.authenticateButton.isEnabled = true
            self.authenticateStatusLabel.isHidden = false
            self.authenticateStatusLabel.text = text
        }
    }
}
