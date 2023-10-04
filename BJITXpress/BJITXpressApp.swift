//
//  BJITXpressApp.swift
//  BJITXpress
//
//  Created by BJIT-24 on 2/5/23.
//

import SwiftUI

//@main
//struct BJITXpressApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
////            ContentView()
////                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//
//            DemoInsertion()
//        }
//    }
//}

@main
struct BJITXpressApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject var viewModel = ViewSelector()


    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.loginState == .isChecking {
                    // Show a loading view or any other appropriate view while checking the login state
                    Text("Checking...")
                } else if viewModel.loginState == .isWeekend{
                    WeekendView()
                } else if viewModel.loginState == .isLoggedIn {
                    HomeView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else if viewModel.loginState == .isNotLoggedIn {
                    LoginView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }.onAppear{
                if PersistenceController.shared.getBusDbCount() < 5{
                    CloudKitHelper.shared.fetchBusDatafromCloud()
                }

            }
        }
    }
}

