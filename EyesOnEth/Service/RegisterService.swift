import AppKit
import web3swift
import os

enum RegisterAddressResult {
    case invalidAddress
    case duplicateAddress
    case success
}

class RegisterService {
    
    @discardableResult
    static func registerAddress(_ newAddr: String) -> RegisterAddressResult {

        guard let eAddr = EthereumAddress(newAddr) else {
            os_log("eth wallet is wrong", log: OSLog.default, type: .debug)
            return .invalidAddress
        }
        
        let prefs = UserStatus.shared.prefs
        if var addresses = prefs.ethAddresses {
            if addresses.contains(where: { EthereumAddress($0)?.address == eAddr.address }) {
                return .duplicateAddress
            }
            addresses.append(eAddr.address)
            prefs.ethAddresses = addresses
            os_log("add new address: %@", log: OSLog.default, type: .debug, eAddr.address)
        } else {
            let array = [eAddr.address]
            prefs.ethAddresses = array
            os_log("initialize addresses list with the address, %@", log: OSLog.default, type: .debug, eAddr.address)
        }
        NotificationCenter.default.post(name: .addNewAddressMenu, object: nil)
        return .success
    }
}
