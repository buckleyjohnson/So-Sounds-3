//
// Created by Dave Brown on 2018-10-01.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation

class DatabaseManager {
    static let instance: DatabaseManager = DatabaseManager()
    var v2Upgrade = false

    func initialize() -> Application? {
        var appDao = ApplicationDao.instance
        var application = appDao.application()

        var appVersion: String?
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
           let majorVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = majorVersion + "." + buildVersion
        }

        if application == nil {
            let application = appDao.createApplication()
            application.enableAdminPassword = false
            application.enableDemoMode = true
            v2Upgrade = true
        }

        application?.enableDemoMode = true
        if let version = appVersion {
            application?.version = version
        }

        appDao.save()
        return application
    }

}