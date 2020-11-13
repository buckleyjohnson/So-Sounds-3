//
//  TimerViewController.swift
//  SoSound
//
//  Created by David on 7/10/17.
//  Copyright © 2017 Reverie. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet var timePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        timePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        timePicker.backgroundColor = .white

        let date = Calendar.current.date(bySettingHour: 0, minute: 5, second: 0, of: Date())!
        timePicker.setDate(date, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(TimerViewController.removeSelf), name: NSNotification.Name(rawValue: kTimer), object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!

        timerManager.timer.invalidate()
        timerManager.setTimer(time: (hour*60)+minute)
        let ud = UserDefaults.standard;
        let minutes = (hour*60)+minute
        print("hour=",hour);
        print("minute=", minute);
        print("minute=s", minutes);
        ud.set(minutes, forKey: "Minutes")
        ud.synchronize()
    }

    @objc func removeSelf() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    @IBAction func nextTapped(_ sender: Any) {
//
//        //set the universal timer to the selected time
//        let time = (self.timeSelectorSegmentedControl.selectedSegmentIndex + 1) * 5
//
//        timerManager.timer.invalidate()
//        timerManager.setTimer(time: time)
//
//        self.navigationController?.pushViewController(NewHomeViewController(), animated: true)
//    }
}
