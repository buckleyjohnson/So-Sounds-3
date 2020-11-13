//
// Created by Dave Brown on 2018-09-23.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class MusicRowTableCell : UITableViewCell {
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtwork: UIImageView!
    @IBOutlet weak var songDuration: UILabel!
    @IBOutlet weak var songPosition: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var trackNumber: UILabel!
}
