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

class EthplorerAPIService {
    
    func getAddressInfo(_ address:String, _ success: @escaping (JSON) -> Void) {
        guard let key = RemoteConfigHandler.shared.getRemoteConfigValueString(.ethplorerApiKey) else {
            return
        }
        let param = ["apiKey": key]
        let host = "https://api.ethplorer.io/getAddressInfo/\(address)"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                EthereumStatus.shared.apiStatus.ethplorer = true
                let json = JSON(value)
                let err = json["error"]["code"].intValue
                if err > 0 {
                    os_log("Error during the ethplorer calls. error code: %d", log: .default, type: .error, err)
                    EthereumStatus.shared.apiStatus.ethplorer = false
                } else {
                    success(json)
                    EthereumStatus.shared.apiStatus.ethplorer = true
                }
            case .failure(let error):
                EthereumStatus.shared.apiStatus.ethplorer = false
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
