//
//  WeekendView.swift
//  BJITXpress
//
//  Created by BJIT on 3/5/23.
//

import SwiftUI

struct WeekendView: View {
    
    @State var todaysDate: String = "Sunday"
    var body: some View {
        ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            VStack{
                
                Text("Have a Chill Pill")
                    .font(.system(size: 40, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top,50)
                Text("because its")
                    .font(.system(size: 25, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                Text(todaysDate)
                    .font(.system(size: 70, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image("sleeping2")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 250)
                
                Text("No Office Today")
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                Spacer()
            }
        }.onAppear{
            todaysDate = getTodaysDay()
        }
    }
    
    func getTodaysDay() -> String{
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let todayString = dateFormatter.string(from: Date())
            return todayString
    }
}

struct WeekendView_Previews: PreviewProvider {
    static var previews: some View {
        WeekendView()
    }
}
