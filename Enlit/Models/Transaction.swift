//
//  Transaction.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 9/22/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import Foundation

struct Transaction: Codable, Identifiable {
    
    var amount: Double
    let id, date, from, reference, to, type, parent: String
}
