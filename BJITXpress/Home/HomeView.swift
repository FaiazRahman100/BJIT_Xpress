//
//  HomeView.swift
//  BJITXpress
//
//  Created by BJIT on 3/5/23.
//

import SwiftUI
import CoreData


struct HomeView: View {

    @StateObject var viewModel = HomeViewModel()
    
    @State private var isWalking: Bool = false
    @State private var isCycling: Bool = false
    @State private var isDriving: Bool = false
    @State private var disableAllView: Bool = true
    
    @State private var fiveMinsSelected: Bool = false
    @State private var tenMinsSelected: Bool = false
    @State private var fifteenMinsSelected: Bool = false
    @State private var twentyMinsSelected: Bool = false

    @State private var selectedTime = Date()
    @State private var seatOccupied = 0
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var isLoading = false
    
    @State private var alertHead = ""
    @State private var alertBody = ""
//    @State private var showingAlert = false
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Text("").navigationBarTitle("Home", displayMode:  .inline)
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)),]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        HStack{
                            TitleText(title: $viewModel.titleMsg.wrappedValue, size: 20)
                                .border(.yellow, width: 0.5)
                                .padding()
                            
                            NavigationLink(destination: {
                                HistoryView()
                            }){
                                Image(systemName: "clock")
                                    .renderingMode(.original)
                                    .resizable()
                                    .tint(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                
                            }.padding(.trailing,20)
                        }
   
                        Text($viewModel.countDownLabel.wrappedValue)
                            .padding()
                            .font(.system(size: 30, weight: .regular, design: .default))
                            .background($viewModel.countDownLabelColor.wrappedValue)
                            .animation(.easeInOut(duration: 0.2))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .padding(5)
                        
                        Button($viewModel.statusLabel.wrappedValue) {
                            viewModel.showAlert()
                        }
                        .padding()
                        .foregroundColor(.green)
                        .cornerRadius(10)
                        
                        HStack{
                            
                            
                            NavigationLink(destination: {
                                MapViewScreen()
                            }){
                                Image("map2")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            }
                            
                            Button(action: {
                                
                                viewModel.essentialTimeToReach(state: .walking)
                                disableOtherSelection()
                                isWalking.toggle()
                            }) {
                                MapButtonImage(imageName: "figure.walk.diamond", state: $isWalking)
                            }
                            
                            Button(action: {
                                viewModel.essentialTimeToReach(state: .bicycle)
                                disableOtherSelection()
                                isCycling.toggle()
                            }){
                                MapButtonImage(imageName: "bicycle", state: $isCycling)
                            }
                            
                            Button(action: {
                                viewModel.essentialTimeToReach(state: .driving)
                                disableOtherSelection()
                                isDriving.toggle()
                            }) {
                                MapButtonImage(imageName: "box.truck", state: $isDriving)
                            }
                            
                        }
                        
                        Text("Set Manually")
                            .font(.system(size: 22, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .padding()
                        
                        HStack{
                            Button(action: {
                                viewModel.countDownTime = "00:05:00"
                                viewModel.statusLabel = "Can you reach in 5 mins ?"
                                disableOtherSelection()
                                fiveMinsSelected.toggle()
                            }) {
                                ManualSuggestedTime(text: "5 \nmins", state: $fiveMinsSelected)
                            }
                            .frame(width: 80, height: 80)
                            
                            Button(action: {
                                viewModel.countDownTime = "00:10:00"
                                viewModel.statusLabel = "Can you reach in 10 mins ?"
                                disableOtherSelection()
                                tenMinsSelected.toggle()
                            }) {
                                ManualSuggestedTime(text: "10 \nmins", state: $tenMinsSelected)
                            }
                            .frame(width: 80, height: 80)
                            
                            Button(action: {
                                viewModel.countDownTime = "00:15:00"
                                viewModel.statusLabel = "Can you reach in 15 mins ?"
                                disableOtherSelection()
                                fifteenMinsSelected.toggle()
                                
                            }) {
                                ManualSuggestedTime(text: "15 \nmins", state: $fifteenMinsSelected)
                            }
                            .frame(width: 80, height: 80)
                            
                            Button(action: {
                                viewModel.countDownTime = "00:20:00"
                                viewModel.statusLabel = "Can you reach in 20 mins ?"
                                disableOtherSelection()
                                
                                twentyMinsSelected.toggle()
                            }) {
                                ManualSuggestedTime(text: "20 \nmins", state: $twentyMinsSelected)
                            }
                            .frame(width: 80, height: 80)
                        }
                        
                        
                        HStack{
                            Text("Or, Select from picker")
                            DatePicker("", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                                .preferredColorScheme(.dark)
                                .foregroundColor(.white)
                                .onChange(of: selectedTime, perform: { value in
                                    
                                    viewModel.countDownTime = remainingTime
                                    viewModel.statusLabel = "Thats mean you are reaching in \(remainingTime) ?"
                                    disableOtherSelection()
                                    
                                    print("Selected time changed to \(value)")
                                })
                        }.padding()
                        
                        Button(action: {
                            viewModel.bookMySeatClicked()
                        }) {
                            Text("Book My Seat")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 60, alignment: .center)
                                .background(Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)))
                                .cornerRadius(10)
                        }
                        .padding()
                        .contentShape(Rectangle())
                        
                        HStack{
                            
                            VStack{
                                
                                NavigationLink(destination: {
                                    
                                    BusView(busNo: 1, date: viewModel.getYearMonthDayComponents())
                                }) {
                                    Image("redBus")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                        .frame(width: 60 , height: 60)
                                }
                                Text("7:10 am")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                            }
                            VStack{
                                
                                NavigationLink(destination: {
                                    BusView(busNo: 2, date: viewModel.getYearMonthDayComponents())
                                }) {
                                    Image("redBus")
                                        .renderingMode(.original)
                                        .resizable()
                                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60 , height: 60)
                                }
                                Text("7:20 am")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                            }
                            
                            VStack{
                                
                                NavigationLink(destination: {
                                    BusView(busNo: 3, date: viewModel.getYearMonthDayComponents())
                                }) {
                                    Image("redBus")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                        .frame(width: 60 , height: 60)
                                }
                                Text("7:30 am")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                
                            }
                            VStack{
                                
                                NavigationLink(destination: {
                                    BusView(busNo: 4, date: viewModel.getYearMonthDayComponents())
                                }) {
                                    Image("redBus")
                                        .renderingMode(.original)
                                        .resizable()
                                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60 , height: 60)
                                }
                                Text("7:40 am")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                            }
                            VStack{
                                
                                NavigationLink(destination: {
                                    BusView(busNo: 5, date: viewModel.getYearMonthDayComponents())
                                }){
                                    Image("redBus")
                                        .renderingMode(.original)
                                        .resizable()
                                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60 , height: 60)
                                }
                                Text("7:50 am")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                            }
                        }
                        
                        Text("Bus1: \($viewModel.busSeatsOccupied[0].wrappedValue) , Bus2: \($viewModel.busSeatsOccupied[1].wrappedValue), Bus3: \($viewModel.busSeatsOccupied[2].wrappedValue), Bus4: \($viewModel.busSeatsOccupied[3].wrappedValue), Bus5: \($viewModel.busSeatsOccupied[4].wrappedValue)")
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .padding()
                    }
                }.refreshable {
                    viewModel.checkBusSeatCounts()
                }
                
                if $viewModel.isLoading.wrappedValue {
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
        .onAppear{
            viewModel.checkIfAlreadyBooked()
            print(":) \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])")

        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Have you reached Notun Bazar ?"),
                  message: Text("Please Update the Reach Status"),
                  primaryButton: .default(Text("YES"),
                                          action: {
                viewModel.updateReachStatus()
                print(":) Status Updated to Checked In")
            }),
                  secondaryButton: .destructive(Text("NO"))
                  
                  
            )
        }
    }

    
    func disableOtherSelection(){
        isWalking = false
        isCycling = false
        isDriving = false
        
        fiveMinsSelected = false
        tenMinsSelected = false
        fifteenMinsSelected = false
        twentyMinsSelected = false
    }

    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var remainingTime: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date(), to: selectedTime)

        guard let hour = components.hour, let minute = components.minute, let second = components.second else {
            return "00 :00 :00"
        }

        var hourStr = hour < 10 ? "0\(hour)" : "\(hour)"
        var minuteStr = minute < 10 ? "0\(minute)" : "\(minute)"
        var secondStr = second < 10 ? "0\(second)" : "\(second)"
        
        if selectedTime.compare(Date()) == .orderedAscending {
                // If selectedTime is in the past, set remaining time to zero
                hourStr = "00"
                minuteStr = "00"
                secondStr = "00"
            }
        return "\(hourStr):\(minuteStr):\(secondStr)"
    }
    
}

struct MapButtonImage: View {
    var imageName : String
    @Binding var state: Bool
    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.original)
            .resizable()
            .tint(state ? .green : .white)
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
    }
}

struct ManualSuggestedTime: View {
    var text : String
    @Binding var state: Bool
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(width: 80, height: 80)
            .background(state ? Color(#colorLiteral(red: 1, green: 0.4207846522, blue: 0.2251979709, alpha: 0.7 )) : .gray )
            .clipShape(Circle())
            .shadow(color: .black, radius: 30, x: 5, y: 5)
    }
}



struct BusState: View {
    
    var image : String
    var time: String
    var body: some View {
        VStack{
            
            Button(action: {
                
            }) {
                Image("redBus")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: .gray, radius: 10, x: 0, y: 0)
                    .frame(width: 60, height: 60)
            }
            Text("\(time) am")
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
