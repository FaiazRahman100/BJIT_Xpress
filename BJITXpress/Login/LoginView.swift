//
//  LoginView.swift
//  BJITXpress
//
//  Created by BJIT on 3/5/23.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) var context
    @State private var name: String = ""
    @State private var employeeId: String = ""
//    @State private var shouldShowSecondView = false
    @State var isShowingHomeView = false
    @State private var showingAlert = false
    @State var isLoading = false
    var body: some View {
        NavigationView{
            
            ZStack{
                
                BackgroundView(colorA: Color(#colorLiteral(red: 0.8151446581, green: 0.2807564139, blue: 0.3018198311, alpha: 1)), colorB: Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)))
                
                VStack{
                    TitleText(title: "Register Your Identity", size: 32)
                        
                    Image("busLogin")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 250)
                    
                    VStack{
                        
                        TextField("Username", text: $name)
                            .padding()
                            .accentColor(.white)
                            .foregroundColor(.white)
                            .border(Color.white, width: 2)
                        TextField("Employee ID", text: $employeeId)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding()
                            .border(Color.white, width: 2)
                            
                        
                            
                        Button(action: {
                            if name != "" && employeeId != ""{
                                isLoading = true
                                CloudKitHelper.shared.checkUserInCloud(empID: employeeId){ idExist in
                                    
                                    if idExist{
                                        isLoading = false
                                        showingAlert = true
                                        
                                    } else{
                                        isLoading = false
                                        CloudKitHelper.shared.saveUserInCloud(name: name, id: employeeId)
                                        PersistenceController.shared.registerUser(name: name, id: employeeId)
                                        
                                        isShowingHomeView = true
                                    }
                                }
                                
                            }else{
                                print("Invalid")
                                return
                            }
                            
                        }, label: {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 60, alignment: .center)
                                .background(Color(#colorLiteral(red: 0.2078385055, green: 0.2078467906, blue: 0.3428357244, alpha: 1)))
                                .cornerRadius(10)
                        })
                        .padding()
                        .contentShape(Rectangle())
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || employeeId.trimmingCharacters(in: .whitespaces).isEmpty)
                            
                    }
                    .padding()
                    Spacer()
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
        .fullScreenCover(isPresented: $isShowingHomeView){
            HomeView()
        }
        .onAppear{
            print(":) \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Sorry!"), message: Text("Can not register with this data because this Employee already exist"), dismissButton: .destructive(Text("Okay")))
        }
        
        }       
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct BackgroundView: View {
    
    var colorA: Color
    var colorB: Color
    
    var body: some View {

        LinearGradient(gradient: Gradient(colors: [colorA,colorB]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct TitleText: View {
    
    var title : String
    var size : CGFloat
    
    
    var body: some View {
        Text(title)
            .font(.system(size: size, weight: .regular, design: .default))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(5)
    }
    
    
}
