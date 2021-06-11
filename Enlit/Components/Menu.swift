//
//  Menu.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 17/12/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import SwiftUI

struct Menu: View {
    let modelData: [Weather] = [
        Weather(image: "arrow.up.arrow.down", temp: 21, city: "Pay & Transfer"),
        Weather(image: "person", temp: 21, city: "Profile"),
        Weather(image: "creditcard", temp: 18, city: "Recent Charges"),
        Weather(image: "dollarsign.circle", temp: 25, city: "Balance"),
        Weather(image: "power", temp: 25, city: "Logout"),
    ]
    
    var body: some View {
        VStack {
            Text("MENU")
                .foregroundColor(Color("MainBackground"))
                .padding(.top, 16)
                .font(.system(size: 20, weight: .heavy, design: .default))

            List(self.modelData) { weather in
                Button(action: {
                    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene

                    if let windowScenedelegate = scene?.delegate as? SceneDelegate {
                       let window = UIWindow(windowScene: scene!)
                       if(weather.image == "creditcard") {
                           window.rootViewController = UIHostingController(rootView: ChargesView())
                       } else if(weather.image == "person") {
                           window.rootViewController = UIHostingController(rootView: ProfileView())
                       } else if(weather.image == "dollarsign.circle") {
                           window.rootViewController = UIHostingController(rootView: BalanceView())
                       } else {
                           window.rootViewController = UIHostingController(rootView: ContentView())
                       }
                       windowScenedelegate.window = window
                       window.makeKeyAndVisible()
                    }
                }) {
                    HStack {
                        Image(systemName: weather.image)
                            .foregroundColor(Color("MainBackground"))
                            .font(.system(size: 22))
                            .frame(width: 50, height: nil, alignment: .center)
                        .navigationBarBackButtonHidden(true)
                        Text(weather.city)
                            .font(.system(size: 22, weight: .light, design: .default))
                        .navigationBarBackButtonHidden(true)
                    }.navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                }.padding(.vertical, 8)
                
            }
        }
        .background(Color(.white))
        .frame(width: 300, height: 500)
        .cornerRadius(40)
        .shadow(radius: 5)
        .offset(x: 50, y: 50)
        
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
