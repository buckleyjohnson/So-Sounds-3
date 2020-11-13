//
// Created by Dave Brown on 9/6/18.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation

import UIKit

class MusicDownloadView: UIView {

    var downloadLabel: UILabel!

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

//        self.frame = CGRect(x: self.frame.width / 4, y: self.frame.height / 4, width: self.frame.width / 2, height: self.frame.height / 2)
        self.downloadLabel.frame = self.bounds
    }

    func initializeView() {

        self.backgroundColor = UIColor.white
        self.downloadLabel = UILabel(frame: CGRect.zero)
        self.downloadLabel.backgroundColor = UIColor.black
        self.downloadLabel.textColor = UIColor.white
        self.downloadLabel.textAlignment = .center
        self.downloadLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.downloadLabel.text = "Starting Download..."
        self.downloadLabel.numberOfLines = 0
        self.addSubview(self.downloadLabel)
    }

}
