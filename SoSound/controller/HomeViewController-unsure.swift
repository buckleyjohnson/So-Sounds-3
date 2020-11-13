//
//  HomeViewController.swift
//  SoSound
//
//  Created by David on 7/10/17.
//  Copyright © 2017 Reverie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var layoutView: UIView!
    @IBOutlet weak var presentImageView: UIImageView!
    @IBOutlet weak var focusedImageView: UIImageView!
    @IBOutlet weak var energizingImageView: UIImageView!
    @IBOutlet weak var resonantImageView: UIImageView!
    @IBOutlet weak var journeyImageView: UIImageView!
    @IBOutlet weak var meditationImageView: UIImageView!
    @IBOutlet weak var peacefulImageView: UIImageView!
    @IBOutlet weak var relaxingImageView: UIImageView!
    @IBOutlet weak var jazzImageView: UIImageView!
    var oldFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    let transitionTime = 17.0
    var isImageExpanded:Bool = false
    var imageView:UIImageView?
    var idleTimer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.removeSelf), name: NSNotification.Name(rawValue: kTimer), object: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ExperienceViewController.backTapped(sender:)))
        
        let presentTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.presentTapDetected))
        let focusedTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.focusedTapDetected))
        let energizingTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.energizingTapDetected))
        let resonantTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.resonantTapDetected))
        let journeyTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.journeyTapDetected))
        let meditationTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.meditationTapDetected))
        let peacefulTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.peacefulTapDetected))
        let relaxingTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.relaxingTapDetected))
        let jazzTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.jazzTapDetected))
        self.presentImageView.isUserInteractionEnabled = true
        self.focusedImageView.isUserInteractionEnabled = true
        self.energizingImageView.isUserInteractionEnabled = true
        self.resonantImageView.isUserInteractionEnabled = true
        self.journeyImageView.isUserInteractionEnabled = true
        self.meditationImageView.isUserInteractionEnabled = true
        self.peacefulImageView.isUserInteractionEnabled = true
        self.relaxingImageView.isUserInteractionEnabled = true
        self.jazzImageView.isUserInteractionEnabled = true
        
        self.presentImageView.addGestureRecognizer(presentTap)
        self.focusedImageView.addGestureRecognizer(focusedTap)
        self.energizingImageView.addGestureRecognizer(energizingTap)
        self.resonantImageView.addGestureRecognizer(resonantTap)
        self.journeyImageView.addGestureRecognizer(journeyTap)
        self.meditationImageView.addGestureRecognizer(meditationTap)
        self.peacefulImageView.addGestureRecognizer(peacefulTap)
        self.relaxingImageView.addGestureRecognizer(relaxingTap)
        self.jazzImageView.addGestureRecognizer(jazzTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isImageExpanded {
            layoutView.layoutIfNeeded()
            soundManager.transitionSong(url: kSoSoundURL!)
            UIView.animate(withDuration: transitionTime, animations: {
                self.imageView?.frame = self.oldFrame
            }) { (done) in
                self.isImageExpanded = false
                self.enableTouch()
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
        
        self.idleTimer?.invalidate()
        self.idleTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(HomeViewController.goLogo), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    func goLogo() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentTapDetected() {
        print("present tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.oldFrame = self.presentImageView.frame
        self.layoutView.bringSubview(toFront: self.presentImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kPresent1hrURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.presentImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Present")!)
            self.isImageExpanded = true
            self.imageView = self.presentImageView
//            self.presentImageView.frame = self.oldFrame //keeping for reference
        }
    }
    func focusedTapDetected() {
        print("focused tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.focusedImageView.frame
        self.layoutView.bringSubview(toFront: self.focusedImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kFocused1hrURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.focusedImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Focused")!)
            self.isImageExpanded = true
            self.imageView = self.focusedImageView
        }
    }
    func energizingTapDetected() {
        print("energizing tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.energizingImageView.frame
        self.layoutView.bringSubview(toFront: self.energizingImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kEnergizing1hrURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.energizingImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Energizing")!)
            self.isImageExpanded = true
            self.imageView = self.energizingImageView
        }
    }
    func resonantTapDetected() {
        print("resonant tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.resonantImageView.frame
        self.layoutView.bringSubview(toFront: self.resonantImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kResonantURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.resonantImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Resonant")!)
            self.isImageExpanded = true
            self.imageView = self.resonantImageView
        }
    }
    func journeyTapDetected() {
        print("journey tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.journeyImageView.frame
        self.layoutView.bringSubview(toFront: self.journeyImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kJourneyURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.journeyImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Journey")!)
            self.isImageExpanded = true
            self.imageView = self.journeyImageView
        }
    }
    func meditationTapDetected() {
        print("meditation tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.meditationImageView.frame
        self.layoutView.bringSubview(toFront: self.meditationImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kMeditationURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.meditationImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Meditation")!)
            self.isImageExpanded = true
            self.imageView = self.meditationImageView
        }
    }
    func peacefulTapDetected() {
        print("peaceful tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.peacefulImageView.frame
        self.layoutView.bringSubview(toFront: self.peacefulImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kPeacefulURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.peacefulImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Peaceful")!)
            self.isImageExpanded = true
            self.imageView = self.peacefulImageView
        }
    }
    func relaxingTapDetected() {
        print("relaxing tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.relaxingImageView.frame
        self.layoutView.bringSubview(toFront: self.relaxingImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kRelaxingURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.relaxingImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Relaxing")!)
            self.isImageExpanded = true
            self.imageView = self.relaxingImageView
        }
    }
    func jazzTapDetected() {
        print("jazz tap detected")
//        btleInterface.zeroG()
        let cs = ComfortSetting(name: "", headPositionValue: 20, footPositionValue: 90, lumbarPositionValue: 0, headMassageValue: 0, footMassageValue: 0, massageTimer: 0, massageMode: .None, emailAddress: "", isRoutineOnly: false)
        btleInterface.comfortSettingExecute(cs) { (time) in
            print("movement done")
        }
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.disableTouch()
        self.oldFrame = self.jazzImageView.frame
        self.layoutView.bringSubview(toFront: self.jazzImageView)
        layoutView.layoutIfNeeded()
        soundManager.transitionSong(url: kJazzURL)
        UIView.animate(withDuration: transitionTime, animations: {
            self.jazzImageView.frame = self.layoutView.bounds
        }) { (done) in
            self.segueToVC(image: UIImage(named: "Jazz")!)
            self.isImageExpanded = true
            self.imageView = self.jazzImageView
        }
    }
    
    // All tranrition stuff should be added here
    func segueToVC(image: UIImage) {
        self.performSegue(withIdentifier: "homeToExperienceSegue", sender: image)
        self.idleTimer?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ExperienceViewController
        let image = sender as! UIImage
        vc.image = image
    }
    
    func enableTouch() {
        self.presentImageView.isUserInteractionEnabled = true
        self.focusedImageView.isUserInteractionEnabled = true
        self.energizingImageView.isUserInteractionEnabled = true
        self.resonantImageView.isUserInteractionEnabled = true
        self.journeyImageView.isUserInteractionEnabled = true
        self.meditationImageView.isUserInteractionEnabled = true
        self.peacefulImageView.isUserInteractionEnabled = true
        self.relaxingImageView.isUserInteractionEnabled = true
        self.jazzImageView.isUserInteractionEnabled = true
    }
    func disableTouch() {
        self.presentImageView.isUserInteractionEnabled = false
        self.focusedImageView.isUserInteractionEnabled = false
        self.energizingImageView.isUserInteractionEnabled = false
        self.resonantImageView.isUserInteractionEnabled = false
        self.journeyImageView.isUserInteractionEnabled = false
        self.meditationImageView.isUserInteractionEnabled = false
        self.peacefulImageView.isUserInteractionEnabled = false
        self.relaxingImageView.isUserInteractionEnabled = false
        self.jazzImageView.isUserInteractionEnabled = false
    }
    
    func removeSelf() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
