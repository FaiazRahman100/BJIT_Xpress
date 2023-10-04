//
//  ViewSelector.swift
//  BJITXpress
//
//  Created by BJIT on 15/5/23.
//

import Foundation

enum LoginState {
    case isChecking
    case isLoggedIn
    case isNotLoggedIn
    case isWeekend
}

class ViewSelector: ObservableObject {
    @Published var loginState: LoginState = .isChecking
    
    init() {
        
        let isWeekend = isSundayOrMonday()
        if isWeekend{
            loginState = .isWeekend
        }else {
            let isLoggedIn =
            PersistenceController.shared.isRegisterDataAvailable()
            loginState = isLoggedIn ? .isLoggedIn : .isNotLoggedIn
        }
    }
    
    func isSundayOrMonday() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.component(.weekday, from: today)
        
        return components == 0 || components == 1
    }

}
