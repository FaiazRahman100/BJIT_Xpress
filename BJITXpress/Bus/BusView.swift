//
//  BusView.swift
//  BJITXpress
//
//  Created by BJIT on 3/5/23.
//

import SwiftUI
import CoreData

struct BusView: View {
    @Environment(\.managedObjectContext) var context
    
    var busNo: Int
    var date: (Int,Int,Int)
    
    @State private var showingAlert = false
    @State var colors: [Color] = Array(repeating: .green, count: 50)
    @State var busData: [TravelData] = []
    
    @State var alertHead = ""
    @State var alertBody = ""
    @State var isLoading = false
    
    var body: some View {
        
        ZStack{
            Text("").navigationBarTitle("Bus View", displayMode: .inline)
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    
                    HStack{
                        VStack{
                            TitleText(title: "BJIT XPRESS", size: 32)
                            NavigationLink(destination: BusListView(busNo: busNo, busData: busData)) {
                                               Text("Click to show as List")
                                    .foregroundColor(.yellow)
                                           }
                        }
                        
                        // .padding(.trailing,40)
                        Image("steering-wheel")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 70)
                        
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                        
                        ForEach(Array(seatPositions.enumerated()), id: \.1) { index, item in
                            
                            Text(item)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 60 , height: 40, alignment: .center)
                                .background(colors[index])
                                .cornerRadius(10)
                                .onTapGesture {
                                    if index < busData.count{

                                        alertHead = "Booked by: \((busData[index].empName))"
                                        
                                        alertBody = "Id: \(busData[index].empId)\n Status: \(busData[index].status)\n Booked at: \(busData[index].bookedTime)"
                                        
                                        showingAlert = true
                                    }
                                    else{
                                        alertHead = "Seat No: \(seatPositions[index])"
                                        alertBody = "This Seat is Still Available to Book"
                                        showingAlert = true
                                    }
                                    
                                }
                            
                        }.padding(.bottom,5)
                    }.padding(.top, 70)
                        .background(.clear)
                        .onAppear(){
                            isLoading = true
                            CloudKitHelper.shared.populateItems(busNo: busNo, on: date){ record in
                                isLoading = false
                                busData = record
                                busData = busData.sorted{ $0.seatCode < $1.seatCode }
                                
                                for i in 0..<busData.count{
                                    if i > 50{return}
                                    colors[i] = .red
                                    
                                    if busData[i].empId == PersistenceController.shared.getUserData().1{
                                        colors[i] = .purple
                                    }
                                }
                            }
                            
                            //
                            
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text(alertHead), message: Text(alertBody), dismissButton: .default(Text("OK")))
                        }
                    
                    
                    
                }
            }
            
            if $isLoading.wrappedValue {
                Color.black.opacity(0.8)
                                .edgesIgnoringSafeArea(.all)

                            VStack {
                                Image("busStop")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 250)
                                Text("Loading...")
                                    .font(.system(size: 30, weight: .regular, design: .default))
                                    .foregroundColor(.black)
                                    .padding(.top, 8)
                            }
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(8)

                        }
        }
        
        
    }
    
//    func getBusData() -> [SeatData]{
//        return BusData
//    }
    
}
struct BusView_Previews: PreviewProvider {
    static var previews: some View {
        BusView(busNo: 2, date: (2023,5,11))
    }
}
