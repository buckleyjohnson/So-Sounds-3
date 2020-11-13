//
//  ExperienceViewController.swift
//  SoSound
//
//  Created by David on 7/10/17.
//  Copyright © 2017 Reverie. All rights reserved.
//

import UIKit
import MediaPlayer

protocol VolumeChangedDelegate {
    func setVolume(volume: Float)
}

class ExperienceViewController: UIViewController, SoundManagerDelegate {

    var image: UIImage = UIImage(named: "Pause")!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    var idleView: UIView!
    var idleTimer: Timer!
    var experienceVolume: Float?
    var volumeDelegate: VolumeChangedDelegate?
    @IBOutlet var progressBar: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ExperienceViewController.removeSelf), name: NSNotification.Name(rawValue: kTimer), object: nil)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.black

        idleView = UIView(frame: view.frame)
        idleView.backgroundColor = UIColor.black
        idleView.alpha = 0.7
        imageView.image = image

        progressBar.progress = 0
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 6)
        progressBar.trackTintColor = .clear
        let idleTap = UITapGestureRecognizer(target: self, action: #selector(ExperienceViewController.removeIdleView))
        idleView.addGestureRecognizer(idleTap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ExperienceViewController.backTapped(sender:)))
        idleTimer = Timer.scheduledTimer(timeInterval: 1060, target: self, selector: #selector(ExperienceViewController.addIdleView), userInfo: nil, repeats: false)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var height = Int(view.frame.height-(navigationController?.navigationBar.frame.height)!-UIApplication.shared.statusBarFrame.height)
        var y = Int((navigationController?.navigationBar.frame.height)!+UIApplication.shared.statusBarFrame.height)
        imageView.frame = CGRect(x: 0, y: y, width: Int(view.frame.width), height: height)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Experince");
        soundManager._delegate = self
        self.imageView.image = self.image
        self.volumeLabel.alpha = 0
        self.volumeSlider.alpha = 0
        self.playButton.alpha = 0
        self.volumeSlider.setValue(experienceVolume!, animated: false)
        self.volumeLabel.text = String(format: "%d", Int(experienceVolume!*100))
        self.idleTimer.invalidate()
        let remainTime = idleTimer.fireDate.timeIntervalSinceNow
        print("remainTime: \(remainTime)")
        self.idleTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ExperienceViewController.addIdleView), userInfo: nil, repeats: false)

        UIView.animate(withDuration: 0.5) {
            self.volumeLabel.alpha = 100
            self.volumeSlider.alpha = 100
            self.playButton.alpha = 100
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc func backTapped(sender: UIBarButtonItem) {

        UIView.animate(withDuration: 0.5, animations: {
            self.volumeLabel.alpha = 0
            self.volumeSlider.alpha = 0
            self.playButton.alpha = 0
        }) { (done) in
            self.navigationController?.popViewController(animated: false)
        }
    }

    @IBAction func exitButtonPressed(_ sender: Any) {
        backTapped(sender: navigationItem.leftBarButtonItem!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func volumeSliderChanged(_ sender: Any) {

        volumeLabel.text = "\(Int(volumeSlider.value * 100))"
        soundManager.changeVolume(vol: volumeSlider.value)

        if let volDelegate = volumeDelegate {
            volumeDelegate?.setVolume(volume: volumeSlider.value)
        }
        idleTimer.invalidate()
        idleTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ExperienceViewController.addIdleView), userInfo: nil, repeats: false)
    }

    @IBAction func playButtonTapped(_ sender: Any) {

        idleTimer.invalidate()
        idleTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ExperienceViewController.addIdleView), userInfo: nil, repeats: false)
        if soundManager.isMusicPlaying() {
            soundManager.pauseWithFade()

            playButton.setImage(UIImage(named: "Play"), for: .normal)
        } else {
            soundManager.resumeWithFade()
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
        }
    }

    @objc func addIdleView() {
        idleView.alpha = 0
        view.addSubview(idleView)
        UIView.animate(withDuration: 10.0) {
            self.idleView.alpha = 0.7
        }
    }

    @objc func removeIdleView() {

        UIView.animate(withDuration: 3.0, animations: {
            self.idleView.alpha = 0
        }) { (done) in
            self.idleView.removeFromSuperview()
            self.idleTimer.invalidate()
            self.idleTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ExperienceViewController.addIdleView), userInfo: nil, repeats: false)
        }
    }

    @objc func removeSelf() {print("removeself")
        navigationController?.popToRootViewController(animated: true)

//        music????
    }

    func musicPlayStatus(song: Song, songPlayTime: Int32) {
        let ud = UserDefaults.standard
        var minutes = ud.integer(forKey: "Minutes")
        minutes = (60 * minutes) ;
        let min = UInt32(minutes)
        print("minutes ==== ", min)
        progressBar.progress = Float(songPlayTime) / Float(min)
        NSLog("Sound Man Progress %d/%d=%f", songPlayTime, min, progressBar.progress)
    }

    func musicFinished(error: Bool) {
        print("music has finished...")
        navigationController?.popViewController(animated: false)
    }

}
