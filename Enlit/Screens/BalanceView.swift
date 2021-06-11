//
//  BalanceView.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 18/12/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import SwiftUI
import Firebase

struct BalanceView: View {
    @State private var showMenu = false
    @State private var action = ""
    @State private var showCurrencyPicker = false
    @State private var showBankAccountPicker = false
    @State private var showPicker = false
    @State private var selectedCurrency = "US Dollars"
    @State private var selectedCurrencySymbol = "$"
    @State private var selectedBankName = ""
    @State private var balance = 0.0
    
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
                        Spacer()
                        Text("Your enlit credit")
                            .font(.system(size: 30))
                        Text("\(selectedCurrencySymbol) \(String(format: "%.2f", balance))")
                            .font(.system(size: 45, weight: .bold))
                        Button(selectedCurrency) {
                            self.showCurrencyPicker = true
                            showBankAccountPicker = false
                            showPicker = true
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button("Add founds") {
                                showBankAccountPicker = true
                                showCurrencyPicker = false
                                showPicker = true
                                
                                action = "add"
                            }
                            Spacer()
                            Button("Withdraw founds") {
                                showBankAccountPicker = true
                                showCurrencyPicker = false
                                showPicker = true
                                action = "withdraw"
                            }
                            Spacer()
                        }
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
                .navigationBarTitle("BALANCE")
                
                if showMenu {
                    GeometryReader { geometry in
                        Menu()
                    }.transition(.slide)
                    
                }
            }
            
        }
        .actionSheet(isPresented: $showPicker, content: {
            if(showCurrencyPicker) {
                return ActionSheet(
                    title: Text("Currency"),
                    message: Text("Select a currency"),
                    buttons: [
                        .cancel { print(self.showCurrencyPicker) },
                        .default(Text("US Dollars"), action: {
                            selectedCurrency = "US Dollars"
                            selectedCurrencySymbol = "$"
                        }),
                        .default(Text("Guatemalan Quetzal"), action: {
                            selectedCurrency = "Guatemalan Quetzal"
                            selectedCurrencySymbol = "GTQ"
                        }),
                        .default(Text("XRP"), action: {
                            selectedCurrency = "XRP"
                            selectedCurrencySymbol = "XRP"
                        }),
                    ]
                )
            }
            return ActionSheet(title: Text("Bank account"), message: Text("Pick a bank account"), buttons: [
                .cancel(),
                .default(Text("Banco Industrial - Monetarias"), action: {
                    selectedBankName = "Banco Industrial"
                    addFoundsAlert()
                })
            ])
            
        }).onAppear(perform: {
            calculateBalance()
        })
        
    }
    
    func calculateBalance() {
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
                    
                    self.balance = own?.reduce(0.0, { (carry, transaction) -> Double in
                        return carry + transaction.amount
                    }) ?? 0.0
                }
        }
        }
    }
    
    private func addFoundsAlert() {
        var title = "Add founds"
        var message = "Type the amount you want to add from \(selectedBankName)."
        var type = "add-founds"
        
        if(action == "withdraw") {
            title = "Withdraw founds"
            message = "Type the amount you want to add to \(selectedBankName)"
            type = "withdraw-founds"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { (action) in
                    
        }))
        alert.addAction(.init(title: "Confirm", style: .default, handler: { (action) in
            let firebase = FirebaseUtils()
            let textField = alert.textFields?.first
            firebase.storeTransfer(amount: Double(textField?.text ?? "0.0") ?? 0.0, type: type)
            calculateBalance()
            let confirmationAlert = UIAlertController(title: "Confirmation", message: "Your transfer has been sucessfull.", preferredStyle: .alert)
            confirmationAlert.addAction(.init(title: "Ok", style: .default))
            showAlert(alert: confirmationAlert)
        }))
        alert.addTextField { (field) in
        }
        
        showAlert(alert: alert)
    }
    
    
    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
