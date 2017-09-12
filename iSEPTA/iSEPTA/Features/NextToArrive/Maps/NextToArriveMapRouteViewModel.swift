//
//  NextToArriveMapRouteViewModel.swift
//  iSEPTA
//
//  Created by Mark Broski on 9/8/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
import ReSwift
import CoreLocation

class NextToArriveMapRouteViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = [NextToArriveTrip]

    weak var delegate: RouteDrawable! {
        didSet {
            subscribe()
            nextToArriveMapRouteViewModelErrorWatcher.delegate = delegate
        }
    }

    let nextToArriveMapRouteViewModelErrorWatcher = NextToArriveMapRouteViewModelErrorWatcher()

    func subscribe() {

        store.subscribe(self) {
            $0.select {
                $0.nextToArriveState.nextToArriveTrips
            }.skipRepeats { $0 == $1 }
        }
    }

    private func unsubscribe() {
        store.unsubscribe(self)
    }

    deinit {
        unsubscribe()
    }

    func newState(state: StoreSubscriberStateType) {
        let trips = state
        //        guard let firstTrip = trips.first, let delegate = delegate else { return }
        //        let routeIds = [firstTrip.startStop.routeId, firstTrip.endStop.routeId].flatMap { $0 }
        //        let uniqueRouteIds = Array(Set(routeIds))
        //        for routeId in uniqueRouteIds {
        //            delegate.drawRoute(routeId: routeId)
        //        }
        let startVehicles: [CLLocationCoordinate2D?] = trips.map { $0.vehicleLocation.firstLegLocation }
        let endVehicles: [CLLocationCoordinate2D?] = trips.map { $0.vehicleLocation.secondLegLocation }
        let allVehicles = startVehicles + endVehicles
        let nonOptionalVehicles: [CLLocationCoordinate2D] = allVehicles.flatMap { $0 }

        delegate.drawVehicleLocations(nonOptionalVehicles)
    }
}

class NextToArriveMapRouteViewModelErrorWatcher: StoreSubscriber {
    typealias StoreSubscriberStateType = NextToArriveUpdateStatus

    weak var delegate: RouteDrawable! {
        didSet {
            subscribe()
        }
    }

    func subscribe() {

        store.subscribe(self) {
            $0.select {
                $0.nextToArriveState.nextToArriveUpdateStatus
            }
        }
    }

    private func unsubscribe() {
        store.unsubscribe(self)
    }

    deinit {
        unsubscribe()
    }

    func newState(state: StoreSubscriberStateType) {

        if state == .dataLoadingError {
            if let routeId = store.state.nextToArriveState.scheduleState.scheduleRequest.selectedRoute?.routeId {
                delegate.drawRoute(routeId: routeId)
            }
        }
    }
}
