//
//  HomeViewModel.swift
//  BJITXpress
//
//  Created by BJIT on 10/5/23.
//

import Foundation
import SwiftUI
import Combine
import CoreData
import CloudKit

enum travelState{
    case walking
    case bicycle
    case driving
}

final class HomeViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var context
    @Published var statusLabel: String = "Select any traveling mode below"
    var countDownTime : String = "00:00:00"
    var timeRunning: Bool = false
    var timerX: Timer?
    var selectedTime = Date()
    @Published var countDownLabel: String = "00:00:00"
    @Published var countDownLabelColor: Color = Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1))
//    @Published var busState: String = "Seat availability of each bus will be diplayed here "
    @ObservedObject var location = Location()
    
    var busList : [Bus] = []
    var seatOccupied = 0
    var selectedBus = 0
    var seatGranted = false{
        didSet{
            if seatGranted{
                startTimer()
            }
        }
    }
    @Published var titleMsg: String = "How Much Time Do You Need to reach Notun Bazar ?"
    
    @Published var isLoading = false
    @Published var showingAlert = false
    private var cancellables = Set<AnyCancellable>()
    @Published var busSeatsOccupied = [0,0,0,0,0]
    
    init(){
        busList = PersistenceController.shared.fetchBusList().sorted { $0.busId < $1.busId }
        checkBusState()
    }
    
    func checkBusState(){
        
        checkBusSeatCounts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.checkBusState()
        }
    }
    
    func checkBusSeatCounts(){
        for i in 0..<5{
            CloudKitHelper.shared.getBusState(busId: Int64(i+1))
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] count in
                                self?.busSeatsOccupied[i] = count
                        }
                        .store(in: &cancellables)
        }
    }
    
    func showAlert(){
        guard UserDefaults.standard.data(forKey: CloudKitHelper.getTodayDateString()) != nil else{
            return
        }
        showingAlert = true
    }
    
    func updateReachStatus(){
        CloudKitHelper.shared.updateStatus()
        timerX?.invalidate()
        countDownTime = "00:00:00"
        countDownLabel = "00:00:00"
    }
    
    func checkIfAlreadyBooked(){
        guard UserDefaults.standard.data(forKey: CloudKitHelper.getTodayDateString()) != nil else{
            return
        }
        titleMsg = "Welcome back,\nHave you reached already?"
        statusLabel = "Click Here, if you reached Notun Bazar!"
    }


    func bookMySeatClicked(){
        
        guard UserDefaults.standard.data(forKey: CloudKitHelper.getTodayDateString()) == nil else{
            titleMsg = "You already booked once today"
            return
        }
        
        isLoading = true
        statusLabel = "Have You Reached? Click Here to update status."
        bookSeat(busNo: selectedBus)

    }
    
    
    func startTimer(){
        timerX?.invalidate()
        print(countDownTime)
        let timeComponents = countDownTime.split(separator: ":").compactMap { Int($0) }
        guard timeComponents.count == 3 else {
            print("Invalid time string: \(countDownTime)")
            return
        }
        let hours = timeComponents[0]
        let minutes = timeComponents[1]
        let seconds = timeComponents[2]
        
        // Convert the hours, minutes, and seconds to a TimeInterval in seconds
        let totalSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        
        // Start the countdown timer
        var remainingTime = totalSeconds
        
        timerX = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            
            
            // Decrement the remaining time by 1 second
            remainingTime -= 1
            
//            if remainingTime < 20 {
                countDownLabelColor = Int(remainingTime) % 2 == 0 ? Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)) : Color(#colorLiteral(red: 0.8151445985, green: 0.2807564139, blue: 0.3018198311, alpha: 1))
//            }
            
        
            
            if remainingTime <= 0 {
                // Stop the timer when the countdown is finished
                timerX?.invalidate()
                print("Countdown finished!")
                timeRunning = false
                countDownTime = "00:00:00"
                countDownLabel = "00:00:00"
                statusLabel = "Have you reached?"
                countDownLabelColor = Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1))
                showAlert()
                
            } else {
                // Format the remaining time as "hh:mm:ss" and print it
                let remainingHours = Int(remainingTime / 3600)
                let remainingMinutes = Int((remainingTime.truncatingRemainder(dividingBy: 3600)) / 60)
                let remainingSeconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
                let remainingTimeString = String(format: "%02d : %02d : %02d", remainingHours, remainingMinutes, remainingSeconds)
//                print(remainingTimeString)
                countDownLabel = remainingTimeString
            }
        }
    }
    

    func essentialTimeToReach(state: travelState){
        
        countDownTime = location.calculateDistanceToDestination(state: state)
        
        if state == .walking{
            statusLabel = "By walking, you need \(countDownTime) to reach"
        }else if state == .bicycle{
            statusLabel = "By bicycle, you need \(countDownTime) to reach"
        }else{
            statusLabel = "By driving, you need \(countDownTime) to reach"
        }
        countDownTime = location.calculateDistanceToDestination(state: state)
    }
    
    func bookSeat(busNo: Int){
        if busNo > 4 {
            selectedBus = 0
            isLoading = false
            return}
        
        DispatchQueue.main.async {
            self.titleMsg = "Sorry, No reservation possible right now."
        }
        

        let deptTime = getDeptTime(for: busList[busNo])
        print(deptTime)
        
        if canReachBeforeBusDept(deptTime){
            
            CloudKitHelper.shared.populateItems(for: busList[busNo]){[self] records in
                
                seatOccupied = records.count
                print(":) seat occu \(seatOccupied)")
                
                if seatOccupied < 50{
    //                busSeats[selectedBus] += 1

                    CloudKitHelper.shared.saveToCloud(busId: busNo, seatOccupied: seatOccupied)
                    
                    print(":) 1.Seat Alocated in bus \(busList[selectedBus].busId)")
                   
                    seatGranted = true
                    DispatchQueue.main.async {
                        self.titleMsg = "Seat booked in Bus: \(self.selectedBus+1), Seat: \(seatPositions[self.seatOccupied])"
                        self.isLoading = false
                    }
                    
                }else{
                    selectedBus += 1
                    bookSeat(busNo: selectedBus)
                }
            }
        }
        else{
            let secondDeptTime = (deptTime.0, (deptTime.1 + 2))
            
            CloudKitHelper.shared.populateItems(for: busList[busNo]){[self] records in
                
                seatOccupied = records.count
                
                if canReachBeforeBusDept(secondDeptTime) && seatOccupied < 15{

                    CloudKitHelper.shared.saveToCloud(busId: busNo, seatOccupied: seatOccupied)
                    
                    print(":) 2. Seat Allocated \(busList[busNo].busId)")
                    seatGranted = true
                    DispatchQueue.main.async {
                        self.titleMsg = "Seat booked in Bus: \(self.selectedBus+1), Seat: \(seatPositions[self.seatOccupied])"
                        self.isLoading = false
                    }
                } else {
                    selectedBus += 1
                    bookSeat(busNo: selectedBus)
                }
            }
        }
        
//        if seatGranted{
////            titleMsg = "Seat booked in Bus: \(selectedBus+1), Seat: \(seatPositions[seatOccupied])"
//            //titleMsg = "Seat booked in Bus: \(selectedBus+1), Seat: XX)"
//            print(":) Seat Booked")
//        }else {
//            titleMsg = "Sorry, No reservation possible right now."
//            isLoading = false
//        }
    }
    
    func getDeptTime(for bus: Bus) -> (Int,Int){
        
        let time = bus.deptTime
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time!)
            guard let hour = components.hour, let minute = components.minute else {
                // Handle the case where the input date is invalid
                return (0, 0)
            }
        
        return (hour, minute)
    }
    
    func canReachBeforeBusDept(_ deptTime: (Int,Int)) -> Bool{
        
        let (rHour, rMin) = getReachTime(countDownTime) //(7,16)
        let (dHour, dMin) = deptTime
        
        if rHour == dHour{
            if dMin >= rMin{
                return true
            }else{
                return false
            }
        }else if rHour > dHour{
            return false
        }else{
            return true
        }
    }
    
    
    func getReachTime(_ timeString: String) -> (Int, Int) {
        let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            formatter.timeZone = TimeZone.current
            let currentDate = Date()
            
            guard let timeInterval = formatter.date(from: timeString)?.timeIntervalSinceReferenceDate else {
                fatalError("Invalid time format")
            }
            
            let addedTimeInterval = currentDate.timeIntervalSinceReferenceDate + timeInterval
            let addedDate = Date(timeIntervalSinceReferenceDate: addedTimeInterval)
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let dateComponents = calendar.dateComponents([.hour, .minute], from: addedDate)
            
            let hours = dateComponents.hour!
            let minutes = dateComponents.minute!
            
            return ((hours+6), minutes)
    }

    
    func getYearMonthDayComponents() -> (Int, Int, Int) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else {
            return (0, 0, 0)
        }
        return (year, month, day)
    }
}
