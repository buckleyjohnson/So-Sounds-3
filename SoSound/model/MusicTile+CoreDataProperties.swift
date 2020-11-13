//
//  MusicTile+CoreDataProperties.swift
//  SoSound
//
//  Created by Dave Brown on 11/14/18.
//  Copyright © 2018 So Sound. All rights reserved.
//
//

import Foundation
import CoreData


extension MusicTile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicTile> {
        return NSFetchRequest<MusicTile>(entityName: "MusicTile")
    }

    @NSManaged public var imageAssetName: String?
    @NSManaged public var localImageFile: String?
    @NSManaged public var name: String?
    @NSManaged public var position: Int16
    @NSManaged public var sample: Bool
    @NSManaged public var songs: NSOrderedSet?
}

// MARK: Generated accessors for songs
extension MusicTile {

    @objc(insertObject:inSongsAtIndex:)
    @NSManaged public func insertIntoSongs(_ value: Song, at idx: Int)

    @objc(removeObjectFromSongsAtIndex:)
    @NSManaged public func removeFromSongs(at idx: Int)

    @objc(insertSongs:atIndexes:)
    @NSManaged public func insertIntoSongs(_ values: [Song], at indexes: NSIndexSet)

    @objc(removeSongsAtIndexes:)
    @NSManaged public func removeFromSongs(at indexes: NSIndexSet)

    @objc(replaceObjectInSongsAtIndex:withObject:)
    @NSManaged public func replaceSongs(at idx: Int, with value: Song)

    @objc(replaceSongsAtIndexes:withSongs:)
    @NSManaged public func replaceSongs(at indexes: NSIndexSet, with values: [Song])

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSOrderedSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSOrderedSet)

}
