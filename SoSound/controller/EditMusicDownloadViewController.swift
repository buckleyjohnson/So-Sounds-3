//
// Created by Dave Brown on 2018-11-08.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class EditMusicDownloadViewController: UIViewController, MusicDownloadDelegate {

    var musicForTile: MusicTile!
    var selectedSongs: [SongAsset]!
    var tileName: String?
    var newTileImage: UIImage?
    var doneDelegate: EditMusicDoneDelegate!
    var downloadTapped = false

    @IBOutlet weak var downloadTextLabel: UILabel!
    @IBOutlet weak var downloadStatusLabel: UILabel!
    @IBOutlet weak var downloadMusicButton: UIButton!

    func initialize(music: MusicTile, selectedSongs: [SongAsset], tileName: String, newTileImage: UIImage!, doneDelegate: EditMusicDoneDelegate) {
        self.musicForTile = music
        self.selectedSongs = selectedSongs
        self.tileName = tileName
        self.doneDelegate = doneDelegate
        self.newTileImage = newTileImage
        self.downloadTapped = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneButton

        if MusicManager().verifySongs(songs: selectedSongs, tilePosition: musicForTile.position) {
            navigationItem.rightBarButtonItem?.isEnabled = true
            downloadMusicButton.isHidden = true
            downloadTextLabel.text = "Your music is all setup."
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            downloadMusicButton.isHidden = false
        }
    }

    @objc func doneTapped() {

        musicForTile.name = self.tileName

        // if new tile image save it off
        if let tileImage = self.newTileImage {
            var imageData: Data? = tileImage.png

            if let _imageData = imageData {
                var imageFileURL = URL(fileURLWithPath: ImageUtil.tileImagePathForImage(tileImageName: self.musicForTile.localImageFile!))
                do {
                    var s = imageFileURL.absoluteString
                    try _imageData.write(to: imageFileURL)
                } catch let error as NSError {
                    self.musicForTile.localImageFile = nil
                    log("Error saving tile image")
                }
            }
        }
        do {
            if !downloadTapped {
                // copy the songs over here since
                MusicManager().copySongAssetsToMusic(music: musicForTile, songAssets: self.selectedSongs)
            }
            try MusicTileDao.context?.save()
        } catch {
        }

        // cleaanup old files
        self.doneDelegate.editingMusicDone()
        self.navigationController?.dismiss(animated: true)
    }


    @IBAction func downloadMusicTapped(_ sender: Any) {

        // make sure back and done are disabled
        downloadTapped = true
        navigationItem.hidesBackButton = true
        downloadMusicButton.isEnabled = false

        // not a sample any more
        if selectedSongs.count > 0 {
            musicForTile.sample = false
            MusicTileDao.instance.save()
        }

        DispatchQueue.main.async {
            // execute async on main thread
            log("Starting music download process")
            // copy the songs over
            MusicManager().copySongAssetsToMusic(music: self.musicForTile, songAssets: self.selectedSongs)
            let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            MusicManager().downloadMusic(musicToDownload: [self.musicForTile], musicStep: 0, songStep: 0, downloadDelegate: self)
        }
    }

    func downloadProgress(progressText: String) {

        DispatchQueue.main.async {
            //Update your UI here
            self.downloadStatusLabel.text = progressText
        }
    }

    func downloadComplete(error: Bool) {

        navigationItem.rightBarButtonItem?.isEnabled = true
        if (!error) {
            downloadMusicButton.isEnabled = true
            downloadStatusLabel.text = "Music download complete.";
        } else {
            MusicTileDao.context?.rollback()
            downloadStatusLabel.text = "There was a problem with your music download.";
        }
    }
}

extension UIImage {
    var png: Data? {
        return flattened.pngData()
    }

    var flattened: UIImage {
        var result: UIImage
        if imageOrientation == .up {
            result = self
        } else {
            result = UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
                draw(at: .zero)
            }
        }
        return result
    }
}