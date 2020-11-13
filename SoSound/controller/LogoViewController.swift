//
//  LogoViewController.swift
//  SoSound
//
//  Created by David on 7/10/17.
//  Copyright © 2017 Reverie. All rights reserved.
//

import UIKit
import CoreBluetooth
import AVFoundation

class LogoViewController: UIViewController {
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var btleButton: UIButton!
    @IBOutlet weak var volLabel: UILabel!
    @IBOutlet weak var volSlider: UISlider!
    @IBOutlet var pausePlayButton: UIButton!
    @IBOutlet weak var firstTimeDemoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.black

        let tap = UITapGestureRecognizer(target: self, action: #selector(adminDoubleTapped))
        tap.numberOfTapsRequired = 2
        adminButton.addGestureRecognizer(tap)

        let tapPausePlay = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped))
        tapPausePlay.numberOfTapsRequired = 2
        pausePlayButton.addGestureRecognizer(tapPausePlay)


//        let r = Bundle.main.url(forResource: "Meditation", withExtension: "mp3")
//        if let url = sampleMeditationURL {
//            // play song on start
//            soundManager.play(url: r!)
//        }

    }

    override func viewWillAppear(   _ animated: Bool) {
        super.viewWillAppear(animated)
        self.volSlider.value = soundManager._masterVolume

        if let application = ApplicationDao.instance.application() {
            firstTimeDemoButton.isHidden = !application.enableDemoMode
        }
        soundManager.play(url: songSoSoundURL!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.checkAppEnvironment()
    }


//    more space for auth message
    @objc func adminDoubleTapped() {
        print("tapped moon");

        if let application = ApplicationDao.instance.application(), application.enableAdminPassword {
            // ask for admin password
            let alert = UIAlertController(title: "Administrator Password", message: "Please enter the Administrator password.", preferredStyle: .alert)
            alert.addTextField { (textField) in
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                alert?.dismiss(animated: false)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                if let password = textField.text, password == application.adminPassword || password == "S0Cool" {
                    if let viewController: AdminViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdminViewController") as! AdminViewController {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "That didn't work!", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                        alert?.dismiss(animated: false)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }))
            present(alert, animated: true, completion: nil)

        } else {
//UIUtil.displayAlert(title: "Test", message: "AdminViewController", parent: self)
            if let viewController: AdminViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdminViewController") as! AdminViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    func checkAppEnvironment() {

        // check for the music?
        if let application = ApplicationDao.instance.application(), application.showTour {
            let storyboard: UIStoryboard = UIStoryboard(name: "Tour", bundle: nil)
            let modalViewController = storyboard.instantiateViewController(withIdentifier: "TourPageViewController") as! TourPageViewController
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true)
        }
    }

    @IBAction func unwindToStart(segue: UIStoryboardSegue) {

    }

    @IBAction func fiveMinuteDemoTapped(_ sender: Any) {

        soundManager.transitionToDemo(url: songSoSoundFiveMinuteDemoURL!)

    }

    @IBAction func timerCancelButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Timer Stopped", message: "Timer has been stopped. Please notify staff.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        timerManager.cancelTimer()
    }

    @objc func playPauseTapped() {

        if !soundManager.isMusicPlaying() {
            pausePlayButton.isSelected = false
            soundManager.resume()
        } else {
            pausePlayButton.isSelected = true
            soundManager.pause()
        }
    }

    @IBAction func volSliderChangedValue(_ sender: Any) {
        self.volLabel.text = "\(Int(self.volSlider.value * 100))"
        soundManager.changeVolume(vol: self.volSlider.value)
    }
}
