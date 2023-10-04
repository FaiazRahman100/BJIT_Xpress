//
//  HistoryView.swift
//  BJITXpress
//
//  Created by BJIT on 3/5/23.
//

import SwiftUI

struct HistoryView: View {
    
//    var goToNextView: Bool = false
    @State private var selectedDate = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {

        ZStack{
            Text("").navigationBarTitle("History", displayMode: .inline)
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                TitleText(title: "Search Bus History", size: 30)
     
                Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .preferredColorScheme(.dark)
                                .foregroundColor(.white)
                                .labelsHidden()
                    
                
                Text("Tap on the bus to see seat details")
                    .foregroundColor(.white)
                    .padding(.top,30)
               
                VStack{
                    HStack{
                        
                        VStack{
                            
                            NavigationLink(destination: {
                                
                                let date = dateFormatter.string(from: selectedDate)
                                let dateTuple = getYearMonthDayComponents(from: date)
                                BusView(busNo: 1, date: dateTuple)
                            }) {
                                Image("redBus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                    .frame(width: 100, height: 80)
                            }
                            Text("7:10 am")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                        }
                        VStack{
                            
                            NavigationLink(destination: {
                                let date = dateFormatter.string(from: selectedDate)
                                let dateTuple = getYearMonthDayComponents(from: date)
                                BusView(busNo: 2, date: dateTuple)
                            }) {
                                Image("redBus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 80)
                            }
                            Text("7:20 am")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                    HStack{
                        
                        VStack{
                            
                            NavigationLink(destination: {
                                let date = dateFormatter.string(from: selectedDate)
                                let dateTuple = getYearMonthDayComponents(from: date)
                                BusView(busNo: 3, date: dateTuple)
                            }) {
                                Image("redBus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                    .frame(width: 100, height: 80)
                            }
                            Text("7:30 am")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            
                        }
                        VStack{
                            
                            NavigationLink(destination: {
                                let date = dateFormatter.string(from: selectedDate)
                                let dateTuple = getYearMonthDayComponents(from: date)
                                BusView(busNo: 4, date: dateTuple)
                            }) {
                                Image("redBus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 80)
                            }
                            Text("7:40 am")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                        }
                        VStack{
                            
                            NavigationLink(destination: {
                                let date = dateFormatter.string(from: selectedDate)
                                let dateTuple = getYearMonthDayComponents(from: date)
                                BusView(busNo: 5, date: dateTuple)
                            }){
                                Image("redBus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 80)
                            }
                            Text("7:50 am")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                        }
                    }
                    Spacer()
                }
                


                   
                }
                
              
            }
        
            
            
            
        }
        
    func getYearMonthDayComponents(from dateString: String) -> (Int, Int, Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            // Handle the case where the input string is not in the correct format
            return (0, 0, 0)
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else {
            // Handle the case where the input date is invalid
            return (0, 0, 0)
        }
        return (year, month, day)
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

