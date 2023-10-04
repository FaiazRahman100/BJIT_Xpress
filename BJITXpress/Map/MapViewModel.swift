//
//  MapViewModel.swift
//  BJITXpress
//
//  Created by BJIT on 11/5/23.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine

//struct MapView: UIViewRepresentable {
//    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//    @State var destination: CLLocationCoordinate2D
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView(frame: UIScreen.main.bounds)
//        mapView.delegate = context.coordinator
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
//        return mapView
//    }
//
//    func updateUIView(_ mapView: MKMapView, context: Context) {
//        let currentLocation = mapView.userLocation.coordinate//CLLocationCoordinate2D(latitude: 23.8002547, longitude: 90.4629058) //mapView.userLocation.coordinate
//        let currentAnnotation = MKPointAnnotation()
//        currentAnnotation.coordinate = currentLocation
//        currentAnnotation.title = "You are here"
//
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.coordinate = destination
//        destinationAnnotation.title = "Destination"
//
//        mapView.addAnnotations([currentAnnotation, destinationAnnotation])
//
//        let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        mapView.setRegion(region, animated: true)
//    }
//
//    func makeCoordinator() -> MapViewCoordinator {
//        MapViewCoordinator()
//    }
//}
//
//class MapViewCoordinator: NSObject, MKMapViewDelegate {
//}



struct MapView: UIViewRepresentable {
//    @ObservedObject var locationManager = Location()
    let destinationCoordinate: CLLocationCoordinate2D
    
    @State private var cancellables = Set<AnyCancellable>()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        Location.shared.requestLocationPermission()
        
        Location.shared.$currentLocation
            .sink { currentLocation in
                if let currentLocation = currentLocation {
                    mapView.removeAnnotations(mapView.annotations)
                    
                    let currentAnnotation = MKPointAnnotation()
                    currentAnnotation.coordinate = currentLocation.coordinate
                    currentAnnotation.title = "Current Location"
                    mapView.addAnnotation(currentAnnotation)
                    
                    let destinationAnnotation = MKPointAnnotation()
                    destinationAnnotation.coordinate = self.destinationCoordinate
                    destinationAnnotation.title = "Destination"
                    mapView.addAnnotation(destinationAnnotation)
                    
                    let annotations = mapView.annotations
                    mapView.showAnnotations(annotations, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        // Optional: Add any additional map delegate methods as needed
    }
}
