//
//  Constants.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//

import Foundation

struct Constants {
    
    static let ethAddressKey = "ethAddressKey"
    static let activeAddress = "activeAddress"
    
    static let externalServiceUrl: Dictionary = ["etherscan": "https://etherscan.io/address/%@", "ethplorer": "https://ethplorer.io/address/%@"]
}

enum ExternalSite: String {
    case etherscan = "etherscan"
    case ethplorer = "ethplorer"
}
