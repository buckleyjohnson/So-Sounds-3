//
//  HomeViewController.swift
//  SoSound
//
//  Created by Dave Brown
// Tile numbers Left -> Right

import UIKit
import MediaPlayer


class HomeViewController: UIViewController, SoundManagerDelegate, VolumeChangedDelegate {
    
    @IBOutlet var presentImageView: UIImageView!
    @IBOutlet var focusedImageView: UIImageView!
    @IBOutlet var journeyImageView: UIImageView!
    @IBOutlet var meditationImageView: UIImageView!
    @IBOutlet var jazzImageView: UIImageView!
    @IBOutlet var relaxingImageView: UIImageView!
    @IBOutlet var layoutView: UIView!
    @IBOutlet var energyImageView: UIImageView!
    @IBOutlet var resonantImageView: UIImageView!
    @IBOutlet var peacefulImageView: UIImageView!
    
  
 
    
  
   
   
   

    var oldFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    let transitionTime = 4.0
    var isImageExpanded: Bool = false
    var imageView: UIImageView?
    var idleTimer: Timer?
    var experienceVolume: Float?

    var animating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.removeSelf), name: NSNotification.Name(rawValue: kTimer), object: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(HomeViewController.backTapped(sender:)))

        view.autoresizesSubviews = false
        focusedImageView = UIImageView(image: UIImage(named: "Focused"));
        view.addSubview(focusedImageView)

        let tile1Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        focusedImageView.isUserInteractionEnabled = true
        focusedImageView.tag = 1
        focusedImageView.addGestureRecognizer(tile1Tap)
        focusedImageView.image = imageForTileAtPosition(position: 1)
        focusedImageView.contentMode = .scaleToFill

        jazzImageView = UIImageView(image: UIImage(named: "Jazz"));
        view.addSubview(jazzImageView)
        let tile2Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        jazzImageView.isUserInteractionEnabled = true
        jazzImageView.tag = 2
        jazzImageView.addGestureRecognizer(tile2Tap)
        jazzImageView.image = imageForTileAtPosition(position: 2)
        jazzImageView.contentMode = .scaleToFill

        journeyImageView = UIImageView(image: UIImage(named: "Journey"));
        view.addSubview(journeyImageView)
        let tile3Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        journeyImageView.isUserInteractionEnabled = true
        journeyImageView.tag = 3
        journeyImageView.addGestureRecognizer(tile3Tap)
        journeyImageView.image = imageForTileAtPosition(position: 3)
        journeyImageView.contentMode = .scaleToFill

        energyImageView = UIImageView(image: UIImage(named: "Energy"));
        view.addSubview(energyImageView)

        let tile4Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        energyImageView.isUserInteractionEnabled = true
        energyImageView.tag = 4
        energyImageView.addGestureRecognizer(tile4Tap)
        energyImageView.image = imageForTileAtPosition(position: 4)
        energyImageView.contentMode = .scaleToFill

        meditationImageView = UIImageView(image: UIImage(named: "Meditation"));
        view.addSubview(meditationImageView)

        let tile5Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        meditationImageView.isUserInteractionEnabled = true
        meditationImageView.tag = 5
        meditationImageView.addGestureRecognizer(tile5Tap)
        meditationImageView.image = imageForTileAtPosition(position: 5)
        meditationImageView.contentMode = .scaleToFill


        // meditationImageView.contentMode = .scaleToFill

        peacefulImageView = UIImageView(image: UIImage(named: "Peaceful"));
        view.addSubview(peacefulImageView)
        let tile6Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        peacefulImageView.isUserInteractionEnabled = true
        peacefulImageView.tag = 6
        peacefulImageView.addGestureRecognizer(tile6Tap)
        peacefulImageView.image = imageForTileAtPosition(position: 6)
        peacefulImageView.contentMode = .scaleToFill

        presentImageView = UIImageView(image: UIImage(named: "Present"));
        view.addSubview(presentImageView)
        let tile7Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        presentImageView.isUserInteractionEnabled = true
        presentImageView.tag = 7
        presentImageView.addGestureRecognizer(tile7Tap)
        presentImageView.image = imageForTileAtPosition(position: 7)
        presentImageView.contentMode = .scaleToFill

        relaxingImageView = UIImageView(image: UIImage(named: "Relaxing"));
        view.addSubview(relaxingImageView)
        let tile8Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        relaxingImageView.isUserInteractionEnabled = true
        relaxingImageView.tag = 8
        relaxingImageView.addGestureRecognizer(tile8Tap)
        relaxingImageView.image = imageForTileAtPosition(position: 8)
        relaxingImageView.contentMode = .scaleToFill

        resonantImageView = UIImageView(image: UIImage(named: "Resonant"));
        view.addSubview(resonantImageView)
        let tile9Tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tileTapDetected))
        resonantImageView.isUserInteractionEnabled = true
        resonantImageView.tag = 9
        resonantImageView.addGestureRecognizer(tile9Tap)
        resonantImageView.image = imageForTileAtPosition(position: 9)
        resonantImageView.contentMode = .scaleToFill

    }

    override func viewWillLayoutSubviews() {

        if animating {
            return
        }
        super.viewWillLayoutSubviews()

        var navBarHeight: CGFloat = 49.0
        // Odd to have to do this. I got a crash with it null
        if let navController = navigationController {
            navBarHeight = navController.navigationBar.frame.height
        }

        var width = view.frame.width / 3
        var height = (view.frame.height - navBarHeight - UIApplication.shared.statusBarFrame.height) / 3
        var x: CGFloat = 0.0
        var y = navBarHeight + UIApplication.shared.statusBarFrame.height
        focusedImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        x += width
        jazzImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        x += width
        journeyImageView.frame = CGRect(x: x, y: y, width: width, height: height)

        x = 0
        y += height
        energyImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        x += width
        meditationImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        x += width
        peacefulImageView.frame = CGRect(x: x, y: y, width: width, height: height)

        x = 0
        y += height
        presentImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        x += width
        relaxingImageView.frame = CGRect(x: x, y: y, width: width, height: height)
        x += width
        resonantImageView.frame = CGRect(x: x, y: y, width: width, height: height)
    }

    func imageForTileAtPosition(position: Int16) -> UIImage? {

        var tileImage: UIImage?

        if let music = MusicTileDao.instance.musicForPosition(position: position) {
            if music.localImageFile != nil {
                tileImage = UIImage(contentsOfFile: ImageUtil.tileImagePathForImage(tileImageName: music.localImageFile!))
            } else {
                tileImage = UIImage(named: music.imageAssetName!)
            }
        }
        return tileImage
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.isImageExpanded {
            animating = true
            print("viewdidAppear transition to song")
            if soundManager.transitionSong(url: songSoSoundURL!, delegate: self) {
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                UIView.animate(withDuration: transitionTime, animations: {
                    self.imageView?.frame = self.oldFrame
                }) { (done) in
                    self.animating = false
                    self.isImageExpanded = false
                    self.enableTouch()
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                }
            }
        }
        self.idleTimer?.invalidate()
//        self.idleTimer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(HomeViewController.goLogo), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func backTapped(sender: UIBarButtonItem) {

        self.navigationController?.popViewController(animated: false)
    }

    @objc func goLogo() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func tileTapDetected(_ sender: UITapGestureRecognizer) {

        let imageView: UIImageView = sender.view! as! UIImageView
        let position: Int16 = Int16(sender.view!.tag)
        let music: MusicTile = MusicTileDao.instance.musicForPosition(position: position)

        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.oldFrame = imageView.frame

        imageView.image = imageForTileAtPosition(position: position)

        var playResult = false
        // weirdness in relationship if no songs
        if let songs = music.songs, songs.count > 0 {

            let song: Song = songs.firstObject as! Song
            disableTouch()
            if (soundManager.playMusic(music: music, delegate: self)) {
                UIView.animate(withDuration: transitionTime, animations: {
                    print("animate with Duration...", self.transitionTime);
                    self.view.bringSubviewToFront(sender.view!)
//
                    sender.view!.frame = self.view.bounds
                    var width = self.view.frame.width
                    var height = self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height
                    var y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
                    sender.view!.frame = CGRect(x: 0, y: y, width: width, height: height)

                    self.animating = true

                }) { (done) in
                    print("done")
                    self.animating = false
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let controller: ExperienceViewController = storyboard.instantiateViewController(withIdentifier: "ExperienceViewController") as! ExperienceViewController {
                        print("push Experience....VC")
                        controller.image = self.imageForTileAtPosition(position: position)!
                        controller.experienceVolume = soundManager._masterVolume
                        self.animating = false
                        self.navigationController?.pushViewController(controller, animated: false)
                        self.isImageExpanded = true
                        self.imageView = imageView
                    } else {
                        self.displayMissingSongError(song: song.name!)
                        self.navigationItem.leftBarButtonItem?.isEnabled = true
                    }
                }
            } else {print("didn't play music");
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                enableTouch()
                self.displayMissingSongError(song: song.name!)
            }
        }
    }

    func musicFinished(error: Bool) {print("musicFinished");

        UIView.animate(withDuration: 0.5, animations: {
        }) {
            (done) in
            self.navigationController?.popViewController(animated: false)
        }
    }

    // All transition stuff should be added here
    func segueToVC(image: UIImage) {
        self.performSegue(withIdentifier: "homeToExperienceSegue", sender: image)
        self.idleTimer?.invalidate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ExperienceViewController
        let image = sender as! UIImage
        vc.image = image
        vc.volumeDelegate = self
        vc.experienceVolume = self.experienceVolume
    }


    func enableTouch() {
        focusedImageView.isUserInteractionEnabled = true
        jazzImageView.isUserInteractionEnabled = true
        journeyImageView.isUserInteractionEnabled = true
        energyImageView.isUserInteractionEnabled = true
        meditationImageView.isUserInteractionEnabled = true
        peacefulImageView.isUserInteractionEnabled = true
        presentImageView.isUserInteractionEnabled = true
        relaxingImageView.isUserInteractionEnabled = true
        resonantImageView.isUserInteractionEnabled = true
    }

    func disableTouch() {
        focusedImageView.isUserInteractionEnabled = false
        jazzImageView.isUserInteractionEnabled = false
        journeyImageView.isUserInteractionEnabled = false
        energyImageView.isUserInteractionEnabled = false
        meditationImageView.isUserInteractionEnabled = false
        peacefulImageView.isUserInteractionEnabled = false
        presentImageView.isUserInteractionEnabled = false
        relaxingImageView.isUserInteractionEnabled = false
        resonantImageView.isUserInteractionEnabled = false
    }

    @objc func removeSelf() {
        self.navigationController?.popToRootViewController(animated: true)
    }


    func displayMissingSongError(song: String) {

        let alert = UIAlertController(title: "Missing Song", message: "SO Sounds was unable to load the song " + song + ". Please go to the Admin Panel by double tapping the moon on the Home screen to ensure your music is downloaded.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func setVolume(volume: Float) {
        self.experienceVolume = volume
    }

    func musicPlayStatus(song: Song, songPlayTime: Int32) {

    }
}
