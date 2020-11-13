//
// Created by Dave Brown on 2018-09-24.
// Copyright (c) 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit


/*
Delegate for the music download process
        */
public protocol SettingTappedDelegate {

    func settingTapped(settingRow: Int)
}


enum ServerConfigTableRow: Int {
    case ABOUT = 0
    case SETTINGS
    case SHOW_TOUR
    case SUPPORT
    case EXIT_APPLICATION
}


class SettingsPopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    open var delegate: SettingTappedDelegate?

    var selectedRow = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = tableView.contentSize
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SettingsTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch indexPath.row {

        case ServerConfigTableRow.ABOUT.rawValue:
            cell.textLabel?.text = "About"
            break

        case ServerConfigTableRow.SHOW_TOUR.rawValue:
            cell.textLabel?.text = "Show Tour"
            break
        case ServerConfigTableRow.SETTINGS.rawValue:
            cell.textLabel?.text = "Application Settings"
            break

        case ServerConfigTableRow.SUPPORT.rawValue:
            cell.textLabel?.text = "Support"
            break

        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        dismiss(animated: true)
        delegate?.settingTapped(settingRow: indexPath.row)
    }
}
