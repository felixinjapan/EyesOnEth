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
        let param = ["apiKey": "EK-aYF35-py3TUdh-ydqEm"]
        let host = "https://api.ethplorer.io/getAddressInfo/\(address)"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                success(json)
                EthereumStatus.shared.apiStatus.ethplorer = true
            case .failure(let error):
                EthereumStatus.shared.apiStatus.ethplorer = false
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
