//
// Created by Dave Brown on 2018-09-27.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import CoreData

class DefaultMusicDao: SoSoundDao {
    static let instance: DefaultMusicDao = DefaultMusicDao()

    func createDefaultMusic(name: String, imageAssetName : String, tilePosition : Int16, songFilename : String, sourceURL : String, duration : Int32) -> DefaultMusic! {
        var result: DefaultMusic! = nil

        let music = DefaultMusic(context: context())
        music.name = name
        music.imageAssetName = imageAssetName
        music.tilePosition = tilePosition
        music.songFilename = songFilename
        music.sourceURL = sourceURL
        music.duration = duration

        do {
            try context().save()
        } catch {
            log("Error creating default music record:  " + error.localizedDescription)
        }
        return music
    }

    /**
        Returns all the music
    */
    func allDefaultMusic() -> Array<DefaultMusic> {
        var music: Array<DefaultMusic>! = Array.init()

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultMusic")
            music = try context().fetch(fetchRequest) as! Array<DefaultMusic>
        } catch {
            log("Didn't find any default music records:  " + error.localizedDescription)
        }
        return music
    }

    /**
      Returns all the songs
    */
    func defaultMusicForPosition(tilePosition: Int16) -> DefaultMusic! {
        var musicResult: DefaultMusic? = nil
        var musicFetchResult : Array<DefaultMusic>? = nil

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultMusic")
            fetchRequest.predicate = NSPredicate(format: "tilePosition == %d", tilePosition)
            musicFetchResult = try context().fetch(fetchRequest) as! Array<DefaultMusic>
        } catch {
            log("Didn't find any music records: " + error.localizedDescription)
        }
        if let _music = musicFetchResult {
            if _music.count > 0 {
                musicResult = _music[0]
            }
        }
        return musicResult
    }

    /**
        Remove all default music
    */
    func removeAllDefaultMusic() {

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultMusic")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let result = try context().execute(deleteRequest)
        } catch {
            log("Error deleting default music: " + error.localizedDescription)
        }
    }

}