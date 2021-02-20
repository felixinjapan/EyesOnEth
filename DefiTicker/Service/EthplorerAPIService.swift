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
            case .failure(let error):
                os_log("%@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}
