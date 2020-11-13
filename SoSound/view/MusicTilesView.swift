//
// Created by Dave Brown on 2018-09-23.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit

class MusicTilesView: UIView {

    // tiles number start from upper left corner and go horizontally
    var tile1Image : UIImageView!;
    var tile2Image : UIImageView!;
    var tile3Image : UIImageView!;
    var tile4Image : UIImageView!;
    var tile5Image : UIImageView!;
    var tile6Image : UIImageView!;
    var tile7Image : UIImageView!;
    var tile8Image : UIImageView!;
    var tile9Image : UIImageView!;

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initializeView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

//        self.layer.borderWidth = 1
        let width = self.frame.width/3
        let height = self.frame.height/3

        self.tile1Image.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        self.tile2Image.frame = CGRect(x: width, y: 0.0, width: width, height: height)
        self.tile3Image.frame = CGRect(x: width+width, y: 0.0, width: width, height: height)

        self.tile4Image.frame = CGRect(x: 0.0, y: height, width: width, height: height)
        self.tile5Image.frame = CGRect(x: width, y: height, width: width, height: height)
        self.tile6Image.frame = CGRect(x: width+width, y: height, width: width, height: height)

        self.tile7Image.frame = CGRect(x: 0.0, y: height+height, width: width, height: height)
        self.tile8Image.frame = CGRect(x: width, y: height+height, width: width, height: height)
        self.tile9Image.frame = CGRect(x: width+width, y: height+height, width: width, height: height)
    }

    func initializeView() {

        self.tile1Image = UIImageView(image: UIImage(named: "Present"));
        self.tile1Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile1Image.clipsToBounds = true
        self.addSubview(tile1Image)

        self.tile2Image = UIImageView(image: UIImage(named: "Resonant"));
        self.tile2Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile2Image.clipsToBounds = true
        self.addSubview(tile2Image)

        self.tile3Image = UIImageView(image: UIImage(named: "Peaceful"));
        self.tile3Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile3Image.clipsToBounds = true
        self.addSubview(tile3Image)

        self.tile4Image = UIImageView(image: UIImage(named: "Focused"));
        self.tile4Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile4Image.clipsToBounds = true
        self.addSubview(tile4Image)

        self.tile5Image = UIImageView(image: UIImage(named: "Journey"));
        self.tile5Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile5Image.clipsToBounds = true
        self.addSubview(tile5Image)

        self.tile6Image = UIImageView(image: UIImage(named: "Relaxing"));
        self.tile6Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile6Image.clipsToBounds = true
        self.addSubview(tile6Image)

        self.tile7Image = UIImageView(image: UIImage(named: "Energizing"));
        self.tile7Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile7Image.clipsToBounds = true
        self.addSubview(tile7Image)

        self.tile8Image = UIImageView(image: UIImage(named: "Meditation"));
        self.tile8Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile8Image.clipsToBounds = true
        self.addSubview(tile8Image)

        self.tile9Image = UIImageView(image: UIImage(named: "Jazz"));
        self.tile9Image.contentMode = UIView.ContentMode.scaleAspectFill
        self.tile9Image.clipsToBounds = true
        self.addSubview(tile9Image)
    }
}
