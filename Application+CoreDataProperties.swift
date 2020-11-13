//
//  Application+CoreDataProperties.swift
//  SoSound
//
//  Created by Dave Brown on 1/14/19.
//  Copyright © 2019 So Sound. All rights reserved.
//
//

import Foundation
import CoreData


extension Application {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Application> {
        return NSFetchRequest<Application>(entityName: "Application")
    }

    @NSManaged public var lastDownloadDate: NSDate?
    @NSManaged public var version: String?
    @NSManaged public var wordpressPassword: String?
    @NSManaged public var wordpressUsername: String?
    @NSManaged public var runInBackground: Bool
    @NSManaged public var showTour: Bool
    @NSManaged public var enableAdminPassword: Bool
    @NSManaged public var adminPassword: String?
    @NSManaged public var enableDemoMode: Bool

}
