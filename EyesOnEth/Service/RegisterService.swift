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
                os_log("Added wallet address", log: OSLog.default, type: .debug)
            } else {
                return
            }
        } else {
            let array = [newAddr]
            prefs.ethAddresses = array
            os_log("Initialized wallet address list", log: OSLog.default, type: .debug)
        }
        NotificationCenter.default.post(name: .addNewAddressMenu, object: nil)
    }
}
