//
//  ContentView.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 9/3/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import SwiftUI

struct Weather: Identifiable {
    var id = UUID()
    var image: String
    var temp: Int
    var city: String
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentation
    @State var users = [User]()
    @State var selectedUser = ""
    let message: String
    let value: Double

    var body: some View {
        VStack {
            Text("Transfer confirmation")
                .font(.title)
                .padding(.top, 24)
            Text(message)
                .font(.subheadline)
                .padding(.vertical, 12)
            
            Text("Select the user who will receive the money")
                .padding(.bottom, 12)
                
            List (users) { user in
                Button(user.email) {
                    self.selectedUser = user.id
                }.font(selectedUser == user.id ? .headline : .body)
                    
            }
            HStack {
                Button("Confirm") {
                    if let selectedUser = self.users
                        .first { (user) -> Bool in
                            return user.id == self.selectedUser
                        } {
                    FirebaseUtils().storeTransaction(toUser: selectedUser, amount: self.value)
                    }
                    self.presentation.wrappedValue.dismiss()
                }
                Button("Cancel") {
                    self.presentation.wrappedValue.dismiss()
                }.font(.headline)
            }
        }.onAppear {
            FirebaseUtils().getAllUsers { (users) in
                self.users = users.filter({ (user) -> Bool in
                    return user.id != UIDevice.current.identifierForVendor?.uuidString
                })
            }
        }
    }
}

struct ContentView: View {
    @State private var showMenu = false
    @State private var showModal = false
    @State private var value = 0.0
    @State private var descriptionText = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color("MainBackground"),
                    Color("LightBackground")
                    ]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing) {
                    Spacer()
                    Text(String(format: "$ %.2f", locale: .current, self.value))
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .padding(18)
                    
                    Text("Transfer fee: " + String(format: "$ %.2f", locale: .current,  self.value*0.0002))
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .padding(18)
                    Spacer()
                    TextField("Description", text: $descriptionText)
                        .padding(18)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    VStack {
                        HStack {
                            Button("1", action: {
                                self.value = self.value * 10 + 0.01
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                                
                            Button("2", action: {
                                self.value = self.value * 10 + 0.02
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                            Button("3", action: {
                                self.value = self.value * 10 + 0.03
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)

                        }.padding(.top, 16)
                        HStack {
                            Button("4", action: {
                                self.value = self.value * 10 + 0.04
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                            Button("5", action: {
                                self.value = self.value * 10 + 0.05
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                            Button("6", action: {
                                self.value = self.value * 10 + 0.06
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                        }
                        HStack {
                            Button("7", action: {
                                self.value = self.value * 10 + 0.07
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                            Button("8", action: {
                                self.value = self.value * 10 + 0.08
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                            Button("9", action: {
                                self.value = self.value * 10 + 0.09
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                        }
                        
                        HStack {
                            Button("clear", action: {
                                
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .font(.system(size: 32, weight: .bold))
                            Button("0", action: {
                                self.value = self.value * 10
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                                .padding(20)
                            Button("<--", action: {
                                print((self.value * 10).rounded(.down) / 100)
                                self.value = (self.value * 10).rounded(.down) / 100
                            }).frame(maxWidth: .infinity)
                                .foregroundColor(Color(.secondaryLabel))
                                .font(.system(size: 32, weight: .bold))
                        }
                    }.background(Color(.white))
                    .cornerRadius(40)
                    
                }
                .navigationBarItems(leading:
                    Button(action: {
                        print("Edit button was tapped")

                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                    }
                , trailing:
                    Button(action: {
                        self.showModal = true
                    }) {
                        Text("Transfer")
                            .foregroundColor(.white)
                    }
                )
                if showMenu {
                    GeometryReader { geometry in
                        Menu()
                    }.transition(.slide)
                    
                }
            }
            
        }
        .sheet(isPresented: $showModal, onDismiss: {
                    
        }) {
            ModalView(
                message: "You are about to transfer \(String(format: "$ %.2f", locale: .current, value))",
                value: value
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
