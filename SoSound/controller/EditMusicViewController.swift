//
//  AdminViewController.swift
//  SoSound
//
//  Create  d by Dave Brown on 8/13/18.
//

import QuartzCore
import UIKit
import MediaPlayer
import Foundation
import MessageUI
import AVFoundation
import Photos

struct SelectedSongs {
    var songAsset: SongAsset
    var selected: Bool
}

class EditMusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var musicPlayTimeLabel: UILabel!
    @IBOutlet weak var tileName: UITextField!

    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var downloadView: MusicDownloadView!
    var downloadStep: Int = 0
    var musicList = [AlbumAsset]()
    var musicBeingEdited: MusicTile!
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var timeObserverToken: Any?
    var musicPlayTime: Int32 = 0
    var defaultMusic: DefaultMusic!
    var doneDelegate: EditMusicDoneDelegate!
    var newTileImage: UIImage?
    var newTileImageName: String?
    var downloadablMusicStatusController: GettingDownloadableMusicController!
    @IBOutlet weak var tileImagePreview: UIImageView!
    func initialize(music: MusicTile, doneDelegate: EditMusicDoneDelegate) {

        musicBeingEdited = music
        self.doneDelegate = doneDelegate
        defaultMusic = DefaultMusicDao.instance.defaultMusicForPosition(tilePosition: music.position)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        musicTableView.delegate = self
        musicTableView.dataSource = self
        musicTableView.allowsSelection = true

        navigationItem.title = "Editing Tile " + musicBeingEdited.name!
        preferredContentSize = CGSize(width: 850, height: 600)
        tileName.text = musicBeingEdited.name!

        if let songs = musicBeingEdited.songs {
            for _s in songs {
                var s: Song = _s as! Song
                musicPlayTime += s.duration
            }
        }

        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTapped))
        let nextButton: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton

        if let imageFile = musicBeingEdited.localImageFile {
            tileImagePreview.image = UIImage(contentsOfFile: ImageUtil.tileImagePathForImage(tileImageName: musicBeingEdited.localImageFile!))
        } else {
            tileImagePreview.image = UIImage(named: musicBeingEdited.imageAssetName!)
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditMusicViewController.changeTileImageTapped))
        tileImagePreview.addGestureRecognizer(tapRecognizer)
        tileImagePreview.isUserInteractionEnabled = true

        if let controller: GettingDownloadableMusicController = storyboard?.instantiateViewController(withIdentifier: "GettingDownloadableMusicController") as! GettingDownloadableMusicController {
            downloadablMusicStatusController = controller
            downloadablMusicStatusController.modalPresentationStyle = UIModalPresentationStyle.formSheet
            present(downloadablMusicStatusController, animated: true)
        }

        musicPlayTimeLabel.text = UIUtil.getFormattedMusicPlayTime(durationInSeconds: musicPlayTime)
        getAvailableMusic();

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }

    @objc func cancelTapped() {

        // remove any changes
        MusicTileDao.instance.context().rollback()
        stopMusic()
        dismiss(animated: true)
    }

    @objc func nextTapped() {

        stopMusic()
        var selectedSongs = [SongAsset]()

        for music in musicList {
            for song in music.songList {
                log("Song: " + song.name + " Selected " + String(song.selected ? "1" : "0"))
                if song.selected {
                    selectedSongs.append(song)
                }
            }
        }
        if let organizeMusicViewController: OrganizeMusicViewController = storyboard?.instantiateViewController(withIdentifier: "OrganizeMusicViewController") as! OrganizeMusicViewController {
            organizeMusicViewController.initialize(music: musicBeingEdited, selectedSongs: selectedSongs, tileName: tileName.text!, newTileImage: newTileImage, doneDelegate: doneDelegate)
            navigationController?.pushViewController(organizeMusicViewController, animated: true)
        }
    }

    /*
    Music Table View Stuff
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return musicList[section].songList.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return musicList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MusicDownloadRowTableCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicDownloadRowTableCell else {
            fatalError("The dequeued cell is not an instance of MusicDownloadRowTableCell.")
        }
        cell.selectionStyle = .none

        var songAsset: SongAsset = musicList[indexPath.section].songList[indexPath.row]
        cell.songName.text = songAsset.name
        cell.trackNumber.text = String(indexPath.row + 1)
        cell.songDuration.text = UIUtil.getFormattedMusicTime(durationInSeconds: songAsset.durationSeconds)
        cell.playButton.songAsset = songAsset
        cell.playButton.isDefault = true
        cell.songSelectedImageView.image = UIImage(named: (songAsset.selected ? "Checked" : "Unchecked"))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell: MusicDownloadRowTableCell = tableView.cellForRow(at: indexPath) as! MusicDownloadRowTableCell
        var selected: Bool = false
        var song: SongAsset = musicList[indexPath.section].songList[indexPath.row]
        song.selected = song.selected ? false : true
        selected = song.selected

        if (song.selected) {
            musicPlayTime += song.durationSeconds
        } else {
            musicPlayTime -= song.durationSeconds
        }
        // }
        musicPlayTimeLabel.text = UIUtil.getFormattedMusicPlayTime(durationInSeconds: musicPlayTime)
        cell.songSelectedImageView.image = UIImage(named: (selected ? "Checked" : "Unchecked"))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var headerView: MusicHeaderView = Bundle.main.loadNibNamed("MusicHeaderView", owner: nil)![0] as! MusicHeaderView

        if defaultMusic != nil, section == 0 {
            if let defaultMusic: DefaultMusic = DefaultMusicDao.instance.defaultMusicForPosition(tilePosition: musicBeingEdited.position) {
                headerView.musicImageView.image = UIImage(named: defaultMusic.imageAssetName!)
                headerView.musicTitle.text = defaultMusic.name! + " (default)"
            }
        } else {
            if let music: AlbumAsset = musicList[section] {
                if let data = try? Data(contentsOf: URL(string: music.imageURL)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            // l(music.imageURL)
                            headerView.musicImageView.image = image
                        }
                    }
                }
                headerView.musicTitle.text = music.name
            }
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    // Is this the same song?
    func isSongSelected(songAsset: SongAsset) {

        if let songs = musicBeingEdited.songs {
            for _song in songs {
                let song: Song = _song as! Song
                if song.name == songAsset.name && song.duration == songAsset.durationSeconds {
                    songAsset.selected = true
                    break
                }
            }
        }
    }

    func getAvailableMusic() {

        // spinnerView.startAnimating()
        // check fields

        // check for server setup
        if let application: Application = ApplicationDao.instance.application() {

            if (application.wordpressUsername == nil || application.wordpressPassword == nil) {
                let alert = UIAlertController(title: "SO Sounds Music", message: "To edit Music you must configure the server settings.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alert, animated: true, completion: nil)
                return
            }

            let url: String = "http://staging.sosoundsolutions.com/wp-content/plugins/so-sound/restapi/api.php?request=music&action=list&username=" + application.wordpressUsername! + "&password=" + application.wordpressPassword!
            let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in

                if let _error = error {
                    log("Error authenticating user. Error: " + _error.localizedDescription)
                    // updateStatusLabel(text: "Error connecting to server.")
                } else {
                    guard let dataResponse = data, error == nil else {
                        log("Error encountered authenticating user")
                        // updateStatusLabel(text: "Error encountered authenticating user")
                        return
                    }
                    do {
                        let musicResponse: MusicResult = try JSONDecoder().decode(MusicResult.self, from: dataResponse);
                        if musicResponse.status == 200 {

                            self.musicList = musicResponse.data

                            if let defaultMusic = self.defaultMusic {
                                // Ok we're good. Make a music entry for the default
                                let song: SongAsset = SongAsset(name: defaultMusic.name!, songURL: defaultMusic.sourceURL!, durationSeconds: defaultMusic.duration)
                                let defaultMusicSelection: AlbumAsset = AlbumAsset(sku: "default", imageURL: defaultMusic.imageAssetName!, name: defaultMusic.name!, songList: [song])
                                self.musicList.insert(defaultMusicSelection, at: 0)
                            } else {

                            }

                            // go through songs selected
                            for music in self.musicList {
                                for songAsset in music.songList {
                                    songAsset.productSku = music.sku
                                    self.isSongSelected(songAsset: songAsset)
                                }
                            }
                            DispatchQueue.main.async {
                                self.downloadablMusicStatusController.dismiss(animated: true)
                                self.musicTableView.reloadData()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.downloadablMusicStatusController.dismiss(animated: true, completion: {
                                    let alert = UIAlertController(title: "Authentication Failed", message: "Unable to login to server. Please verify your login information.", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) in
                                        self.dismiss(animated: true)

                                    })
                                    self.present(alert, animated: true, completion: nil)
                                }
                                )
                            }
                        }

                    } catch let error {
                        log("Error downloading music. Error: " + error.localizedDescription)
                    }
                }
            })
            task.resume()
        } else {
            let alert = UIAlertController(title: "SO Sounds Music", message: "Error loading application data.", preferredStyle: UIAlertController.Style.alert)
        }
    }

    @objc func changeTileImageTapped(_ sender: UITapGestureRecognizer) {


        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true, completion: nil)
                }
            })
        case .restricted:
            // same same
            UIUtil.displayAlert(title: "Photo Permission", message: "So Sounds does not have access to your Photos. Go to Settings -> Privacy -> Photos and give So Sounds access to your photos.", parent: self)

        case .denied:
            // same same
            UIUtil.displayAlert(title: "Photo Permission", message: "So Sounds does not have access to your Photos. Go to Settings -> Privacy -> Photos and give So Sounds access to your photos.", parent: self)
        }
    }


    @IBAction func playTapped(_ sender: Any) {

        var view: UIView = sender as! UIView
        var song: SongAsset = view.songAsset!

        var result = true
        log("playing \(song.songURL)")

        let songURL = URL(string: song.songURL)
        do {
            stopMusic()
            if player == nil {
                player = AVPlayer(playerItem: playerItem)
            }
            playerItem = AVPlayerItem(url: songURL!)
            player!.replaceCurrentItem(with: playerItem)

            timeObserverToken = player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay {

                    let time: Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    if time > 30.0 {
                        self.stopMusic()
                    }
                } else {

                }
            }
            player!.play()

        } catch let error as NSError {
            log("Error playing song - " + songURL!.absoluteString)
            result = false
        } catch {
            log("AVAudioPlayer init failed")
            result = false
        }

        if !result {
            let alert = UIAlertController(title: "Error playing Song", message: "SO Sounds was unable to load the song " + song.name + ".", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }

    func stopMusic() {

        player?.pause()
        if timeObserverToken != nil {
            player?.removeTimeObserver(timeObserverToken)
            timeObserverToken = nil
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {


        if let image: UIImage = info[.originalImage] as? UIImage {
            tileImagePreview.image = image
            newTileImage = image

            if let asset = info[.phAsset] as? PHAsset {
                if let filename = asset.value(forKey: "filename") as? String {
                    var lFilename = filename.lowercased()
                    if filename.lowercased().hasSuffix("png") {
                        musicBeingEdited.localImageFile = "tile_" + String(musicBeingEdited.position) + "_image.png"
                    } else {
                        musicBeingEdited.localImageFile = "tile_" + String(musicBeingEdited.position) + "_image.jpg"
                    }
                }
            }
        } else {
            print("Something went wrong in  image")
        }
        picker.dismiss(animated: true, completion: nil)
    }

}

extension AlbumAsset {
    struct MyAlbumAssetStuff {
        static var isDefault = "isDefault"
    }

    var selected: Bool {
        get {
            guard let isDefault = objc_getAssociatedObject(self, &MyAlbumAssetStuff.isDefault) as? Bool else {
                return false
            }
            return isDefault
        }
        set {
            objc_setAssociatedObject(self, &MyAlbumAssetStuff.isDefault, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}


extension SongAsset {
    struct MyStuff {
        static var selected = "selected"
        static var productSku = "productSku"
    }

    var selected: Bool {
        get {
            guard let isSelected = objc_getAssociatedObject(self, &MyStuff.selected) as? Bool else {
                return false
            }
            return isSelected
        }
        set {
            objc_setAssociatedObject(self, &MyStuff.selected, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    var productSku: String {
        get {
            guard let productSku = objc_getAssociatedObject(self, &MyStuff.productSku) as? String else {
                return ""
            }
            return productSku
        }
        set {
            objc_setAssociatedObject(self, &MyStuff.productSku, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIView {
    struct Static {
        static var songAsset = "SongAsset"
        // triggers using the asset for the image, kludgy, but nest I can think of
        static var isDefault = "isDefault"
    }

    var songAsset: SongAsset? {
        get {
            return objc_getAssociatedObject(self, &Static.songAsset) as! SongAsset
        }
        set {
            objc_setAssociatedObject(self, &Static.songAsset, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    var isDefault: Bool? {
        get {
            return objc_getAssociatedObject(self, &Static.isDefault) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &Static.isDefault, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

