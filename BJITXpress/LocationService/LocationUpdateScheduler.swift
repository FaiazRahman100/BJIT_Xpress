
//  LocationUpdateScheduler.swift
//  BJITXpress
//
//  Created by BJIT on 10/5/23.

import Foundation
import CoreLocation
import MapKit

final class LocationUpdateScheduler{
    private let location: Location
    private var transportationWay: MKDirectionsTransportType
    private var timer: Timer!
    
    init (location: Location, transportationWay: MKDirectionsTransportType? = .automobile) {
        self.location = location
        self.transportationWay = transportationWay!
        self.setTimer()
    }
    
    private func setTimer(){
        self.reSetTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else{return}
            self.location.claculateTimeNeededToArriveAtDestination(withTransportation: self.transportationWay)
        }
    }
    
    private func reSetTimer(){
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
    }
    
    func updateTransportationWayAndReschedule(transportationWay: MKDirectionsTransportType){
        self.transportationWay = transportationWay
        self.setTimer()
    }
}
