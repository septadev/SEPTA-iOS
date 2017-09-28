//
//  MoreViewController.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/28/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit
class MoreViewController: UIViewController, IdentifiableController, UITableViewDelegate, UITableViewDataSource {
    let cellId = "moreCell"
    let viewController: ViewController = .moreViewController

    var viewModel: MoreViewModel!

    override func viewDidLoad() {
        view.backgroundColor = SeptaColor.navBarBlue
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = MoreViewModel()
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MoreTableViewCell else { return UITableViewCell() }
        viewModel.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let faresController: ViewController = .faresViewController
            let uiController: FaresViewController = faresController.instantiateViewController()!
            navigationController?.pushViewController(uiController, animated: true)
        }
    }
}
