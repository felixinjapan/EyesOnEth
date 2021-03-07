//
//  Prefs.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 7/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import Foundation

class Prefs: ObservableObject {
    
    @Published var ethAddresses: [String]? = UserDefaults.standard.stringArray(forKey: Constants.ethAddressKey) ?? nil {
        didSet {
            UserDefaults.standard.set(self.ethAddresses, forKey: Constants.ethAddressKey)
        }
    }
}
