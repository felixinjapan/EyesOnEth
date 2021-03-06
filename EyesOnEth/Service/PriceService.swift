//
//  PriceService.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2021/01/31.
//

import Foundation
import SwiftyJSON

class PriceService {
    
    static func updateActiveAddressPrice(_ success: @escaping (JSON) -> Void) -> Void {
        let currentAddr = UserStatus.shared.activeAddress
        if let addr = currentAddr {
            EthplorerAPIService().getAddressInfo(addr, success)
        }
    }
    
    static func updateAddressInfoFromEthplorer(_ address:String, _ success: @escaping (JSON) -> Void) -> Void {
        EthplorerAPIService().getAddressInfo(address, success)
    }
    
    static func updateTokenPriceFromCoinGecko(_ contracts:[String], _ success: @escaping (Data) -> Void) -> Void {
        CoinGeckoAPIService().getSimpleTokenPrice(success, contracts)
    }
    
    static func getEthereumPrice(_ success: @escaping (JSON) -> Void) -> Void {
        CoinGeckoAPIService().getSimplePrice(success)
    }
    
    static func getGasPrice(_ success: @escaping () -> Void) -> Void {
        EtherscanAPIService().gastracker(success)
    }
}
