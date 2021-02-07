//
//  EthplorerAPIService.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2021/01/31.
//

import Foundation
import Alamofire
import SwiftyJSON

class EthpolorerAPIService {
    
    func getAddressInfo(_ address:String, _ success: @escaping () -> Void) {
        let param = ["apiKey": "EK-aYF35-py3TUdh-ydqEm"]
        let host = "https://api.ethplorer.io/getAddressInfo/\(address)"
        AF.request(host, parameters: param).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                UserStatus.shared.ethplorerGetAddressInfo = EthplorerGetAddressInfo(getAddressInfo: json)
                success()
            case .failure(let error):
                print(error)
            }
        }
    }
}
