//
//  ProfileView.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 9/7/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State private var showMenu = false
    @State private var fullName = "Tomás Álvarez"
    @State private var birthdate = "November 13, 1993"
    @State private var idNumber = "2315 15340 0101"
    @State private var idType = "DPI"
    @State private var accountNumber = "156 002465 3"

    let items: [ChargeItem] = [
    .init(),
    .init(),
    .init(),
    .init(),
    .init(),
    .init(),
    .init()
    ]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color("MainBackground"),
                    Color("LightBackground")
                    ]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing) {
                    VStack {
                        HStack {
                            Text("Full name")
                                .foregroundColor(Color("MainBackground"))
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            TextField("Full name", text: $fullName)
                                .multilineTextAlignment(.trailing)
                        }.padding(12)
                        .padding(.top, 15)
                        Divider()
                        HStack {
                            Text("Birthdate")
                                .foregroundColor(Color("MainBackground"))
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            TextField("Birthdate", text: $birthdate)
                                .multilineTextAlignment(.trailing)

                        }.padding(12)
                        Divider()
                        HStack {
                            Text("ID Number")
                                .foregroundColor(Color("MainBackground"))
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            TextField("ID Number", text: $idNumber)
                                .multilineTextAlignment(.trailing)

                        }.padding(12)
                        
                        Divider()
                        HStack {
                            Text("ID Type")
                                .foregroundColor(Color("MainBackground"))
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            TextField("ID Type", text: $idType)
                                .multilineTextAlignment(.trailing)

                        }.padding(12)
                        
                        Divider()
                        HStack {
                            Image("bi-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("Cuenta Monetaria BI")
                                        .font(.system(size: 18, weight: .semibold))
                                        .multilineTextAlignment(.trailing)
                                }
                                TextField("Account number", text: $accountNumber)
                                    .multilineTextAlignment(.trailing)
                                
                                HStack {
                                    Spacer()
                                    Text("View latest transactions")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color.blue)
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                        }.padding(12)
                        .padding(.bottom, 15)
                        Spacer()
                    }
                    .background(Color.white)
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
                )
                .navigationBarTitle("PROFILE")
                
                if showMenu {
                    GeometryReader { geometry in
                        Menu()
                    }.transition(.slide)
                    
                }
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
