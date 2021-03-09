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

class EtherscanAPIService {
    
    func gastracker(_ success: @escaping () -> Void) {
        guard let key = RemoteConfigHandler.shared.getRemoteConfigValueString(.etherscanKey) else {
            return
        }
        let param = ["apiKey": key, "action": "gasoracle"]
        let host = "https://api.etherscan.io/api?module=gastracker"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let etherStatus = EthereumStatus.shared
                etherStatus.estherscanGastracker = EtherscanGastracker(gastracker: json)
                success()
                EthereumStatus.shared.apiStatus.etherscan = true
            case .failure(let error):
                EthereumStatus.shared.apiStatus.etherscan = false
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
