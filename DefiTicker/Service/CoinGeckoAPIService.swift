//
//  EthplorerAPIService.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2021/01/31.
//

import Foundation
import Alamofire
import SwiftyJSON
import os

class CoinGeckoAPIService {
    
    func getSimplePrice(_ success: @escaping () -> Void) {
        let param = ["ids": "ethereum", "vs_currencies":"usd","include_24hr_change":"true","include_24hr_vol":"true"]
        let host = "https://api.coingecko.com/api/v3/simple/price"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                EthereumStatus.shared.coinGeckoSimplePrice = CoinGeckoSimplePrice(simplePrice: json)
                success()
            case .failure(let error):
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
