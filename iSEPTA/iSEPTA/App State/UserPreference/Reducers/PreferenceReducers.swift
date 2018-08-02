// Septa. 2017

import Foundation
import ReSwift

struct UserPreferencesReducer {
    static func main(action: Action, state: UserPreferenceState?) -> UserPreferenceState {
        if let state = state {
            guard let action = action as? UserPreferencesAction else { return state }

            return reducePreferenceActions(action: action, state: state)

        } else {
            return UserPreferenceState()
        }
    }

    static func reducePreferenceActions(action: UserPreferencesAction, state: UserPreferenceState) -> UserPreferenceState {
        var newPref = state
        switch action {
        case let action as PreferencesRetrievedAction:
            newPref = reducePreferencesRetrievedAction(action: action, state: state)
        case let action as NewTransitModeAction:
            newPref = reduceNewTransitModeAction(action: action, state: state)
        case let action as PreferencesDatabaseLoaded:
            newPref = reducePreferencesDatabaseLoaded(action: action, state: state)
        case let action as NewStartupController:
            newPref = reduceNewStartupController(action: action, state: state)
        case let action as UpdatePushNotificationPreferenceState:
            newPref = reduceUpdatePushNotificationPreferenceState(action: action, state: state)
        case let action as UserWantsToSubscribeToPushNotifications:
            newPref = reduceUserWantsToSubscribeToPushNotifications(action: action, state: state)
        case let action as UserWantsToSubscribeToSpecialAnnouncements:
            newPref = reduceUserWantsToSubscribeToSpecialAnnouncements(action: action, state: state)
        case let action as UserWantsToSubscribeToOverideDoNotDisturb:
            newPref = reduceUserWantsToSubscribeToOverideDoNotDisturb(action: action, state: state)
        case let action as UpdateSystemAuthorizationStatusForPushNotifications:
            newPref = reduceUpdateSystemAuthorizationStatusForPushNotifications(action: action, state: state)
        case let action as UpdateDaysOfTheWeekForPushNotifications:
            newPref = reduceUpdateDaysOfTheWeekForPushNotifications(action: action, state: state)
        case let action as UpdatePushNotificationTimeframe:
            newPref = reduceUpdatePushNotificationTimeframe(action: action, state: state)
        case let action as InsertNewPushTimeframe:
            newPref = reduceInsertNewPushTimeframe(action: action, state: state)
        case let action as DeleteTimeframe:
            newPref = reduceDeleteTimeframe(action: action, state: state)
        case let action as AddPushNotificationRoute:
            newPref = reduceAddPushNotificationRoute(action: action, state: state)
        case let action as RemovePushNotificationRoute:
            newPref = reduceRemovePushNotificationRoute(action: action, state: state)
        case let action as UpdatePushNotificationRoute:
            newPref = reduceUpdatePushNotificationRoute(action: action, state: state)
        default:
            fatalError("You passed in an action for which there is no reducer")
        }

        return newPref
    }

    static func reducePreferencesRetrievedAction(action: PreferencesRetrievedAction, state _: UserPreferenceState) -> UserPreferenceState {
        return action.userPreferenceState
    }

    static func reduceNewTransitModeAction(action: NewTransitModeAction, state: UserPreferenceState) -> UserPreferenceState {
        var newState = state
        newState.startupTransitMode = action.transitMode
        return newState
    }

    static func reducePreferencesDatabaseLoaded(action: PreferencesDatabaseLoaded, state: UserPreferenceState) -> UserPreferenceState {
        var newState = state
        newState.databaseVersion = action.databaseVersion

        return newState
    }

    static func reduceNewStartupController(action: NewStartupController, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.startupNavigationController = action.navigationController
        return userPreferenceState
    }

    static func reduceUpdatePushNotificationPreferenceState(action: UpdatePushNotificationPreferenceState, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState = action.pushNotificationPreferenceState
        return userPreferenceState
    }

    static func reduceUserWantsToSubscribeToPushNotifications(action: UserWantsToSubscribeToPushNotifications, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState.userWantsToEnablePushNotifications = action.boolValue
        return userPreferenceState
    }

    static func reduceUserWantsToSubscribeToSpecialAnnouncements(action: UserWantsToSubscribeToSpecialAnnouncements, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState.userWantsToReceiveSpecialAnnoucements = action.boolValue
        return userPreferenceState
    }

    static func reduceUserWantsToSubscribeToOverideDoNotDisturb(action: UserWantsToSubscribeToOverideDoNotDisturb, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState.userWantToReceiveNotificationsEvenWhenDoNotDisturbIsOn = action.boolValue
        return userPreferenceState
    }

    static func reduceUpdateSystemAuthorizationStatusForPushNotifications(action: UpdateSystemAuthorizationStatusForPushNotifications, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState.systemAuthorizationStatusForNotifications = action.authorizationStatus
        return userPreferenceState
    }

    static func reduceUpdateDaysOfTheWeekForPushNotifications(action: UpdateDaysOfTheWeekForPushNotifications, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        if action.isActivated {
            userPreferenceState.pushNotificationPreferenceState.daysOfWeek.insert(action.dayOfWeek)
        } else {
            userPreferenceState.pushNotificationPreferenceState.daysOfWeek.remove(action.dayOfWeek)
        }
        return userPreferenceState
    }

    static func reduceUpdatePushNotificationTimeframe(action: UpdatePushNotificationTimeframe, state: UserPreferenceState) -> UserPreferenceState {
        return action.block(state)
    }

    static func reduceInsertNewPushTimeframe(action _: InsertNewPushTimeframe, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState.notificationTimeWindows.append(NotificationTimeWindow.defaultValue())
        return userPreferenceState
    }

    static func reduceDeleteTimeframe(action: DeleteTimeframe, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        userPreferenceState.pushNotificationPreferenceState.notificationTimeWindows.remove(at: action.index)
        return userPreferenceState
    }

    static func reduceAddPushNotificationRoute(action: AddPushNotificationRoute, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        var routeIds = userPreferenceState.pushNotificationPreferenceState.routeIds
        routeIds.append(action.route)
        userPreferenceState.pushNotificationPreferenceState.routeIds = routeIds
        return userPreferenceState
    }

    static func reduceRemovePushNotificationRoute(action: RemovePushNotificationRoute, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        var routeIds = userPreferenceState.pushNotificationPreferenceState.routeIds
        for route in action.routes {
            if let index = routeIds.indexOfRoute(route: route) {
                routeIds.remove(at: index)
            }
        }
        userPreferenceState.pushNotificationPreferenceState.routeIds = routeIds
        return userPreferenceState
    }

    static func reduceUpdatePushNotificationRoute(action: UpdatePushNotificationRoute, state: UserPreferenceState) -> UserPreferenceState {
        var userPreferenceState = state
        var routeIds = userPreferenceState.pushNotificationPreferenceState.routeIds
        if let index = routeIds.indexOfRoute(route: action.route) {
            routeIds[index] = action.route
        }
        userPreferenceState.pushNotificationPreferenceState.routeIds = routeIds
        return userPreferenceState
    }
}
