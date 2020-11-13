//
//  Song+CoreDataProperties.swift
//  SoSound
//
//  Created by Dave Brown on 10/15/18.
//  Copyright © 2018 So Sound. All rights reserved.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var duration: Int32
    @NSManaged public var name: String?
    @NSManaged public var position: Int16
    @NSManaged public var songFilename: String?
    @NSManaged public var sourceURL: String?
    @NSManaged public var productSku: String?
    @NSManaged public var music: MusicTile!

}
