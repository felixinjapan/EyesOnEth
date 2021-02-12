//
//  MainViewController.swift

//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

import AppKit
import web3swift
import os

class RegisterService {
    
    static func reset(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Constants.ethAddressKey)
        NotificationCenter.default.post(name: .resetMenu, object: nil)
    }
    
    static func registerAddress(_ newAddr: String){

        guard let eAddr = EthereumAddress(newAddr) else {
            os_log("eth wallet is wrong", log: OSLog.default, type: .debug)
            return
        }
        
        let defaults = UserDefaults.standard
        if var addresses = defaults.stringArray(forKey: Constants.ethAddressKey) {
            if !addresses.contains(eAddr.address){
                addresses.append(eAddr.address)
                defaults.set(addresses, forKey: Constants.ethAddressKey)
                os_log("add new address: %@", log: OSLog.default, type: .debug, eAddr.address)
            } else {
                return
            }
        } else {
            let array = [newAddr]
            defaults.set(array, forKey: Constants.ethAddressKey)
            os_log("initialize addresses list with the address, %@", log: OSLog.default, type: .debug, eAddr.address)
        }
        NotificationCenter.default.post(name: .addNewAddressMenu, object: newAddr)
    }
}

extension Notification.Name {
    static let addNewAddressMenu = Notification.Name("addNewAddressMenu")
    static let resetMenu = Notification.Name("resetMenu")
}
