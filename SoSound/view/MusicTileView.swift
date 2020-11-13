//
// Created by Dave Brown on 2018-09-23.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class MusicTileView :  UIView {
    var title: String!
    var backgroundImage: UIImage!
    var titleLabel: UILabel!


    init(title: String, backgroundImage: UIImage) {

        self.title = title
        self.backgroundImage = backgroundImage
        super.init(frame: CGRect())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}




