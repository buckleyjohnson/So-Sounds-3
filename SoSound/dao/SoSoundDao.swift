//
// Created by Dave Brown on 2018-09-27.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import CoreData


class SoSoundDao {

    static var context: NSManagedObjectContext?
    static var model: NSManagedObjectModel?

    init() {

        // one instance, only init if first time
        if (SoSoundDao.context == nil) {
            var model = NSManagedObjectModel.mergedModel(from: nil)
            var psc: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model!)

            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sosoundArchivePath(), options: options)
            } catch {
                fatalError("Failed to add persistent store: \(error)")
            }
            // Create the managed object context
            SoSoundDao.context = NSManagedObjectContext()
            SoSoundDao.context?.persistentStoreCoordinator = psc
            SoSoundDao.context?.undoManager = nil
        }
    }

    func sosoundArchivePath() -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        return documentsDirectory.appendingPathComponent("sosound.data")
    }

    func save() -> Bool {
        var result: Bool = true
        do {
            try context().save()
        } catch {
            result = false
            log("Error saving data")
        }
        return result
    }

    func context() -> NSManagedObjectContext {
        return SoSoundDao.context!;
    }
}

