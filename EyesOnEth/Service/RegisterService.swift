//
//  MainViewController.swift

//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

import AppKit
import web3swift
import os

class RegisterService {
    
    static func registerAddress(_ newAddr: String){

        guard let eAddr = EthereumAddress(newAddr) else {
            os_log("eth wallet is wrong", log: OSLog.default, type: .debug)
            return
        }
        
        let prefs = UserStatus.shared.prefs
        if var addresses = prefs.ethAddresses {
            if !addresses.contains(eAddr.address){
                addresses.append(eAddr.address)
                prefs.ethAddresses = addresses
                os_log("add new address: %@", log: OSLog.default, type: .debug, eAddr.address)
            } else {
                return
            }
        } else {
            let array = [newAddr]
            prefs.ethAddresses = array
            os_log("initialize addresses list with the address, %@", log: OSLog.default, type: .debug, eAddr.address)
        }
        NotificationCenter.default.post(name: .addNewAddressMenu, object: nil)
    }
}
