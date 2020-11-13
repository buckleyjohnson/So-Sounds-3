//
// Created by Dave Brown on 2019-01-09.
// Copyright (c) 2019 So Sound. All rights reserved.
//

import Foundation

class ImageUtil {

    static func tileImageDirectory() -> String {

        var tileImageDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/tileImages"

        do {
            // make sure the directory is there
            try FileManager.default.createDirectory(atPath: tileImageDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        return tileImageDirectory
    }

    static func tileImageBaseNameForPosition(position: Int16) -> String {

        return "tile_" + String(position) + "_image"
    }

    static func tileImagePathForImage(tileImageName: String) -> String {

        return tileImageDirectory() + "/" + tileImageName
    }



}
