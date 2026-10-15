//
//  EthplorerAPIService.swift
//  
//
//  Created by Chon, Felix  on 2021/01/31.
//

import Foundation
import Alamofire
import SwiftyJSON
import os

class CoinGeckoAPIService {
    
    func getSimplePrice(_ success: @escaping (JSON) -> Void) {
        let param = ["ids": "ethereum", "vs_currencies":"usd","include_24hr_change":"true","include_24hr_vol":"true"]
        let host = "https://api.coingecko.com/api/v3/simple/price"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                success(json)
                EthereumStatus.shared.apiStatus.coinGecko = true
            case .failure(let error):
                EthereumStatus.shared.apiStatus.coinGecko = false
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
    
    /// Decodes token prices away from the main queue and delivers the result on the main queue.
    func getSimpleTokenPrice(_ success: @escaping (CoinGeckoSimpleTokenPrice) -> Void, _ contracts: [String]) {
        var param = ["vs_currencies":"usd"]
        param["contract_addresses"] = contracts.joined(separator: ",")
        let host = "https://api.coingecko.com/api/v3/simple/token_price/ethereum"
        AF.request(host, parameters: param).responseData(queue: DispatchQueue.global(qos: .userInitiated)) {
            response in
            switch response.result {
            case .success(let value):
                let tokenPriceInfo = CoinGeckoSimpleTokenPrice(data: value)
                DispatchQueue.main.async {
                    success(tokenPriceInfo)
                    EthereumStatus.shared.apiStatus.coinGecko = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    EthereumStatus.shared.apiStatus.coinGecko = false
                }
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
