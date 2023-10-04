//
//  CloudKitHelper.swift
//  BJITXpress
//
//  Created by BJIT on 19/5/23.
//

import Foundation
import CloudKit
import Combine

class CloudKitHelper{
    @Published var title : String?
    static let shared = CloudKitHelper()
    var selfTravelData: CKRecord? = nil
    let container = CKContainer(identifier: "iCloud.teamPT.bjitgroup.upskilldev")
    
    init(){
        guard UserDefaults.standard.data(forKey: CloudKitHelper.getTodayDateString()) != nil else{
            return
        }
        selfTravelData = retrieveRecordFromUserDefaults(forKey: CloudKitHelper.getTodayDateString())
    }
    
    
    func getBusState(busId: Int64) -> AnyPublisher<Int, Never> {
        
        return Future<Int, Never> { promise in
            let startDate = Calendar.current.startOfDay(for: Date())
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
                                 
            var listOfRecord: [TravelData] = []
            
            let predicate: NSPredicate = NSPredicate(format: "(bookedTime >= %@) AND (bookedTime < %@ ) AND (busId == %lld)", startDate as NSDate, endDate! as NSDate, busId)
            
            let query = CKQuery(recordType: "TravelData", predicate: predicate)
            let database = self.container.publicCloudDatabase
            
            database.fetch(withQuery: query) { result in
                switch result {
                case .success(let result):
                    result.matchResults.compactMap { $0.1 }
                        .forEach {
                            switch $0 {
                            case .success(let record):
                                print(record)
                                if let travelData = TravelData.fromRecord(record) {
                                    listOfRecord.append(travelData)
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    
//                    let busCountString = self.extractBusCount(list: listOfRecord)
                    promise(.success(listOfRecord.count))
                    dump(listOfRecord)
                case .failure(let error):
//                    promise(.success("No Bus Details available right now"))
                    promise(.success(0))
                    print(error)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
//    private func extractBusCount(list : [TravelData]) -> String{
//        print(list.count)
//        var busCount = [0,0,0,0,0]
//        for i in 0..<list.count{
//            if list[i].busId == Int64(1){
//                busCount[0] += 1
//            }else if list[i].busId == Int64(2){
//                busCount[1] += 1
//            }else if list[i].busId == Int64(3){
//                busCount[2] += 1
//            }else if list[i].busId == Int64(4){
//                busCount[3] += 1
//            }else{
//                busCount[4] += 1
//            }
//        }
//
//        return "Bus1: \(busCount[0]), Bus2: \(busCount[1]), Bus3: \(busCount[2]), Bus4: \(busCount[3]), Bus5: \(busCount[4])"
//    }
//
    
    
    func checkUserInCloud(empID: String, completion: @escaping (Bool)->()){
        var employeeList : [EmployeeData] = []
        
        
        let predicate = NSPredicate(format: "id == %@", empID)
        
//        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "EmployeeData", predicate: predicate)
        let database = container.publicCloudDatabase
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap { $0.1 }
                    .forEach {
                        switch $0 {
                        case .success(let record):
                            print(record)
                            if let employee = EmployeeData.fromRecordUser(record) {
                                employeeList.append(employee)
                                
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                
//                let idExists = employeeList.contains { employee in
//                    employee.id == empID
//                }
                
                if employeeList.count >= 1{
                    completion(true)
                }else{
                    completion(false)
                }
//                if idExists{
//                    completion(true)
//                } else{
//                    completion(false)
//                }
                
//                PersistenceController.shared.saveDataToBusDB(busList)
//                dump(busList)

            case .failure(let error):
//                completion(listOfRecord)
                print(error)
            }
        }
    }
    
    func saveUserInCloud(name: String, id: String){
        let database = container.publicCloudDatabase
        let record = CKRecord(recordType: "EmployeeData")
        
        let empData = EmployeeData(name: name, id: id)
        
        record.setValuesForKeys(empData.toDictionary())
        
        // saving record in database
        
            database.save(record) { newRecord, error in
                if let error = error {
                    print(error)
                } else {
                    if let newRecord = newRecord {
                        print(":) Saved Data to cloud")
                        dump(newRecord)
                    }
                }
            }
    }
    
    
    
    
    
    
    // Function to retrieve a CKRecord from UserDefaults
    func retrieveRecordFromUserDefaults(forKey key: String) -> CKRecord? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                // Unarchive the data to CKRecord
                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
                unarchiver.requiresSecureCoding = true
                let record = unarchiver.decodeObject(of: CKRecord.self, forKey: NSKeyedArchiveRootObjectKey)
                unarchiver.finishDecoding()
                return record
            } catch {
                print("Failed to retrieve CKRecord from UserDefaults: \(error)")
            }
        }
        return nil
    }
    
    func saveDummyToCloud(busId: Int, date: Date){
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "TravelData")
        let empName = "DummyUser"
        let empId = "100100"
        
        let travelData = TravelData(bookedTime: date, busId: Int64(busId+1), empId: empId, empName: empName, seatCode: "A0", status: "On Way")
        
        record.setValuesForKeys(travelData.toDictionary())
        
        
            database.save(record) { newRecord, error in
                if let error = error {
                    print(error)
                } else {
                    if let newRecord = newRecord {
                        print(":) Saved Data to cloud")
                        dump(newRecord)
                    }
                }
            }
    }
    
    func saveToCloud(busId: Int, seatOccupied: Int){
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "TravelData")
        let (empName, empId) = PersistenceController.shared.getUserData()
        
        let travelData = TravelData(bookedTime: Date(), busId: Int64(busId+1), empId: empId, empName: empName, seatCode: seatPositions[seatOccupied], status: reachStatus.onWay.rawValue)
        
        record.setValuesForKeys(travelData.toDictionary())
        
        // saving record in database
        database.save(record) { [self] newRecord, error in
            if let error = error {
                print(error)
            } else {
                if let newRecord = newRecord {
                    print(":) Saved Data to cloud")
                    selfTravelData = newRecord
                    dump(newRecord)
                    saveRecordInUserDefaults(newRecord, forKey: CloudKitHelper.getTodayDateString())
                }
            }
        }
        
        
    }
    
    static func getTodayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let todayDate = Date()
        let dateString = dateFormatter.string(from: todayDate)
        return dateString
    }
    
    func updateStatus(){
//        func fixEmpIdInCloudKitRecord(recordID: CKRecord.ID, correctEmpId: String) {
        let database = container.publicCloudDatabase
        
        database.fetch(withRecordID: selfTravelData!.recordID) { (record, error) in
            if let error = error {
                print("Error fetching record: \(error.localizedDescription)")
            } else if let record = record {
                record["status"] = reachStatus.checkedIn.rawValue
                
                database.save(record) { (savedRecord, error) in
                    if let error = error {
                        print("Error updating record: \(error.localizedDescription)")
                    } else if let savedRecord = savedRecord {
                        print("Record updated successfully: \(savedRecord)")
                        self.title = "Status Updated to Checked In"
                        
                    }
                }
            }
        }
        
    }
    
    // Function to save a CKRecord in UserDefaults
    func saveRecordInUserDefaults(_ record: CKRecord, forKey key: String) {
        do {
            // Convert CKRecord to Data
            let data = try NSKeyedArchiver.archivedData(withRootObject: record, requiringSecureCoding: true)
            
            // Save the data in UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save CKRecord in UserDefaults: \(error)")
        }
    }
    
    func saveBusDataToCloud(){
        

        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "BusRecord")

        
        let busRecord = BusRecord(busId: Int64(3), deptTime:  Calendar.current.date(bySettingHour: 7, minute: 40, second: 0, of: Date())!, seatCapacity: Int64(50), startTime: Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!)
        
        record.setValuesForKeys(busRecord.toDictionary())
        
        // saving record in database
        database.save(record) { newRecord, error in
            if let error = error {
                print(error)
            } else {
                print(":) Saved Data to cloud")
                if let newRecord = newRecord {
                    print(":) Saved Data to cloud")
                    dump(newRecord)
                }
            }
        }
        
        
    }
    
    func fetchBusDatafromCloud(){
        
        var busList : [BusRecord] = []
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Busrecord", predicate: predicate)
        let database = container.publicCloudDatabase
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap { $0.1 }
                    .forEach {
                        switch $0 {
                        case .success(let record):
                            print(record)
                            if let busRecord = BusRecord.fromRecord2(record) {
                                busList.append(busRecord)
                                
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                PersistenceController.shared.saveDataToBusDB(busList)
                dump(busList)

            case .failure(let error):
//                completion(listOfRecord)
                print(error)
            }
        }
    }

    
    
    
    func populateItems(for bus: Bus? = nil , busNo: Int = -1, on date: (Int,Int,Int) = (0,0,0), completion: @escaping ([TravelData])->()) {
        
        var startDate = Calendar.current.startOfDay(for: Date())
        var endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        
        let busId = bus?.busId
                                        
                                            
        var listOfRecord: [TravelData] = []
        
        var predicate: NSPredicate = NSPredicate()
        if busNo > -1 {
            startDate = Calendar.current.date(from: DateComponents(year: date.0, month: date.1, day: date.2))!
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
            predicate = NSPredicate(format: "(bookedTime >= %@) AND (bookedTime < %@) AND (busId == %lld)", startDate as NSDate, endDate! as NSDate, Int64(busNo))
        }else{
            predicate = NSPredicate(format: "(bookedTime >= %@) AND (bookedTime < %@) AND (busId == %lld)", startDate as NSDate, endDate! as NSDate, busId!)
        }
        
        
        let query = CKQuery(recordType: "TravelData", predicate: predicate)
        
        let database = container.publicCloudDatabase
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap { $0.1 }
                    .forEach {
                        switch $0 {
                        case .success(let record):
                            print(record)
                            if let travelData = TravelData.fromRecord(record) {
                                listOfRecord.append(travelData)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                
                DispatchQueue.main.async {
                    completion(listOfRecord)
                }
                
                print(listOfRecord.count)
                dump(listOfRecord)
//                DispatchQueue.main.async {
//                    self.items = items.map(ItemViewModel.init)
//                }
            case .failure(let error):
                completion(listOfRecord)
                print(error)
            }
        }
        

    }
}



