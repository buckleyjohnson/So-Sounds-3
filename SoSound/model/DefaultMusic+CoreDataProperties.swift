//
//  DefaultMusic+CoreDataProperties.swift
//  SoSound
//
//  Created by Dave Brown on 11/25/18.
//  Copyright © 2018 So Sound. All rights reserved.
//
//

import Foundation
import CoreData


extension DefaultMusic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefaultMusic> {
        return NSFetchRequest<DefaultMusic>(entityName: "DefaultMusic")
    }

    @NSManaged public var duration: Int32
    @NSManaged public var name: String?
    @NSManaged public var tilePosition: Int16
    @NSManaged public var songFilename: String?
    @NSManaged public var sourceURL: String?
    @NSManaged public var imageAssetName: String?
}
