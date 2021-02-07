//
//  PriceService.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2021/01/31.
//

import Foundation

class PriceService {
    
    static func getCurrentTotalValue(_ success: @escaping () -> Void) -> Void {
        let currentAddr = UserStatus.shared.activeAddress
        if let addr = currentAddr {
            EthpolorerAPIService().getAddressInfo(addr, success)
        }
    }
    
    static func getGasPrice(_ success: @escaping () -> Void) -> Void {
        EtherscanAPIService().gastracker(success)
    }
}
