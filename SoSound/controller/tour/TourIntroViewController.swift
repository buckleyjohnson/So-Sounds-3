//
//  TourIntroViewController.swift
//  SoSound
//
//  Created by Dave Brown on 9/6/18.
//  Copyright © 2018 So Sound. All rights reserved.
//

import UIKit

class TourIntroViewController: TourViewController {

    var downloadView: MusicDownloadView!
    @IBOutlet var accessCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.downloadView = MusicDownloadView(frame: CGRect.zero)
    }

    @IBAction func downloadMusicTapped(_ sender: Any) {

        // verify access code

        if let accessCode = accessCodeTextField.text, accessCode == "S0Cool" {
            var pageViewController: TourPageViewController = self.parent as! TourPageViewController
            pageViewController.goToNextPage()
        } else {

            let alert = UIAlertController(title: "Invalid Code", message: "That didn't work.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)

//            let errorAlert = UIAlertController(title: "Error", message: "That didn't work!", preferredStyle: .alert)
//            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { in
//                alert?.dismiss(animated: false)
//            }))
//            self.present(errorAlert, animated: true, completion: nil)
        }


    }

    @IBAction func skipTapped(_ sender: Any) {

        var pageViewController: TourPageViewController = self.parent as! TourPageViewController
        pageViewController.goToPage(page: pageViewController.pages.count-1, animated: true)

    }
}
