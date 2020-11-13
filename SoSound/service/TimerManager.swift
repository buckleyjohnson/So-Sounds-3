//
//  TimerManager.swift
//  SoSound
//
//  Created by David on 7/12/17.
//  Copyright © 2017 Reverie. All rights reserved.
//

import Foundation
class TimerManager: NSObject {
    var timer:Timer = Timer()
    
    override init() {
        super.init()
        self.timer.invalidate()
    }
    
    func setTimer(time:Int) {
        print("setTimer time======", time)
        self.timer = Timer.scheduledTimer(timeInterval: Double(time * 60), target: self, selector: #selector(TimerManager.timerExecute), userInfo: nil, repeats: false)
    }
    
    func cancelTimer() {
        print("cancell timer")
        self.timer.invalidate()
    }
    
    @objc func timerExecute() {
        print("timerExecute....");

        self.timer.invalidate()
        soundManager.transitionSong(url: songSoSoundURL!, delegate: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kTimer), object: self)
    }
}
