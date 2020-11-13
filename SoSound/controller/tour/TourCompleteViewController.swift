//
//  TourCompleteViewController.swift
//  SoSound
//
//  Created by Dave Brown on 9/7/18.
//  Copyright © 2018 So Sound. All rights reserved.
//

import UIKit

class TourCompleteViewController: UIViewController {


    @IBAction func tourCloseTapped(_ sender: Any) {
        dismiss(animated: true)
        if let application = ApplicationDao.instance.application() {
            application.showTour = false
            ApplicationDao.instance.save()
        }
    }

    @IBAction func openSettingsTapped(_ sender: Any) {


        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsViewController.modalPresentationStyle = .overCurrentContext
        self.present(settingsViewController, animated: true)
    }
}
