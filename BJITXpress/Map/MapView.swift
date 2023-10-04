//
//  MapView.swift
//  BJITXpress
//
//  Created by BJIT on 11/5/23.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

struct MapViewScreen: View {
    @State private var destination = CLLocationCoordinate2D(latitude: 23.7974262, longitude: 90.4239699)
    
    var body: some View {
        MapView(destinationCoordinate: destination)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapViewScreen()
    }
}
