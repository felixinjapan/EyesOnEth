//
//  PriceService.swift
//  
//
//  Created by Chon, Felix  on 2021/01/31.
//

import Foundation
import SwiftyJSON

class PriceService {
    
    static func updateActiveAddressPrice(_ success: @escaping (String, JSON) -> Void) -> Void {
        guard let address = UserStatus.shared.activeAddress else { return }
        EthplorerAPIService().getAddressInfo(address) { json in
            DispatchQueue.main.async {
                guard UserStatus.shared.activeAddress == address else { return }
                success(address, json)
            }
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
