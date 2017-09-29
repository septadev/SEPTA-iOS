//
//  WebViewController.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/29/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, IdentifiableController {
var viewController: ViewController = .webViewController
    var webView: WKWebView!

    override func viewDidLoad() {
        view.backgroundColor = SeptaColor.navBarBlue
        super.viewDidLoad()
        webView = WKWebView(frame: view.frame)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.pinSubviewToNavBarBottom(webView, topLayoutGuide: topLayoutGuide)
        loadURL()
        navigationController?.navigationBar.configureBackButton()
    }

    func loadURL() {
        if let info = store.state.moreState.septaUrlInfo {
            let request = URLRequest(url: info.url)
            webView.load(request)
            title = info.title
        }
    }

    
}