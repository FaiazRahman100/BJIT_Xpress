//
//  Persistence.swift
//  BJITXpress
//
//  Created by BJIT-24 on 2/5/23.
//

import CoreData
import CloudKit
struct PersistenceController {

    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    
    
    
    
    
    
    
    
    
    
    
    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "BJITXpress")
        container = NSPersistentContainer(name: "BJITXpress")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        
        
//        let storeDescription = container.persistentStoreDescriptions.first
//        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
//
//        // Set the CloudKit container and database to use
//        let cloudContainer = CKContainer(identifier: "iCloud.teamPT.bjitgroup.upskilldev")
//        let database = cloudContainer.publicCloudDatabase
//        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: cloudContainer.containerIdentifier!)
//        options.databaseScope = .public
//        storeDescription?.cloudKitContainerOptions = options
//
//
//
//
//
//
//
//
//
//
//
////
////        guard let description = container.persistentStoreDescriptions.first else {
////            fatalError("Unresolved error")
////        }
//
//
////        let storesURL = description.url!.deletingLastPathComponent()
////        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
////        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
////        description.cloudKitContainerOptions?.databaseScope = .public
//
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func fetchTravelRecords(for busNo: Int,on date: (Int,Int,Int)) -> [TravelRecord]{
        
        let startDate = Calendar.current.date(from: DateComponents(year: date.0, month: date.1, day: date.2))! // create a date object for May 17, 2023
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) // create a date object for May 18, 2023
        
        let predicate = NSPredicate(format: "(bookedTime >= %@) AND (bookedTime < %@) AND (busId == %lld)", startDate as NSDate, endDate! as NSDate, Int64(busNo))
        
        let request: NSFetchRequest<TravelRecord> = TravelRecord.fetchRequest()
        
        request.predicate = predicate
        do {
            let results = try container.viewContext.fetch(request)
            return results
        } catch let error as NSError {
            print("Error fetching SeatRecords: \(error.localizedDescription)")
            return []
        }
    }
    
    func getOccupiedSeatCount(for bus: Bus) -> Int{
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) // create a date object for May 18, 2023
        
        let busId = bus.busId
        print(busId)

        let predicate = NSPredicate(format: "(bookedTime >= %@) AND (bookedTime < %@) AND (busId == %lld)", startDate as NSDate, endDate! as NSDate, busId)
        
        let request: NSFetchRequest<TravelRecord> = TravelRecord.fetchRequest()

        request.predicate = predicate
        do {
            let results = try container.viewContext.fetch(request)
            print(results.count)
            return results.count
        } catch let error as NSError {
            print("Error fetching SeatRecords: \(error.localizedDescription)")
            return 0
        }
    }
    
    func fetchBusList() -> [Bus]{
        let request: NSFetchRequest<Bus> = Bus.fetchRequest()
        let predicate = NSPredicate(value: true)
        request.predicate = predicate
        do {
            let results = try container.viewContext.fetch(request)
            return results
        } catch let error as NSError {
            print("Error fetching SeatRecords: \(error.localizedDescription)")
            return []
        }
    }
    
    func getUserData() -> (String, String){
        
        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let predicate = NSPredicate(value: true)
        request.predicate = predicate
        var results: [Employee] = []
        do {
            results = try container.viewContext.fetch(request)
            return ((results.first?.employeeName)!, (results.first?.employeeId)!)
        } catch let error as NSError {
            print("Error fetching SeatRecords: \(error.localizedDescription)")
            results = []
            
            return ("Unknown","Unknown")
        }
        
    }
    
    func insertTravelHistory(busId: Int, seatOccupied: Int){
        
        let travelHistory = TravelRecord(context: container.viewContext)
        travelHistory.bookedTime = Date()
        (travelHistory.empName, travelHistory.empId) = PersistenceController.shared.getUserData()
//
//        print(selectedBus)
//        print(seatPositions[seatOccupied])
        travelHistory.busId = Int64(busId+1)
        travelHistory.seatCode = seatPositions[seatOccupied]
        try? container.viewContext.save()
//        dump(bus)
    }
    
    func isRegisterDataAvailable() -> Bool{
        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let predicate = NSPredicate(value: true)
        request.predicate = predicate
        var results: [Employee] = []
        do {
            results = try container.viewContext.fetch(request)
            //return results
        } catch let error as NSError {
            print("Error fetching SeatRecords: \(error.localizedDescription)")
            results = []
        }
        
        if results.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    func registerUser(name: String, id: String){
        let employeeData = Employee(context: container.viewContext)
        employeeData.employeeName = name
        employeeData.employeeId = id

        try? container.viewContext.save()

        print(":) registration Done")
//        saveDataToBusDB()
    }
    
    func insertBusData(busId: Int, startTime: Date, deptTime: Date, capacity: Int){
        
        let bus = Bus(context: container.viewContext)
        bus.busId = Int64(busId)
        bus.startTime = startTime
        bus.deptTime = deptTime
        bus.seatCapacity = Int64(capacity)
        
        try? container.viewContext.save()
        dump(bus)
    }
    
    func getBusDbCount() -> Int {
        let request: NSFetchRequest<Bus> = Bus.fetchRequest()
        
        let predicate = NSPredicate(value: true)
        request.predicate = predicate
        var results: [Bus] = []
        do {
            results = try container.viewContext.fetch(request)
            return results.count
        } catch let error as NSError {
            print("Error fetching SeatRecords: \(error.localizedDescription)")
            results = []
            return results.count
        }
        
        
    }
    
    func saveDataToBusDB(_ list: [BusRecord]){
        
        for i in 0..<list.count{
            insertBusData(busId: Int(list[i].busId), startTime: list[i].startTime, deptTime: list[i].deptTime, capacity: Int(list[i].seatCapacity))
        }
        
        
        
//        insertBusData(busId: 1, startTime: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!, deptTime: Calendar.current.date(bySettingHour: 7, minute: 10, second: 0, of: Date())!, capacity: 40)
//        insertBusData(busId: 2, startTime: Calendar.current.date(bySettingHour: 7, minute: 10, second: 0, of: Date())!, deptTime: Calendar.current.date(bySettingHour: 7, minute: 20, second: 0, of: Date())!, capacity: 40)
//        insertBusData(busId: 3, startTime: Calendar.current.date(bySettingHour: 7, minute: 20, second: 0, of: Date())!, deptTime: Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!, capacity: 40)
//        insertBusData(busId: 4, startTime: Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!, deptTime: Calendar.current.date(bySettingHour: 7, minute: 40, second: 0, of: Date())!, capacity: 40)
//        insertBusData(busId: 5, startTime: Calendar.current.date(bySettingHour: 7, minute: 40, second: 0, of: Date())!, deptTime: Calendar.current.date(bySettingHour: 7, minute: 50, second: 0, of: Date())!, capacity: 40)
    }
}
