//
//  ChargesView.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 9/6/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import SwiftUI
import Firebase

struct ChargeItem: Identifiable {
    var id = 0
}

struct ChargesView: View {
    @State private var showMenu = false
    @State private var value = 0.0
    @State private var descriptionText = ""
    
    @State var items: [Transaction] = []

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color("MainBackground"),
                    Color("LightBackground")
                    ]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing) {
                    List(items) { item  in
                        VStack(spacing: 4) {
                            HStack {
                                
                                Text(String(format: "$ %.2f", item.amount))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(item.amount > 0 ? Color(.black) : Color(.red))
                                    
                                Spacer()
                                Text(item.amount > 0 ? item.from : item.to)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(Color("MainBackground"))
                                    .font(.system(size: 18, weight: .bold))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    
                                
                            }
                            HStack {
                                Text(item.date)
                                    .foregroundColor(Color(.secondaryLabel))
                                Spacer()
                                Text(
                                    (item.type == "transaction" ? (item.amount > 0 ? "Deposit" : "Withdraw") :
                                        (item.type == "add-founds" ? "Added from bank" :
                                         (item.type == "withdraw-founds" ? "Added to bank" :
                                        (item.amount > 0 ? "Enlit reward" : "Enlit fee")))).capitalizingFirstLetter()
                                )
                            }
                            HStack {
                                Text("Captured via Payment App")
                                    .foregroundColor(Color(.tertiaryLabel))
                                Spacer()
                                Button("Receipt", action: {
                                    
                                    }).padding(16)
                                    .background(Color(.systemGreen))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                Button("Refund", action: {
                                    
                                    }).padding(16)
                                    .background(Color(.systemGray))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            }
                        }.padding(12)
                        .background(Color(.white))
                    }.background(Color(.white))
                    .cornerRadius(40)
                    .frame(maxHeight: .infinity)
                }
                .padding(.top, 40)
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
                .navigationBarTitle("CHARGES")
                if showMenu {
                    GeometryReader { geometry in
                        Menu()
                    }.transition(.slide)
                    
                }
            }
            
        }.onAppear(perform: {
            FirebaseUtils().getAllUsers { (users) in
            if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
                let ref = Database.database().reference()
                
                ref.child("transactions")
                    .observeSingleEvent(of: .value) { (snapshot) in

                        let dictionary = snapshot.value as? NSDictionary
                        
                        var own = dictionary?.filter({ (key, v) -> Bool in
                            let vv = v as? NSDictionary
                            return vv?["to"] as! String == deviceId || vv?["from"] as! String == deviceId
                        }).map({ (key, value) -> Transaction in
                            let v = value as? NSDictionary
                            
                            let from = v?["from"] as! String
                            print(from)
                            let fromUser = users.first { (user) -> Bool in
                                return user.id == from
                            }
                            var amount = v?["amount"] as! Double
                            if(fromUser?.id == deviceId) {
                                amount = amount * -1
                            }
                            let to = v?["to"] as! String
                            let toUser = users.first { (user) -> Bool in
                                return user.id == to
                            }
                            
                            
                            return Transaction(
                                amount: amount,
                                id: key as? String ?? "",
                                date: v?["date"] as! String,
                                from: fromUser?.email ?? "",
                                reference: v?["reference"] as? String ?? "",
                                to: toUser?.email ?? "",
                                type: v?["type"] as! String,
                                parent: v?["parent"] as? String ?? "")
                            
                        })
                        
                        let childs = own?.filter({ (t) -> Bool in
                            return t.type == "transaction-fee" && t.from != deviceId
                        })
                        
                        var visibleTransactions = own?.filter({ (t) -> Bool in
                            return t.type != "transaction-fee" 
                        })
                        
                        visibleTransactions?.sort(by: { (t1, t2) -> Bool in
                            return t1.date > t2.date
                        })
                        var transactions = [Transaction]()
                        visibleTransactions?.forEach({ (transaction) in
                            var childAmount = 0.0
                            childs?.forEach({ (child) in
                                if(child.parent == transaction.id) {
                                    childAmount = child.amount
                                }
                            })
                            print(transaction.type)
                            
                            
                            var t = transaction
                            t.amount = transaction.amount + childAmount
                            transactions.append(t)
                        })
                        
                        self.items = transactions
                    }
            }
            }
        })
        
    }
}

struct ChargesView_Previews: PreviewProvider {
    static var previews: some View {
        ChargesView()
    }
}
