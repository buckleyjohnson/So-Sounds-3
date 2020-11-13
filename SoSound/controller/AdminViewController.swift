//
//  AdminViewController.swift
//  SoSound
//
//  Created by Dave Brown on 8/13/18.
//

import QuartzCore
import UIKit
import MediaPlayer
import Foundation
import MessageUI


enum AuthResultStatus: Int {
    case SUCCESS = 1
    case FAILED = 0
}

struct AuthResult: Decodable {
    let status: Int
    let data: Int
    let status_message: String
}

// Needs to be a class to add extension for selected
class SongAsset: Codable {

    init(name: String, songURL: String, durationSeconds: Int32) {
        self.name = name
        self.songURL = songURL
        self.durationSeconds = durationSeconds
    }

    var name: String
    var songURL: String
    var durationSeconds: Int32
}

class AlbumAsset: Codable {

    init(sku: String, imageURL: String, name: String, songList: [SongAsset]) {
        self.sku = sku
        self.imageURL = imageURL
        self.name = name
        self.songList = songList
    }

    var imageURL: String
    var name: String
    var sku: String
    var songList: [SongAsset]
}
struct MusicResult: Decodable {
    let status: Int
    let status_message: String
    let data: [AlbumAsset]
}

public protocol EditMusicDoneDelegate {

    func editingMusicDone()
}


class AdminViewController: UIViewController, MusicDownloadDelegate, MPMediaPickerControllerDelegate, SettingTappedDelegate, UITableViewDelegate, UITableViewDataSource, EditMusicDoneDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var serverConfigView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var musicStatusLabel: UILabel!
    @IBOutlet weak var musicStatusView: UIView!
    @IBOutlet weak var musicDownloadStatusLabel: UILabel!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var musicDownloadDescriptionLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!

    var mailComposer: MFMailComposeViewController!
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var downloadView: MusicDownloadView!
    var downloadStep: Int = 0
    var musicList = [MusicTile]()


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 22.00 / 255, green: 29.0 / 255, blue: 37.0 / 255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray

        self.musicTableView.allowsSelection = false
        self.musicTableView.backgroundColor = UIColor(red: 22.00 / 255, green: 29.0 / 255, blue: 37.0 / 255, alpha: 1)
        self.musicTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.musicTableView.layer.cornerRadius = 15
        self.musicTableView.layer.borderWidth = 1

        musicList = MusicTileDao.instance.allMusic()
        musicTableView.delegate = self
        musicTableView.dataSource = self

        soundManager.pause()
    }

    func checkServerConfig() -> Bool {

        var result = true
        if let application = ApplicationDao.instance.application(), application.wordpressUsername == nil || application.wordpressPassword == nil {
            if let serverConfigController: ServerConfigController = self.storyboard?.instantiateViewController(withIdentifier: "ServerConfigController") as! ServerConfigController {
                serverConfigController.modalPresentationStyle = UIModalPresentationStyle.formSheet
                self.present(serverConfigController, animated: true)
                result = false
            }
        }
        return result
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        reload data
//        self.serverConfigView.layer.borderColor = UIColor.lightGray.cgColor
//        self.musicStatusView.layer.borderColor = UIColor.lightGray.cgColor
//        self.downloadView = MusicDownloadView(frame: CGRect.zero)

        // do we have the files?
        // if (MusicManager().verifyDownloadFiles()) {
        //     // hide it if music is good
        //     self.musicStatusView.isHidden = true
        //     musicTableView.isHidden = false
        // } else {
        //     self.musicStatusView.isHidden = false
        //     musicTableView.isHidden = true
        //     self.musicDownloadStatusLabel.text = "No music has been downloaded.\n\nPress the Download Music button to download your So Sound music.";
        // }

//        let fm = FileManager.default
//        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//            let items = try fm.contentsOfDirectory(atPath: documentsDirectoryURL.path)
//
//            for item in items {
//                log("Found \(item)")
//            }
//        } catch {
//            // failed to read directory – bad permissions, perhaps?
//        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let frame = self.view.frame

        let tableWidth = frame.width * 0.80
        let tableHeight = frame.height - 20 - self.musicTableView.frame.minY
        self.musicTableView.frame = CGRect(x: (frame.width - tableWidth) / 2, y: self.musicTableView.frame.minY, width: tableWidth, height: tableHeight)
        musicDownloadDescriptionLabel.frame = CGRect(x: self.musicTableView.frame.minX, y: musicDownloadDescriptionLabel.frame.minY, width: tableWidth, height: musicDownloadDescriptionLabel.frame.height)
    }

    @IBAction func editMusicRowTapped(_ sender: Any) {

        if checkServerConfig() {

            var editButtonView: UIButton = sender as! UIButton
            if let musicDownloadController: EditMusicViewController = self.storyboard?.instantiateViewController(withIdentifier: "MusicDownloadViewController") as! EditMusicViewController {
                musicDownloadController.initialize(music: musicList[editButtonView.tag - 1], doneDelegate: self)
                self.presentNavigationControllerWithRootViewController(rootViewController: musicDownloadController)
            }
        }
    }

    @IBAction func downloadMusicTapped(_ sender: Any) {

        // Create the action buttons for the alert.
        let defaultAction = UIAlertAction(title: "Download", style: .default) { (action) in

            self.view.addSubview(self.downloadView)
            self.downloadView.frame = CGRect(x: self.view.frame.width / 4, y: self.view.frame.height / 4, width: self.view.frame.width / 2, height: self.view.frame.height / 2)
            DispatchQueue.main.async {
                // execute async on main thread
                log("Starting music download process")
                // MusicManager().downloadMusic(downloadDelegate: self)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Respond to user selection of the action.
        }
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Music Download", message: "You are about to start the music download process. This will take an extended amount of time.\n\nAre you sure?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func settingsTapped(_ sender: Any) {


        if let settingsViewController: SettingsPopoverController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsPopoverController") as! SettingsPopoverController {
            settingsViewController.modalPresentationStyle = .popover
            settingsViewController.delegate = self
            var popover = settingsViewController.popoverPresentationController
            popover?.sourceView = sender as! UIView

//            if let popover = settingsViewController.popoverPresentationController {
//
//                let viewForSource = sender as! UIView
//                popover.sourceView = viewForSource
//                // the position of the popover where it's showed
//                popover.sourceRect = viewForSource.bounds
//                // the size you want to display
////                vc.preferredContentSize = CGSizeMake(200,500)
////                popover.delegate = self
//            }
            self.present(settingsViewController, animated: true, completion: nil)
        }
    }

    @IBAction func pickMusicTapped(_ sender: Any) {

//        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer()
//        // Add a playback queue containing all songs on the device
//        myMediaPlayer.setQueue(with: MPMediaQuery.songs())
//        // Start playing from the beginning of the queue
//        myMediaPlayer.play()
        let myMediaPickerVC = MPMediaPickerController(mediaTypes: MPMediaType.music)
        myMediaPickerVC.allowsPickingMultipleItems = true
//        myMediaPickerVC.popoverPresentationController?.sourceView = self.view
        myMediaPickerVC.delegate = self
        self.present(myMediaPickerVC, animated: true, completion: nil)
    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {

        if #available(iOS 10.3, *) {
            let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
//            let pickedSongData: Data = UserDefaults.standard.object(forKey: "picked_song") as! Data

//            if let pickedSong = NSKeyedUnarchiver.unarchiveObject(with: pickedSongData) as? MPMediaItemCollection {
//                myMediaPlayer.setQueue(with: pickedSong)
////            mediaPicker.dismiss(animated: true, completion: nil)
//                myMediaPlayer.play()
//
////            // Add a playback queue containing all songs on the device
////            myMediaPlayer.setQueue(with: MPMediaQuery.songs())
////            // Start playing from the beginning of the queue
////            myMediaPlayer.play()
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: mediaItemCollection)
            UserDefaults.standard.set(data, forKey: "picked_song")
            mediaPicker.dismiss(animated: true, completion: nil)

//            }

        } else {
            // Fallback on earlier versions
        }
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }

    func downloadComplete(error: Bool) {

        if (!error) {
            self.musicDownloadStatusLabel.text = "Music download complete.";
        } else {
            self.musicDownloadStatusLabel.text = "There was a problem with your music download.";
        }
        self.downloadView.removeFromSuperview()
    }

    func downloadProgress(progressText: String) {

        DispatchQueue.main.async {
            //Update your UI here
            self.downloadView.downloadLabel.text = progressText
        }
    }

    func settingsTapped(sender: UIBarButtonItem) {
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MusicRowTableCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicRowTableCell else {
            fatalError("The dequeued cell is not an instance of MusicRowTableCell.")
        }

        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 30.0 / 255, green: 37.0 / 255, blue: 46.0 / 255, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 39.0 / 255, green: 46.0 / 255, blue: 54.0 / 255, alpha: 1.0)
        }
        print("musiclistcount=", musicList.count);
        print("thisIndex == ", indexPath.row);
        if musicList.count > 0, let music: MusicTile = musicList[indexPath.row] {
            cell.songPosition.text = String(music.position)

            if music.localImageFile != nil {
                cell.songArtwork.image = UIImage(contentsOfFile: ImageUtil.tileImagePathForImage(tileImageName: music.localImageFile!))
            } else {
                cell.songArtwork.image = UIImage(named: music.imageAssetName!)
            }
            cell.songName.text = music.name
            cell.editButton.tag = Int(music.position)

            var duration: Int32 = 0;
            if let songs = music.songs {
                for s in songs {
                    let song: Song = s as! Song
                    duration += song.duration
                }
            }
            cell.songDuration.text = UIUtil.getFormattedMusicTime(durationInSeconds: duration)
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "ToSettingsSeque"?:
            if #available(iOS 9.0, *) {
                segue.destination.popoverPresentationController?.sourceRect = settingsButton.bounds
            }
        default:
            break
        }
    }

    /*
     Settings delegate
     */
    func settingTapped(settingRow: Int) {


        if let _settingRow = ServerConfigTableRow.init(rawValue: settingRow) {
            switch (_settingRow) {

            case .ABOUT:
                var appVersion = "2.4"
                if let application = ApplicationDao.instance.application(), let version = application.version {
                    appVersion = version
                }
                let alert = UIAlertController(title: "SO Sounds Music", message:appVersion, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
                break

            case .SETTINGS:
                let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                settingsViewController.modalPresentationStyle = .overCurrentContext
                present(settingsViewController, animated: true)
                break

            case .SHOW_TOUR:
                let storyboard: UIStoryboard = UIStoryboard(name: "Tour", bundle: nil)
                let modalViewController = storyboard.instantiateViewController(withIdentifier: "TourPageViewController") as! TourPageViewController
                modalViewController.modalPresentationStyle = .overCurrentContext
                present(modalViewController, animated: true)
                break

            case .EXIT_APPLICATION:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                break

            case .SUPPORT:
                var logPath = Log.logger.currentPath
                if MFMailComposeViewController.canSendMail() {

                    mailComposer = MFMailComposeViewController()
                    mailComposer.mailComposeDelegate = self
                    mailComposer.setToRecipients(["dave@onthemovefitness.com"])
                    //Set the subject and message of the email
                    mailComposer.setSubject("SO Sounds Support")
                    mailComposer.setMessageBody("Please enter the details regarding the problem you're experiencing with the So Sounds App.", isHTML: false)

                    if let fileData = NSData(contentsOfFile: logPath) {
                        mailComposer.addAttachmentData(fileData as Data, mimeType: "text/plain", fileName: "sosounds.log")
                    }
                    self.present(mailComposer, animated: true)
                } else {
                    UIUtil.displayAlert(title: "Error", message: "It looks like no mail accounts are configured. Please configure a mail account to send your support log.", parent: self)
                }
                break
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        mailComposer.dismiss(animated: true)
    }

    func editingMusicDone() {
        self.musicTableView.reloadData()
    }

    func presentNavigationControllerWithRootViewController(rootViewController: UIViewController) -> UINavigationController {


        var navController: UINavigationController = UINavigationController(rootViewController: rootViewController)

        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor(red: 123 / 255, green: 64 / 255, blue: 132 / 255, alpha: 1)
        navController.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        navController.modalPresentationStyle = UIModalPresentationStyle.formSheet;
        present(navController, animated: true)
        return navController;
    }


// Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else {
            return nil
        }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in
            (NSAttributedString.Key(rawValue: key), value)
        })
    }
}
