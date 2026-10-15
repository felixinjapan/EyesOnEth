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
        AF.request(host, parameters: param).validate(statusCode: 200..<300).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard CoinGeckoSimplePrice(simplePrice: json) != nil else {
                    EthereumStatus.shared.apiStatus.coinGecko = false
                    os_log("Invalid CoinGecko simple price response", log: .default, type: .error)
                    return
                }
                success(json)
                EthereumStatus.shared.apiStatus.coinGecko = true
            case .failure(let error):
                EthereumStatus.shared.apiStatus.coinGecko = false
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
    
    func getSimpleTokenPrice(_ success: @escaping (Data) -> Void, _ contracts: [String]) {
        var param = ["vs_currencies":"usd"]
        param["contract_addresses"] = contracts.joined(separator: ",")
        let host = "https://api.coingecko.com/api/v3/simple/token_price/ethereum"
        AF.request(host, parameters: param).validate(statusCode: 200..<300).responseData {
            response in
            switch response.result {
            case .success(let value):
                guard CoinGeckoSimpleTokenPrice.isValidResponse(value) else {
                    EthereumStatus.shared.apiStatus.coinGecko = false
                    os_log("Invalid CoinGecko token price response", log: .default, type: .error)
                    return
                }
                success(value)
                EthereumStatus.shared.apiStatus.coinGecko = true
            case .failure(let error):
                EthereumStatus.shared.apiStatus.coinGecko = false
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
