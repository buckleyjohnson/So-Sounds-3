//
// Created by Dave Brown on 2018-09-27.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import CoreData

class SongDao: SoSoundDao {
    static let instance: SongDao = SongDao()

    func createSong(name: String, position: Int16, songFilename: String, sourceURL: String?, duration: Int32, productSku: String?) -> Song! {
        var result: Song! = nil

        let song = Song(context: context())
        song.name = name
        song.duration = duration
        song.position = position
        song.sourceURL = sourceURL
//        log(sourceURL)
        song.productSku = productSku
        song.songFilename = songFilename

        do {
            try context().save()
        } catch {
            log("Error creating song record: " + error.localizedDescription)
        }
        return song
    }

    func songExists(name: String, productSku: String) -> Song? {
        var song: Song? = nil
        var songFetchResult: Array<Song>? = nil

        do {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND productSku == %@", name, productSku)
            songFetchResult = try context().fetch(fetchRequest) as! Array<Song>
        } catch {
            log("Didn't find any music records: " + error.localizedDescription)
        }
        if let _songs = songFetchResult {
            if _songs.count > 0 {
                song = _songs[0]
            }
        }
        return song
    }

    func songRecordExistsForFilename(filename: String) -> Song? {
        var song: Song? = nil
        var songFetchResult: Array<Song>? = nil

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
            fetchRequest.predicate = NSPredicate(format: "filename == %@", filename)
            songFetchResult = try context().fetch(fetchRequest) as! Array<Song>
        } catch {
            log("Didn't find any music records: " + error.localizedDescription)
        }
        if let _songs = songFetchResult {
            if _songs.count > 0 {
                song = _songs[0]
            }
        }
        return song
    }

    /**
        Returns all the songs
    */
    func allSongs() -> Array<Song> {
        var songs: Array<Song>! = nil

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
            songs = try context().fetch(fetchRequest) as! Array<Song>
        } catch {
            log("Didn't find any song records: " + error.localizedDescription)
        }
        return songs
    }

    /**
        Remove all songs
    */
    func removeSongs() {

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let result = try context().execute(deleteRequest)
        } catch {
            log("Error deleting songs: " + error.localizedDescription)
        }
    }

    /**
        Remove all songs
    */
    func removeSampleSongs() {

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Song")
            fetchRequest.predicate = NSPredicate(format: "music.sample == YES")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let result = try context().execute(deleteRequest)
        } catch {
            log("Error deleting sample songs: " + error.localizedDescription)
        }
    }
}