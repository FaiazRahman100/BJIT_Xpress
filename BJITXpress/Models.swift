//
//  Models.swift
//  BJITXpress
//
//  Created by BJIT on 22/5/23.
//

import Foundation
import CloudKit

enum reachStatus: String{
    case onWay = "On Way"
    case checkedIn = "Checked In"
}

struct TravelData{
    var bookedTime: Date
    var busId: Int64
    var empId: String
    var empName: String
    var seatCode: String
    var status: String
    
    init(bookedTime: Date, busId: Int64, empId: String, empName: String, seatCode: String, status: String){
        self.bookedTime = bookedTime
        self.busId = busId
        self.empId = empId
        self.empName = empName
        self.seatCode = seatCode
        self.status = status
    }
    
    
    func toDictionary() -> [String: Any] {
        return ["bookedTime": bookedTime, "busId": busId, "empId": empId, "empName": empName, "seatCode": seatCode, "status": status]
    }
    
    static func fromRecord(_ record: CKRecord) -> TravelData? {
        guard let bookedTime = record.value(forKey: "bookedTime") as? Date, let busId = record.value(forKey: "busId") as? Int64, let empId = record.value(forKey: "empId") as? String, let empName = record.value(forKey: "empName") as? String , let seatCode = record.value(forKey: "seatCode") as? String, let status = record.value(forKey: "status") as? String else {
            return nil
        }
        
        return TravelData(bookedTime: bookedTime, busId: busId, empId: empId , empName: empName, seatCode: seatCode, status: status)

    }
    
}

struct BusRecord{
    var busId: Int64
    var deptTime: Date
    var seatCapacity: Int64
    var startTime: Date
    
    init(busId: Int64, deptTime: Date, seatCapacity: Int64, startTime: Date){
        self.busId = busId
        self.deptTime = deptTime
        self.seatCapacity = seatCapacity
        self.startTime = startTime
    }
    
    
    func toDictionary() -> [String: Any] {
        return ["busId": busId, "deptTime": deptTime, "seatCapacity": seatCapacity, "startTime": startTime]
    }
    
    static func fromRecord2(_ record: CKRecord) -> BusRecord? {
        guard let busId = record.value(forKey: "busId") as? Int64, let deptTime = record.value(forKey: "deptTime") as? Date,let seatCapacity = record.value(forKey: "seatCapacity") as? Int64, let startTime = record.value(forKey: "startTime") as? Date
        else {
            return nil
        }
        
        return BusRecord(busId: busId, deptTime: deptTime, seatCapacity: seatCapacity, startTime: startTime)

    }
    
}

struct EmployeeData{
    var name : String
    var id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    func toDictionary() -> [String: Any] {
        return ["name": name , "id": id]
    }
    
    static func fromRecordUser(_ record: CKRecord) -> EmployeeData?{
        guard let name = record.value(forKey: "name") as? String, let id = record.value(forKey: "id") as? String else {
            return nil
        }
        
        return EmployeeData(name: name, id: id)
    }
    
}
