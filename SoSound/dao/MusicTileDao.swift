//
// Created by Dave Brown on 2018-09-27.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import CoreData

class MusicTileDao: SoSoundDao {
    static let instance: MusicTileDao = MusicTileDao()

    func createMusic(name: String) -> MusicTile! {
        var result: MusicTile! = nil

        let music = MusicTile(context: context())
        music.name = name
        do {
            try context().save()
        } catch {
            log("Error creating music record:  " + error.localizedDescription)
        }
        return music
    }


    /**
      Returns all the songs
    */
    func musicForPosition(position: Int16) -> MusicTile! {
        var musicResult: MusicTile? = nil
        var musicFetchResult: Array<MusicTile>? = nil

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicTile")
            fetchRequest.predicate = NSPredicate(format: "position == %d", position)
            musicFetchResult = try context().fetch(fetchRequest) as! Array<MusicTile>
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
        Returns all the music
    */
    func allMusic(excludeSamples: Bool = false) -> Array<MusicTile> {
        var music: Array<MusicTile>! = Array.init()

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicTile")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
            if excludeSamples {
                fetchRequest.predicate = NSPredicate(format: "sample == NO")
            }
            music = try context().fetch(fetchRequest) as! Array<MusicTile>
        } catch {
            log("Didn't find any music records:  " + error.localizedDescription)
        }
        return music
    }

    /**
        Remove all songs
    */
    func removeAllMusic() {

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicTile")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let result = try context().execute(deleteRequest)
        } catch {
            log("Error deleting music: " + error.localizedDescription)
        }
    }

    /**
       Remove all songs
   */
    func removeSampleMusic() {

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicTile")
            fetchRequest.predicate = NSPredicate(format: "sample == YES")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let result = try context().execute(deleteRequest)
        } catch {
            log("Error deleting sample music  " + error.localizedDescription)
        }
    }
}