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
    
    func getAddressInfo(
        _ address: String,
        _ success: @escaping (JSON) -> Void,
        failure: @escaping (String) -> Void = { _ in }
    ) {
        guard let key = RemoteConfigHandler.shared.getRemoteConfigValueString(.ethplorerApiKey),
              !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            EthereumStatus.shared.apiStatus.ethplorer = false
            failure("Ethplorer API key is missing. Check the app configuration and retry.")
            return
        }
        let param = ["apiKey": key]
        let host = "https://api.ethplorer.io/getAddressInfo/\(address)"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let errorCode = json["error"]["code"].intValue
                if errorCode > 0 {
                    os_log("Error during the ethplorer calls. error code: %d", log: .default, type: .error, errorCode)
                    EthereumStatus.shared.apiStatus.ethplorer = false
                    let message = json["error"]["message"].stringValue
                    let detail = message.isEmpty ? "Ethplorer returned error code \(errorCode)." : message
                    failure("Ethplorer request failed: \(detail)")
                } else {
                    success(json)
                    EthereumStatus.shared.apiStatus.ethplorer = true
                }
            case .failure(let error):
                EthereumStatus.shared.apiStatus.ethplorer = false
                os_log("%@", log: .default, type: .error, String(describing: error))
                failure("Couldn’t reach Ethplorer: \(error.localizedDescription)")
            }
        }
    }
}
