//
// Created by Dave Brown on 2018-09-23.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import CoreData

class SongModel {
    var imageName: String!
    var imagePath: String!
    var position: Int!
    var duration: String!
    var name: String!

    init() {
    }

    init(imageName: String!, imagePath: String!, position: Int!, duration: String!, name: String!) {
        self.imageName = imageName
        self.imagePath = imagePath
        self.position = position
        self.duration = duration
        self.name = name
    }
}
