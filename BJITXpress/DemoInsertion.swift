//
//  DemoInsertion.swift
//  BJITXpress
//
//  Created by BJIT on 20/5/23.
//

import Foundation
import SwiftUI

struct DemoInsertion: View {
    
    @State private var selectedDate = Date()
    private let options = ["Bus 1", "Bus 2", "Bus 3", "Bus 4", "Bus 5"]
    @State private var selectedBus = 0
    @State private var selectedNumber = 1
    private let numberRange = 1...50
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                //                Text("Selected Date: \(selectedDate)")
                //                        .padding()
                Text("BJIT Xpress Dummy Data Insertion")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .padding()
                
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()
                Text("Selected Option: \(options[selectedBus])")
                    .padding()
                
                Picker("Select an option", selection: $selectedBus) {
                    ForEach(0..<options.count) { index in
                        Text(options[index])
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                HStack{
                    Text("Selected Number: \(selectedNumber)")
                        .padding()
                    
                    Picker("Select a number", selection: $selectedNumber) {
                        ForEach(numberRange, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding()
                }
                
                
                Button(action: {
                    
                    for _ in 0..<selectedNumber{
                        CloudKitHelper.shared.saveDummyToCloud(busId: selectedBus, date: selectedDate)
                    }

                    
                    
                }, label: {
                    Text("Insert to Cloud")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 60, alignment: .center)
                        .background(Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)))
                        .cornerRadius(10)
                })
                .padding()
                .contentShape(Rectangle())

                
                
                
                
                
                
                
            }
        }
        
    }
}

struct DemoInsertion_Previews: PreviewProvider {
    static var previews: some View {
        DemoInsertion()
    }
}
