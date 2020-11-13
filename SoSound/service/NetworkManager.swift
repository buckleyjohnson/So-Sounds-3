//
// Created by Dave Brown on 9/11/19.
// Copyright (c) 2019 So Sound. All rights reserved.
//

import Foundation

public protocol NetworkManagerAuthDelegate {

    func authStatus(success: Bool, errorDescription: String?)
}

class NetworkManager {


    static func authenticateWordPressUser(username: String, password: String, delegate : NetworkManagerAuthDelegate) {

        let url: String = "https://www.staging.sosoundsolutions.com/wp-content/plugins/so-sound/restapi/api.php?request=auth&action=login&username=" + username + "&password=" + password
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)

        request.httpMethod = "GET"
        let session = URLSession.shared
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in

            var authResponse: AuthResult
            if let _error = error {
                log("Error authenticating user. Error: " + _error.localizedDescription)
                delegate.authStatus(success: false, errorDescription: "Error connecting to server.")
            } else {
                guard let dataResponse = data, error == nil else {
                    delegate.authStatus(success: false, errorDescription: "Error encountered authenticating user")
                    log("Error encountered authenticating user")
                    return
                }
                do {
                    authResponse = try JSONDecoder().decode(AuthResult.self, from: dataResponse);
                    if authResponse.data == AuthResultStatus.SUCCESS.rawValue as Int {
                        // save it

//                        self.application.wordpressUsername = self.username.text
//                        self.application.wordpressPassword = self.password.text
//
                        delegate.authStatus(success: true, errorDescription: nil)

//                        self.updateStatusLabel(text: "Authentication successful.")
//                        if (!ApplicationDao.instance.save()) {
//                            let alert = UIAlertController(title: "Database error", message: "Error saving application record.", preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
//                            self.present(alert, animated: true, completion: nil)
//                        }
                    } else {
                        delegate.authStatus(success: false, errorDescription: "Authentication failed.")
                    }
                } catch let error {
                    delegate.authStatus(success: false, errorDescription: "Error authenticating user. Error: " + error.localizedDescription)
                    log("Error authenticating user. Error: " + error.localizedDescription)
                }
            }
        })
        task.resume()
    }
}
