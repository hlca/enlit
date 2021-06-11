//
//  LoginView.swift
//  TutoringSchoolAid
//
//  Created by Andrea Mendoza on 9/6/20.
//  Copyright © 2020 Andrea Mendoza. All rights reserved.
//
import SwiftUI
import WebKit
import Firebase
//import SwiftKeychainWrapper

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State var isLogged = false
   
    var body: some View {
        
        VStack() {
            Spacer()
                Image("main-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .padding(.bottom,60)
                    
                VStack(){
                    HStack {
                        Image(systemName: "envelope")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(.white)
                        
                        TextField("customer@email.com", text: $username)
                            .foregroundColor(Color.white)
                            .keyboardType(.emailAddress)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.white)
                        .padding(.bottom, 25)
                    HStack {
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(.white)
                        SecureField("password", text: $password)
                            .foregroundColor(Color.white)
                    }
                    Divider().frame(height: 1).background(Color.white)
                }.padding(.horizontal, 50)
                
                Button(action: login) {
                    Text("LOGIN")
                        .fontWeight(.bold)
                        .frame(width: 240, height: 40)
                        .padding(.vertical, 10)
                        .background(Color.yellow)
                        .foregroundColor(Color.white)
                        .cornerRadius(35.0)
                    
                }.padding(.horizontal).padding(.top, 35)
                
                Button(action: forgotPassword){
                    Text("Forgot password?")
                        .font(.callout)
                        .foregroundColor(.white)
                }.padding(.top,10)
            
            Spacer()
        }.background(LinearGradient(gradient: Gradient(colors: [Color("MainBackground"),
                                                                Color("GreenBackground")]),
                                                                startPoint: .center,
                                                                endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)

    }
    
    func login() {
        if(username != "") {
            let ref = Database.database().reference()
            
            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            
                ref.child("users").child(deviceId).child("email").setValue(username.lowercased())
            }
        }
        
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let windowScenedelegate = scene?.delegate as? SceneDelegate {
           let window = UIWindow(windowScene: scene!)
            window.rootViewController = UIHostingController(rootView: ContentView())
           windowScenedelegate.window = window
           window.makeKeyAndVisible()
        }
    }
    
    func forgotPassword() {
       //TODO
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

