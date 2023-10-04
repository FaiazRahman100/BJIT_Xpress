//
//  BusListView.swift
//  BJITXpress
//
//  Created by BJIT on 5/5/23.
//

import SwiftUI
import CoreData

struct BusListView: View {

    var busNo: Int
//    var date: (Int,Int,Int)
    var busData: [TravelData]
//    @State var busData: [TravelData] = []
    
    var body: some View {
        ZStack{
            Text("").navigationBarTitle("Bus List View", displayMode: .inline)
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Bus: 0\(busNo)")
                    .font(.system(size: 25, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .frame(width: 200)

                List(busData, id: \.seatCode) { item in
                    
                    HStack{
                        VStack(alignment: .leading) {
                            Text("Name: \(item.empName)")
                            Text("ID: \(item.empId)")
    //                        Text("Booked Time: \(formatDate(item.bookedTime))")
                            Text("Bus No: \(item.busId)")
                            Text("Seat Code: \(item.seatCode)")
                            Text("Status: \(item.status)")
                        }
                        
                        Spacer()
                        
                        Text(item.seatCode)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 60, height: 60, alignment: .center)
                            .background(Gradient(colors: [Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1))] ))
                            .cornerRadius(10)
                    }
                    

                }
                
                Spacer()

            }
            
        }
    }
}

//struct BusListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BusListView(busNo: 1, date: (2023,5,11))
//    }
//}
