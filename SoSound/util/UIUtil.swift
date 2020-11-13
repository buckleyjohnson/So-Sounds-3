//
// Created by Dave Brown on 2018-11-19.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class UIUtil {


    static func getFormattedMusicTime(durationInSeconds: Int32) -> String {
        let seconds = durationInSeconds % 60
        let minutes = (durationInSeconds / 60) % 60
        let hours = durationInSeconds / 3600

        var result: String
        if hours > 0 {
            result = String(format: "%2d:%02d:%02d", hours, minutes, seconds);
        } else {
            result = String(format: "%2d:%02d", minutes, seconds);
        }
        return result
    }

    static func getFormattedMusicPlayTime(durationInSeconds: Int32) -> String {
        let seconds = durationInSeconds % 60
        let minutes = (durationInSeconds / 60) % 60
        let hours = durationInSeconds / 3600

        var result: String = ""
        if hours > 0 {
            result = String(format: "%d %@", hours, hours > 1 ? "hours" : "hour");
            if minutes > 0 {
                result += " "
            }
        }

        if minutes > 0 {
            result += String(format: "%d %@", minutes, minutes > 1 ? "minutes" : "minute");
        }
        return result
    }

    static func displayAlert(title: String, message: String, parent: UIViewController, completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        parent.present(alert, animated: true, completion: completion)
    }
}
