//
//  EventMonitor.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import Cocoa
import os

class UserStatus {
    open var numOfMenus:Int = 0
    open var activeAddress: String?
    open var ethplorerGetAddressInfo: EthplorerGetAddressInfo?
    static let shared:UserStatus = UserStatus()
    
    func getTotalValue() -> String? {
        if let info = self.ethplorerGetAddressInfo {
            os_log("total value is: %G", log: .default, type: .debug, info.totalValue)
            return String(format: "%.0f", info.totalValue)
        }
        return nil
    }
}
