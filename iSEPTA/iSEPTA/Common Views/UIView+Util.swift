//
//  UIView+Util.swift
//  iSEPTA
//
//  Created by Mark Broski on 8/19/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    class func instanceFromNib<T>(named name: String) -> T {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }

    class func addSurroundShadow(toView view: UIView) {
        let layer = view.layer
        layer.cornerRadius = 9

        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = SeptaColor.viewShadowColor.cgColor

        layer.masksToBounds = false
    }
}