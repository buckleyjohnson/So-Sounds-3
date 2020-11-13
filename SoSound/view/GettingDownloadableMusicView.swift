//
// Created by Dave Brown on 9/6/18.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation

import UIKit

class GettingDownloadableMusicView: UIView {

    var textLabel: UILabel!

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

        self.frame = CGRect(x: self.frame.width / 4, y: self.frame.height / 4, width: self.frame.width / 2, height: self.frame.height / 2)
        self.textLabel.frame = self.bounds
    }

    func initializeView() {

        self.backgroundColor = UIColor.white
        self.textLabel = UILabel(frame: CGRect.zero)
        self.textLabel.backgroundColor = UIColor.black
        self.textLabel.textColor = UIColor.white
        self.textLabel.textAlignment = .center
        self.textLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.textLabel.text = "Retrieving downloadable music... "
        self.textLabel.numberOfLines = 0
        self.addSubview(self.textLabel)
    }

}
