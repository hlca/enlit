//
//  Extensions.swift
//  Enlit
//
//  Created by Hsing-Li Chang on 9/22/20.
//  Copyright © 2020 Hsing-Li Chang. All rights reserved.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
