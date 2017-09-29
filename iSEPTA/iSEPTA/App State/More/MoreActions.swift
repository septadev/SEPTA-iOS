//
//  MoreActions.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/29/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation

protocol MoreAction: SeptaAction {}

struct DisplayURL: MoreAction {
    let septaUrlInfo: SeptaUrlInfo
    let description: String = "User views URL"
}