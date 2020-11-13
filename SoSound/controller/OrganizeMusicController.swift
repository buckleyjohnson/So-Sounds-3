//
// Created by Dave Brown on 2018-11-04.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation

//
//  OrganizeMusicController.swift
//  SoSound
//
//  Created by Dave Brown on 8/13/18.
//

import QuartzCore
import UIKit
import MediaPlayer
import Foundation
import MessageUI
import AVFoundation

class OrganizeMusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!

    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var downloadView: MusicDownloadView!
    var downloadStep: Int = 0
    var music: MusicTile!
    var tileName : String?
    var selectedSongs = [SongAsset]()
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var timeObserverToken: Any?
    var musicPlayTime: Int32 = 0
    var doneDelegate : EditMusicDoneDelegate!
    var newTileImage : UIImage?

    @IBOutlet weak var musicPlayTimeLabel: UILabel!

    func initialize(music: MusicTile, selectedSongs: [SongAsset], tileName : String, newTileImage: UIImage?, doneDelegate : EditMusicDoneDelegate) {

        self.music = music
        self.selectedSongs = selectedSongs
        self.tileName = tileName
        self.doneDelegate = doneDelegate
        self.newTileImage = newTileImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        musicTableView.delegate = self
        musicTableView.dataSource = self
        musicTableView.isEditing = true

        var musicPlayTime: Int32 = 0
        for song in self.selectedSongs {
            musicPlayTime += song.durationSeconds
        }
        self.musicPlayTimeLabel.text = UIUtil.getFormattedMusicPlayTime(durationInSeconds: musicPlayTime)
        self.navigationItem.title = "Set music order"
        self.preferredContentSize = CGSize(width: 850, height: 600)

        let nextButton: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextButton
    }

    @objc func nextTapped() {

        if let viewController: EditMusicDownloadViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditMusicDownloadViewController") as! EditMusicDownloadViewController {
            viewController.initialize(music: music, selectedSongs : selectedSongs, tileName: self.tileName!, newTileImage: self.newTileImage, doneDelegate: self.doneDelegate)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    /*
    Music Table View Stuff
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedSongs.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "OrganizeMusicRowTableCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OrganizeMusicRowTableCell else {
            fatalError("The dequeued cell is not an instance of OrganizeMusicRowTableCell.")
        }

        cell.showsReorderControl = true

        if (indexPath.row % 2 == 0) {
            //     cell.backgroundColor = UIColor(red: 30.0 / 255, green: 37.0 / 255, blue: 46.0 / 255, alpha: 1.0)
            // } else {
            //     cell.backgroundColor = UIColor.lightGray//red: 39.0 / 255, green: 46.0 / 255, blue: 54.0 / 255, alpha: 1.0)
        }

        var song: SongAsset = selectedSongs[indexPath.row]
        cell.songName.text = song.name
        cell.songDuration.text = UIUtil.getFormattedMusicTime(durationInSeconds: song.durationSeconds)
        cell.playButton.songAsset = song
        return cell
    }


    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = selectedSongs[sourceIndexPath.row]
        selectedSongs.remove(at: sourceIndexPath.row)
        selectedSongs.insert(itemToMove, at: destinationIndexPath.row)
    }

    @IBAction func playTapped(_ sender: Any) {

        var view: UIView = sender as! UIView
        var song: SongAsset = view.songAsset!

        var result = true
//        log("playing \(song.songURL)")

        let songURL = URL(string: song.songURL)
        do {
            self.stopMusic()
            if self.player == nil {
                self.player = AVPlayer(playerItem: self.playerItem)
            }
            self.playerItem = AVPlayerItem(url: songURL!)
            self.player!.replaceCurrentItem(with: self.playerItem)

            self.timeObserverToken = self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay {

                    let time: Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    if time > 30.0 {
                        self.stopMusic()
                    }
                } else {

                }
            }
            self.player!.play()

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
            self.present(alert, animated: true, completion: nil)

        }
    }

    func stopMusic() {

        self.player?.pause()
        if self.timeObserverToken != nil {
            self.player?.removeTimeObserver(self.timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}
