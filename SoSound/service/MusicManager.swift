//
// Created by Dave Brown on 8/19/18.
// Copyright (c) 2018 Reverie. All rights reserved.
//

import Foundation

var DEFAULT_PRODUCT_SKU = "default"

class MusicManager: NSObject, URLSessionDownloadDelegate {

    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var currentSong: Song!
    var downloadComplete = false
    var downloadDelegate: MusicDownloadDelegate!
    var musicStep = 0
    var songStep = 0
    var musicToDownload: [MusicTile]!
    var songCount = 0;

    override init() {
        super.init()
    }

    func initialize() {

        let musicDao = MusicTileDao.instance
        let musicList = musicDao.allMusic()
        if musicList.count == 0 {
            MusicManager.createSampleMusicRecord(name: "Present", filename: samplePresentURL!.lastPathComponent, songDuration: 3545, position: 1)
            MusicManager.createSampleMusicRecord(name: "Resonant", filename: sampleResonantURL!.lastPathComponent, songDuration: 3601, position: 8)
            MusicManager.createSampleMusicRecord(name: "Peaceful", filename: samplePeacefulURL!.lastPathComponent, songDuration: 3555, position: 3)
            MusicManager.createSampleMusicRecord(name: "Focused", filename: sampleFocusedURL!.lastPathComponent, songDuration: 3654, position: 4)
            MusicManager.createSampleMusicRecord(name: "Journey", filename: sampleJourneyURL!.lastPathComponent, songDuration: 3543, position: 2)
            MusicManager.createSampleMusicRecord(name: "Relaxing", filename: sampleRelaxingURL!.lastPathComponent, songDuration: 3533, position: 6)
            MusicManager.createSampleMusicRecord(name: "Energizing", filename: sampleEnergizingURL!.lastPathComponent, songDuration: 3602, position: 7)
            MusicManager.createSampleMusicRecord(name: "Meditation", filename: sampleMeditationURL!.lastPathComponent, songDuration: 3550, position: 5)
            MusicManager.createSampleMusicRecord(name: "Jazz", filename: sampleJazzURL!.lastPathComponent, songDuration: 3522, position: 9)
        }
        musicDao.save()
    }

    func addBaseMusicPack() {

        let musicDao = MusicTileDao.instance
        let defaultMusicDao = DefaultMusicDao.instance

        // no reason to get fancy, if people have purchased this pack they probably haven't configured the tiles
        musicDao.removeAllMusic()

        var music = MusicManager.createMusicRecord(name: "Present", songSourceURL: songPresentSourceURL, songDuration: 3600, position: 1, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Resonant", songSourceURL: songResonantSourceURL, songDuration: 3600, position: 2, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Peaceful", songSourceURL: songPeacefulSourceURL, songDuration: 3551, position: 3, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Focused", songSourceURL: songFocusedSourceURL, songDuration: 3600, position: 4, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Journey", songSourceURL: songJourneySourceURL, songDuration: 2870, position: 5, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Relaxing", songSourceURL: songRelaxingSourceURL, songDuration: 3566, position: 6, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Energizing", songSourceURL: songEnergizingSourceURL, songDuration: 3600, position: 7, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Meditation", songSourceURL: songMeditationSourceURL, songDuration: 3466, position: 8, productSku: DEFAULT_PRODUCT_SKU)
        MusicManager.createMusicRecord(name: "Jazz", songSourceURL: songJazzSourceURL, songDuration: 3539, position: 9, productSku: DEFAULT_PRODUCT_SKU)

        do {
            // save things
            try musicDao.context().save()
        } catch {
            log("Error saving default music.")
        }

        let defaultMusic = defaultMusicDao.defaultMusicForPosition(tilePosition: 1)

        if defaultMusic == nil {
            DefaultMusicDao.instance.createDefaultMusic(name: "Present", imageAssetName: "Present", tilePosition: 1, songFilename: songPresentSourceURL!.lastPathComponent, sourceURL: songPresentSourceURL!.absoluteString, duration: 3600)
            DefaultMusicDao.instance.createDefaultMusic(name: "Resonant", imageAssetName: "Resonant", tilePosition: 2, songFilename: songResonantSourceURL!.lastPathComponent, sourceURL: songResonantSourceURL!.absoluteString, duration: 3600)
            DefaultMusicDao.instance.createDefaultMusic(name: "Peaceful", imageAssetName: "Peaceful", tilePosition: 3, songFilename: songPeacefulSourceURL!.lastPathComponent, sourceURL: songPeacefulSourceURL!.absoluteString, duration: 3551)
            DefaultMusicDao.instance.createDefaultMusic(name: "Focused", imageAssetName: "Focused", tilePosition: 4, songFilename: songFocusedSourceURL!.lastPathComponent, sourceURL: songFocusedSourceURL!.absoluteString, duration: 3600)
            DefaultMusicDao.instance.createDefaultMusic(name: "Journey", imageAssetName: "Journey", tilePosition: 5, songFilename: songJourneySourceURL!.lastPathComponent, sourceURL: songJourneySourceURL!.absoluteString, duration: 2870)
            DefaultMusicDao.instance.createDefaultMusic(name: "Relaxing", imageAssetName: "Relaxing", tilePosition: 6, songFilename: songRelaxingSourceURL!.lastPathComponent, sourceURL: songRelaxingSourceURL!.absoluteString, duration: 3566)
            DefaultMusicDao.instance.createDefaultMusic(name: "Energizing", imageAssetName: "Energizing", tilePosition: 7, songFilename: songEnergizingSourceURL!.lastPathComponent, sourceURL: songEnergizingSourceURL!.absoluteString, duration: 3600)
            DefaultMusicDao.instance.createDefaultMusic(name: "Meditation", imageAssetName: "Meditation", tilePosition: 8, songFilename: songMeditationSourceURL!.lastPathComponent, sourceURL: songMeditationSourceURL!.absoluteString, duration: 3466)
            DefaultMusicDao.instance.createDefaultMusic(name: "Jazz", imageAssetName: "Jazz", tilePosition: 9, songFilename: songJazzSourceURL!.lastPathComponent, sourceURL: songJazzSourceURL!.absoluteString, duration: 3539)

            do {
                // save things
                try defaultMusicDao.context().save()
            } catch {
                log("Error saving default music.")
            }
        }
    }

    /*
    Verify all the music files.
    */
    func verifyDownloadFiles() -> Bool {

        var filesExistCount: Int = 0
        var fileCount = 0

        var music = MusicTileDao.instance.allMusic(excludeSamples: true)

        if music.count == 0 {
            return false
        }
        for m in music {
            if let songs = m.songs {
                for s in songs {
                    let song: Song = s as! Song
                    if let destinationUrl = self.songURL(song: song) {
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            filesExistCount += 1
                        }
                    }
                    fileCount += 1
                }
            }
        }
        return filesExistCount == fileCount
    }

    func verifySongs(songs: [SongAsset], tilePosition: Int16) -> Bool {

        var filesExistCount: Int = 0
        var fileCount = 0

        for s in songs {
            let songAsset: SongAsset = s as! SongAsset
            if let songAssetURL = URL(string: songAsset.songURL) {
                let songFilename = songAsset.productSku + "_" + songAssetURL.lastPathComponent
                // shouldn't do this hre but on't have a song object so going with it.
                let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                var songURL : URL? = documentDirectory.appendingPathComponent(songFilename)

                if FileManager.default.fileExists(atPath: songURL!.path) {
                    filesExistCount += 1
                }
            }
            fileCount += 1
        }
        return filesExistCount == fileCount
    }

    func checkForV2Upgrade() -> Bool {
        var upgrade = false

        if FileManager.default.fileExists(atPath: v2SongEnergizingURL.path),
           FileManager.default.fileExists(atPath: v2SFocusedURL.path),
           FileManager.default.fileExists(atPath: v2SJazzURL.path),
           FileManager.default.fileExists(atPath: v2SJourneyURL.path),
           FileManager.default.fileExists(atPath: v2SPeacefulURL.path),
           FileManager.default.fileExists(atPath: v2SPresentURL.path),
           FileManager.default.fileExists(atPath: v2SRelaxingURL.path),
           FileManager.default.fileExists(atPath: v2SMeditationURL.path),
           FileManager.default.fileExists(atPath: v2SResonantURL.path) {
            upgrade = true
        }
        return upgrade
    }


    func getDownloadCount(musicToDownload: [MusicTile]) -> Int {

        var count = 0
        for music in musicToDownload {
            if let songs = music.songs {
                count += songs.count
            }
        }
        return count
    }

    func downloadMusic(musicToDownload: [MusicTile], musicStep: Int, songStep: Int, downloadDelegate: MusicDownloadDelegate) {

        self.musicStep = musicStep
        self.songStep = songStep
        self.downloadDelegate = downloadDelegate
        self.musicToDownload = musicToDownload
        self.songCount += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            // Put your code which should be executed with a delay here
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: UUID().uuidString)
            self.backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)

            // are we done?
            if musicStep == musicToDownload.count {
                // verify the music after the download
                downloadDelegate.downloadComplete(error: false)//!self.verifyDownloadFiles())
                // clean up directory
                // things aren't saved yet, load what's stored to see if anything is de-selected.
//                let musicTileOld = MusicTileDao.instance.musicForPosition(position: musicToDownload[musicStep].position)
//                self.cleanupMusicForTile(musicTile: musicToDownload[0])
                self.downloadComplete = true
            } else {
                var music = musicToDownload[musicStep]
                if let songs = music.songs, let song: Song = songs.object(at: songStep) as! Song {
                    self.currentSong = song
                    // loop through the music and download what we don't already have
                    var downloadFile = true

                    if let audioUrl = URL(string: song.sourceURL!), let destinationUrl = self.songURL(song: song) {
                        // lets create your destination file url
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            let semaphore = DispatchSemaphore(value: 0)
                            do {
                                let attr = try FileManager.default.attributesOfItem(atPath: destinationUrl.path)
                                var fileSize = attr[FileAttributeKey.size] as! UInt64
                                self.getDownloadSize(url: audioUrl, completion: { (size, error) in
                                    if error == nil {
                                        if fileSize == size {
                                            downloadFile = false
                                            downloadDelegate.downloadProgress(progressText: "\(URL(string: song.songFilename!)?.lastPathComponent)...\nFile Exists, skipping file")
                                        }
                                    }
                                    semaphore.signal()
                                })
                                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                                var go = 0
                            } catch {
                            }
                        }

                        if (downloadFile) {
                            self.downloadTask = self.backgroundSession.downloadTask(with: audioUrl)
                            self.downloadTask.resume()
                        } else {
                            self.gotoNextSong()
                        }
                    }
                }
            }

        })
    }

/*
    Cleanup music that's not longer assigned except for the default.
*/
    func cleanupMusicForTile(musicTile: MusicTile) {

        do {
            let musicDirectory = self.musicDirectoryForTilePosition(position: musicTile.position)
            let files = try FileManager.default.contentsOfDirectory(atPath: musicDirectory)
            for f in files {
                var found = false

                if let songs = musicTile.songs {
                    for s in songs {
                        let song: Song = s as! Song
                        if song.music.sample {
                            continue
                        }
                        if song.songFilename == f {
                            found = true
                            break
                        }
                    }
                }
                if !found {
                    // remove it
                    try FileManager.default.removeItem(atPath: musicDirectory + "/" + f)
                }
            }
            let ff = try FileManager.default.contentsOfDirectory(atPath: musicDirectory)
        } catch let error as NSError {
            log("Error cleaning up music for tile " + String(musicTile.position) + " Error: " + error.localizedDescription)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        if let audioUrl = URL(string: (self.currentSong.songFilename)!) {
            // lets create your destination file url
            if let destinationUrl = self.songURL(song: currentSong!) {

//                print(destinationUrl)
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    log("The file " + audioUrl.lastPathComponent + " already exists at path")
                    do {
                        try FileManager.default.removeItem(atPath: destinationUrl.path)
                        log(audioUrl.lastPathComponent + " deleted.")
                    } catch {
                        log("Unable to delete file " + audioUrl.lastPathComponent)
                    }
                }

                do {
                    // move it
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    log(audioUrl.lastPathComponent + " moved to destination.")
                    // update songs position
                    MusicTileDao.instance.save()
                    self.gotoNextSong()

                } catch let error as NSError {
                    log("Error moving " + audioUrl.lastPathComponent + " to documents folder. " + error.localizedDescription)
                }
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil, let errorMsg = error?.localizedDescription {
            log("Error downloading file: " + errorMsg)
        }
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if error != nil, let errorMsg = error?.localizedDescription {
            log("Error downloading file: " + errorMsg)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {


        if let dd: MusicDownloadDelegate = downloadDelegate {
            var songCount = self.getDownloadCount(musicToDownload: self.musicToDownload)
            dd.downloadProgress(progressText: "Downloading \(currentSong.name!)...\n\(self.songCount) of \(self.getDownloadCount(musicToDownload: self.musicToDownload))\n\(totalBytesWritten)/\(totalBytesExpectedToWrite)\nPercentage: \(Int((Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100))%")
        }
    }

    func gotoNextSong() {
        // increment the step to download the next file
        var nextMusicStep = musicStep
        var nextSongStep = songStep

        // see where we're at
        if let songs = musicToDownload[musicStep].songs {
            if musicStep + 1 == musicToDownload.count && songStep + 1 == songs.count {
                // download will kick out
                nextMusicStep += 1

            } else if songStep + 1 == songs.count {
                nextSongStep = 0
                nextMusicStep += 1
            } else {
                nextSongStep += 1
            }
        }

        self.downloadMusic(musicToDownload: musicToDownload, musicStep: nextMusicStep, songStep: nextSongStep, downloadDelegate: downloadDelegate)
    }

    func getDownloadSize(url: URL, completion: @escaping (Int64, Error?) -> Void) {
        let timeoutInterval = 5.0
        var request = URLRequest(url: url,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: timeoutInterval)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let contentLength = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            completion(contentLength, error)
        }.resume()
    }

    func songURL(song: Song) -> URL! {
        var songURL: URL?

        if !song.music.sample {
            let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            songURL = documentDirectory.appendingPathComponent(song.songFilename!)

        } else {
            // bundled
            let stringPath = Bundle.main.path(forResource: song.songFilename, ofType: nil)!
            songURL = URL(fileURLWithPath: stringPath)
        }
        return songURL
    }

    func songPath(song: Song) -> URL? {

        var songDirectory: URL
        let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        songDirectory = documentDirectory.absoluteURL!
        return songDirectory
    }

    func musicDirectoryForTilePosition(position: Int16) -> String {

        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentDirectory + "/music/position_" + String(position)
    }

    // Save the music from the selected song assets
    func copySongAssetsToMusic(music: MusicTile, songAssets: [SongAsset]) -> Bool {
        var result = true

        var songs = NSMutableOrderedSet()
        var songDao = SongDao.instance
        var position: Int16 = 1

        for songAsset in songAssets {
            // get the filename
            if let songURL = URL(string: songAsset.songURL) {
                let songFilename = songAsset.productSku + "_" + songURL.lastPathComponent
                if let song = songDao.songExists(name: songAsset.name, productSku: songAsset.productSku) {
                    songs.add(song)
                } else {
                    if let song = songDao.createSong(name: songAsset.name, position: position, songFilename: songFilename, sourceURL: songAsset.songURL, duration: songAsset.durationSeconds, productSku: songAsset.productSku) {
                        songs.add(song)
                    }
                }
            }
            position += 1
        }
        music.songs = songs
        return result
    }

    static func createMusicRecord(name: String, songSourceURL: URL!, songDuration: Int32, position: Int16, productSku: String) -> MusicTile {

        var name = name
        var music = MusicTileDao.instance.createMusic(name: name)
        music?.imageAssetName = name
        music?.position = position
        music?.sample = false
        // now create a song
        if var song = SongDao.instance.createSong(name: name, position: position, songFilename: songSourceURL.lastPathComponent, sourceURL: songSourceURL.absoluteString, duration: songDuration, productSku: productSku) {
            song.music = music
        }
        return music!
    }


    static func createSampleMusicRecord(name: String, filename: String, songDuration: Int32, position: Int16) -> MusicTile {

        var name = name
        var music = MusicTileDao.instance.createMusic(name: name)
        music?.imageAssetName = name
        music?.position = position
        music?.sample = true
        // now create a song
        if var song = SongDao.instance.createSong(name: name, position: position, songFilename: filename, sourceURL: nil, duration: songDuration, productSku: nil) {
            song.music = music
        }
        return music!
    }

    static func createMusicRecordFromDefault(position: Int16) {

        if let defaultMusic = DefaultMusicDao.instance.defaultMusicForPosition(tilePosition: position) {
            createMusicRecord(name: defaultMusic.name!, songSourceURL: URL(string: defaultMusic.sourceURL!), songDuration: defaultMusic.duration, position: position, productSku: DEFAULT_PRODUCT_SKU)
        } else {
            log("Error creating music record from default.")
        }
    }

}
