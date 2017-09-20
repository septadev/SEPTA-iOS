//
//  AlertDetailViewController.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/17/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit
import SeptaSchedule
import SeptaRest

class AlertDetailViewController: UIViewController {
    let watcher = AlertState_AlertDetailsWatcher()
    var alertDetails = [AlertDetails_Alert]() {
        didSet {
            tableView.reloadData()
        }
    }

    let cellId = "alertDetailCell"
    @IBOutlet weak var routeNameLabel: UILabel! {
        didSet {
            guard let route = route else { return }
            routeNameLabel.text = route.routeAlertTitle()
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let cellNib = UINib(nibName: "AlertDetailCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cellId)
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundColor = UIColor.clear
            tableView.allowsSelection = false
        }
    }

    @IBOutlet weak var pillView: UIView! {
        didSet {
            guard let route = route else { return }
            pillView.layer.cornerRadius = 5
            pillView.backgroundColor = Route.colorForRoute(route, transitMode: transitMode)
        }
    }

    var transitMode: TransitMode {
        return scheduleRequest.transitMode
    }

    var scheduleRequest: ScheduleRequest {
        return store.state.alertState.scheduleState.scheduleRequest
    }

    var route: Route? {
        return scheduleRequest.selectedRoute
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        watcher.delegate = self
        view.backgroundColor = SeptaColor.navBarBlue
        navigationController?.navigationBar.configureBackButton()
        setTitle()
    }

    func setTitle() {

        navigationItem.title = transitMode.alertDetailTitle()
    }
}

extension AlertDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in _: UITableView) -> Int {
        return 4
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 5
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AlertDetailCell else { return UITableViewCell() }
        cell.sectionNumber = indexPath.section
        cell.delegate = self
        switch indexPath.section {
        case 0: configureForServiceAdvisories(cell: cell)
        case 1: configureForServiceAlerts(cell: cell)
        case 2: configureForDetours(cell: cell)
        case 3: configureForWeather(cell: cell)
        default: break
        }

        return cell
    }
}

extension AlertDetailViewController: AlertState_AlertDetailsWatcherDelegate {
    func alertState_AlertDetailsUpdated(alertDetails: [AlertDetails_Alert]) {
        self.alertDetails = alertDetails
    }
}

private extension String {

    var htmlAttributedString: NSAttributedString? {

        do {
            guard let data = self.data(using: .utf8) else { return nil }
            return try NSAttributedString(data: data, options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            ], documentAttributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension AlertDetailViewController {

    func configureForServiceAdvisories(cell: AlertDetailCell) {

        cell.alertImage.image = UIImage(named: "advisoryAlert")
        cell.advisoryLabel.text = "Service Advisories"
        cell.disabledAdvisoryLabel.text = "No Service Advisories"
        if let first = alertDetails.first, let advisoryMessage = first.advisory_message, advisoryMessage.count > 0 {
            cell.setEnabled(true)
            cell.textView.text = advisoryMessage
        } else {
            cell.textView.text = nil
            cell.setEnabled(false)
        }
    }

    func configureForServiceAlerts(cell: AlertDetailCell) {
        cell.alertImage.image = UIImage(named: "alertAlert")
        cell.advisoryLabel.text = "Service Alerts"
        cell.disabledAdvisoryLabel.text = "No Service Alerts"
        if let first = alertDetails.first, let advisoryMessage = first.message, advisoryMessage.count > 0 {
            cell.setEnabled(true)
            cell.textView.text = advisoryMessage
        } else {
            cell.textView.text = nil
            cell.setEnabled(false)
        }
    }

    func configureForDetours(cell: AlertDetailCell) {
        cell.alertImage.image = UIImage(named: "detourAlert")
        cell.advisoryLabel.text = "Active Detours"
        cell.disabledAdvisoryLabel.text = "No Active Detours"
        if let first = alertDetails.first, let detour = first.detour, let advisoryMessage = detour.message, advisoryMessage.count > 0 {
            cell.setEnabled(true)
            cell.textView.text = advisoryMessage
        } else {
            cell.textView.text = nil
            cell.setEnabled(false)
        }
    }

    func configureForWeather(cell: AlertDetailCell) {
        cell.alertImage.image = UIImage(named: "weatherAlert")
        cell.advisoryLabel.text = "Weather Alerts"
        cell.disabledAdvisoryLabel.text = "No Weather Alerts"
        //        if let first = alertDetails.first, let advisoryMessage = first.snow, advisoryMessage.count > 0 {
        //            cell.setEnabled(true)
        //            cell.textView.text = advisoryMessage
        //        } else {
        cell.textView.text = nil
        cell.setEnabled(false)
        //        }
    }
}

extension AlertDetailViewController: AlertDetailCellDelegate {
    func didTapButton(sectionNumber _: Int) {
        self.tableView.reloadData()
    }
}