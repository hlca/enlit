//
//  FirebaseUtils.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 9/22/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUtils {
    func getAllUsers(finished: @escaping ([User]) -> Void){
        let ref = Database.database().reference()

        ref.child("users")
            .observeSingleEvent(of: .value) { (snapshot) in

                let dictionary = snapshot.value as? NSDictionary
                
                let users = dictionary?.map({ (key, value) -> User in
                    let v = value as? NSDictionary
                    return User(
                        id: key as? String ?? "",
                        email: v?["email"] as? String ?? "",
                        referedBy: v?["refered_by"] as? String ?? "",
                        type: v?["type"] as? String ?? "user")
                }) ?? []
                
                finished(users)
            }
    }
    
    func getMyUser(finished: @escaping(User) -> Void) {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        getAllUsers { (users) in
            if let user = users.first(where: { (user) -> Bool in
                return user.id == deviceId
            }) {
                finished(user)
            }
        }
    }
    
    func storeTransfer(amount: Double, type: String = "add-founds") {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let ref = Database.database().reference()
        let uuid = UUID().uuidString
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if (type == "add-founds") {
            ref.child("transactions").child(uuid).setValue([
                "from": "",
                "to": deviceId,
                "amount": amount,
                "date": formatter.string(from: today),
                "type": type
            ])
        } else {
            ref.child("transactions").child(uuid).setValue([
                "to": "",
                "from": deviceId,
                "amount": amount,
                "date": formatter.string(from: today),
                "type": type
            ])
        }
    }
    
    func storeTransaction(toUser: User, amount: Double) {
        if(amount <= 0) {
            return
        }
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        
        let ref = Database.database().reference()
        let uuid = UUID().uuidString
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if(toUser.type == "commerce") {
            let feeUuid = UUID().uuidString
            ref.child("transactions").child(uuid).setValue([
                "from": deviceId,
                "to": toUser.id,
                "amount": amount*0.985,
                "date": formatter.string(from: today),
                "type": "transaction"
            ])
            ref.child("transactions").child(feeUuid).setValue([
                "from": deviceId,
                "to": "enlit",
                "amount": amount*0.015,
                "date": formatter.string(from: today),
                "type": "transaction-fee",
                "parent": uuid
            ])
            
        } else {
            let feeUuid = UUID().uuidString
            ref.child("transactions").child(uuid).setValue([
                "from": deviceId,
                "to": toUser.id,
                "amount": amount,
                "date": formatter.string(from: today),
                "type": "transaction"
            ])
            ref.child("transactions").child(feeUuid).setValue([
                "from": deviceId,
                "to": "enlit",
                "amount": amount*0.0002,
                "date": formatter.string(from: today),
                "type": "enlit-fee",
                "parent": uuid
            ])
        }
//        
//        getMyUser { (user) in
//            if user.referedBy != "" {
//                let comissionId = UUID().uuidString
//                
//                ref.child("transactions").child(comissionId).setValue([
//                    "from": deviceId,
//                    "to": user.referedBy,//comission
//                    "amount": amount * 0.0002,
//                    "reference": uuid,
//                    "date": formatter.string(from: today),
//                    "type": "comission"
//                ])
//            }
//        }
    }
}
