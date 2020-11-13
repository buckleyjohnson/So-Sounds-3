//
// Created by Dave Brown on 2018-10-01.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import CoreData

class ApplicationDao: SoSoundDao {
    static let instance: ApplicationDao = ApplicationDao()


    func application() -> Application? {
        var application: Application? = nil
        var fetchResult: Array<Application>

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Application")
            fetchResult = try context().fetch(fetchRequest) as! Array<Application>
            if let _result: Array<Application> = fetchResult {
                if _result.count > 0 {
                    application = _result[0]
                }
            }

        } catch {
            log("Didn't find the application record:  " + error.localizedDescription)
        }
        return application
    }

    /*
    Creates an application record.
    */
    func createApplication() -> Application {

        let application = Application(context: context())

        do {
            try context().save()
        } catch {
            log("Error creating application record:  " + error.localizedDescription)
        }
        return application
    }

    /**
        Remove Application record
    */
    func cleanup() {

        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Application")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let result = try context().execute(deleteRequest)
        } catch {
            log("Error deleting application:  " + error.localizedDescription)
        }
    }
}