//
//  TourDownloadViewController.swift
//  SoSound
//
//  Created by Dave Brown on 9/7/18.
//  Copyright © 2018 So Sound. All rights reserved.
//

import UIKit

class TourDownloadViewController: TourViewController, MusicDownloadDelegate {
    @IBOutlet weak var musicDownloadView: MusicDownloadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        musicDownloadView.backgroundColor = UIColor.black
        musicDownloadView.downloadLabel.textColor = UIColor.white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // add the base music
        MusicManager().addBaseMusicPack()
        let musicArray: [MusicTile] = MusicTileDao.instance.allMusic(excludeSamples: true)
        MusicManager().downloadMusic(musicToDownload: musicArray, musicStep: 0, songStep: 0, downloadDelegate: self)
    }

    func downloadComplete(error: Bool) {

        var pageViewController: UIPageViewController = self.parent as! UIPageViewController
        pageViewController.goToNextPage()
    }

    func downloadProgress(progressText: String) {
        self.musicDownloadView.downloadLabel.text = progressText
    }
}
