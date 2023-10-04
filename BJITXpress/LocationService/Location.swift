//
//  Location.swift
//  BJITXpress
//
//  Created by BJIT on 10/5/23.
//

import Foundation
import CoreLocation
import MapKit
import Combine

final class Location: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = Location()
    let locationManager = CLLocationManager()
    private let destinationLocation: CLLocationCoordinate2D
    @Published var estimatedTravelTime: TimeInterval!
    @Published var estimatedDistance: CLLocationDistance!
    @Published var currentLocation: CLLocation?
    override init() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        destinationLocation = CLLocationCoordinate2D(latitude: 23.7974262, longitude: 90.4239699)
//        startUpdatingLocation()
    }

    private func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }

    private func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }

    private func getDerectionRequest(withTransportation: MKDirectionsTransportType) -> MKDirections.Request?{
        guard let currentLocation = locationManager.location else{return nil}
        let currentPlaceMark = MKPlacemark(coordinate: currentLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)

        let currentMapItem = MKMapItem(placemark: currentPlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let directionsRequest = MKDirections.Request()
        directionsRequest.source = currentMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = withTransportation
        return directionsRequest
    }

    @objc func claculateTimeNeededToArriveAtDestination(withTransportation: MKDirectionsTransportType){
        guard let directionsRequest = getDerectionRequest(withTransportation: withTransportation) else{return}
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.estimatedTravelTime = route.expectedTravelTime
                print(":) \(self.estimatedTravelTime)")
            }
        }
    }

    func calculateDistanceToDestination(state: travelState) -> String {

        guard let currentLocation = locationManager.location else {
            print("Unable to get current location")
            return "00:00:00"
        }

        let currentCoordinate = currentLocation.coordinate

//        let currentCoordinate = CLLocationCoordinate2D(latitude: 23.8002547, longitude: 90.4629058)

        let currentLocationAsCL = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        let destinationLocationAsCL = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)

        estimatedDistance = currentLocationAsCL.distance(from: destinationLocationAsCL)

        if state == .walking {
            return formatTime(fromSeconds: estimatedDistance/0.7)
        }else if state == .bicycle{
            return formatTime(fromSeconds: estimatedDistance/3)
        }else{
           return  formatTime(fromSeconds: estimatedDistance/8.9)
        }

    }


    func formatTime(fromSeconds seconds: Double) -> String {
        let hours = Int(seconds / 3600)
        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location manager errors
    }

}


//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    
//    @Published var currentLocation: CLLocation?
//    @Published var estimatedTravelTime: TimeInterval!
//    @Published var estimatedDistance: CLLocationDistance!
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    func requestLocationPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    func startUpdatingLocation() {
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            startUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        currentLocation = location
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Handle location manager errors
//    }
//    
//    func calculateDistanceToDestination(state: travelState) -> String {
//
//        guard let currentLocation = locationManager.location else {
//            print("Unable to get current location")
//            return "00:00:00"
//        }
//
//        let currentCoordinate = currentLocation.coordinate
//
////        let currentCoordinate = CLLocationCoordinate2D(latitude: 23.8002547, longitude: 90.4629058)
//        let destinationLocation = CLLocationCoordinate2D(latitude: 23.7974262, longitude: 90.4239699)
//        let currentLocationAsCL = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
//        let destinationLocationAsCL = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
//
//        estimatedDistance = currentLocationAsCL.distance(from: destinationLocationAsCL)
//
//        if state == .walking {
//            return formatTime(fromSeconds: estimatedDistance/0.7)
//        }else if state == .bicycle{
//            return formatTime(fromSeconds: estimatedDistance/3)
//        }else{
//           return  formatTime(fromSeconds: estimatedDistance/8.9)
//        }
//
//    }
//    
//    func formatTime(fromSeconds seconds: Double) -> String {
//        let hours = Int(seconds / 3600)
//        let minutes = Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60)
//        let seconds = Int(seconds.truncatingRemainder(dividingBy: 60))
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//    
//}
