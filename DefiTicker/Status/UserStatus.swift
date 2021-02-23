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
    
    func getTotalValue(_ missingPrice:Double = 0) -> String? {
        if let info = self.ethplorerGetAddressInfo {
            os_log("total value is: %G, missing : %G", log: .default, type: .debug, info.totalValue + missingPrice,missingPrice)
            let total = EthereumUtil.roundUpTotal(info.totalValue+missingPrice)
            return EthereumUtil.formattedWithSeparator(total)
        }
        return nil
    }
}
