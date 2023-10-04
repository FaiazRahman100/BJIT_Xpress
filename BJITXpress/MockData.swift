//
//  MockData.swift
//  BJITXpress
//
//  Created by BJIT on 3/5/23.
//

import Foundation

enum BusX {
    case bus1
    case bus2
    case bus3
    case bus4
}

let seatPositions = ["A1", "A2", "A3", "A4",
                     "B1", "B2", "B3", "B4",
                     "C1", "C2", "C3", "C4",
                     "D1", "D2", "D3", "D4",
                     "E1", "E2", "E3", "E4",
                     "F1", "F2", "F3", "F4",
                     "G1", "G2", "G3", "G4",
                     "H1", "H2", "H3", "H4",
                     "I1", "I2", "I3", "I4",
                     "J1", "J2", "J3", "J4",
                     "K1", "K2", "K3", "K4",
                     "L1", "L2", "L3", "L4", "M1", "M2"]


struct SeatData: Hashable{
    var seatID: String
    var EmployeeName: String
    var EmployeeId: String
    var bookedTime: Int
    var reachStatus: Bool?
    var allocatedBus : BusX?
    var date: Int
}

let BusData : [SeatData] = [SeatData(seatID: "A1", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "A2", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "A3", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "A4", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "B1", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "B2", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "B3", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "B4", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "C1", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1),
                            SeatData(seatID: "C2", EmployeeName: "John Doe", EmployeeId: "22", bookedTime: 0, reachStatus: true, allocatedBus: .bus2, date: 1)]
