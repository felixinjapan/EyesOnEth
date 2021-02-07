//
//  MainViewController.swift

//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

import AppKit

class RegisterService {

    static func reset(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Constants.ethAddressKey)
        NotificationCenter.default.post(name: .resetMenu, object: nil)
    }
    
    static func registerAddress(_ newAddr: String){
        let defaults = UserDefaults.standard
        if var addresses = defaults.stringArray(forKey: Constants.ethAddressKey) {
            addresses.append(newAddr)
            defaults.set(addresses, forKey: Constants.ethAddressKey)
        } else {
            let array = [newAddr]
            defaults.set(array, forKey: Constants.ethAddressKey)
        }
        // debug print eth addresses
        if let addresses = defaults.stringArray(forKey: Constants.ethAddressKey) {
            for eth in addresses {
                print("eth wallet : \(eth)")
            }
        }
        NotificationCenter.default.post(name: .addNewAddressMenu, object: newAddr)
    }
}

extension Notification.Name {
    static let addNewAddressMenu = Notification.Name("addNewAddressMenu")
    static let resetMenu = Notification.Name("resetMenu")
}
