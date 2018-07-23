//
//  PushNotificationPreferenceState.swift
//  iSEPTA
//
//  Created by Mark Broski on 7/23/18.
//  Copyright © 2018 Mark Broski. All rights reserved.
//

import Foundation

struct PushNotificationPreferenceState: Codable, Equatable {
    /// An array of `RangeBounds` structs.
    /// For example:  [[start: 360, end: 720], [start: 900, end: 960]] means
    /// that the user wants to receive notifications between 6 AM and 12 PM.
    /// and from 5 - 6 PM.
    var notificationTimeWindows: [NotificationTimeWindow] = [NotificationTimeWindow]()

    /// An OptionSet that allows users to the days of the week on which they wish to receive notifications.
    var daysOfWeek: DaysOfWeekOptionSet = DaysOfWeekOptionSet.unknown

    /// The routes for which the user has subscribed to notifications
    var routeIds: [String] = [String]()

    /// This method indicates whether a push notification should be fired
    /// based on the user preferences described in this class.  Note that
    /// those preferences do not include whether or not the user has authorized
    /// push notifications in the first place.  That needs to be checked separately
    func userShouldReceiveNotification(atDate date: Date, forRouteId selectedRouteId: String) -> Bool {
        let timeWindowsMatches = notificationTimeWindows.map { $0.dateFitsInRange(date: date) }
        return
            routeIds.contains(selectedRouteId) &&
            daysOfWeek.matchesDate(date) &&
            timeWindowsMatches.contains(true)
    }
}
