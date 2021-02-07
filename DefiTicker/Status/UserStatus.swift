//
//  EventMonitor.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import Cocoa

class UserStatus {
    open var activeAddress: String?
    open var ethplorerGetAddressInfo: EthplorerGetAddressInfo?
    static let shared:UserStatus = UserStatus()
    
    func getTotalValue() -> String {
        if let info = self.ethplorerGetAddressInfo {
            print("total value is : \(info.totalValue)")
            return String(format: "%.0f", info.totalValue)
        }
        return "0"
    }
}
