//
//  PriceService.swift
//  
//
//  Created by Chon, Felix  on 2021/01/31.
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
    
    static func updateAddressInfoFromEthplorer(
        _ address: String,
        _ success: @escaping (JSON) -> Void,
        failure: @escaping (String) -> Void = { _ in }
    ) -> Void {
        EthplorerAPIService().getAddressInfo(address, success, failure: failure)
    }
    
    static func updateTokenPriceFromCoinGecko(
        _ contracts: [String],
        _ success: @escaping (Data) -> Void,
        failure: @escaping (String) -> Void = { _ in }
    ) -> Void {
        CoinGeckoAPIService().getSimpleTokenPrice(success, contracts, failure: failure)
    }
    
    static func getEthereumPrice(_ success: @escaping (JSON) -> Void) -> Void {
        CoinGeckoAPIService().getSimplePrice(success)
    }
    
    static func getGasPrice(_ success: @escaping () -> Void) -> Void {
        EtherscanAPIService().gastracker(success)
    }
}
