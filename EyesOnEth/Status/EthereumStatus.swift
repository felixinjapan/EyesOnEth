//
//  EventMonitor.swift
//  
//
//  Created by Chon, Felix  on 2020/11/18.
//

import Cocoa

class EthereumStatus {
    open var estherscanGastracker: EtherscanGastracker?
    open var coinGeckoSimplePrice: CoinGeckoSimplePrice?
    open var coinGeckoSimpleTokenPrice: CoinGeckoSimpleTokenPrice?
    static let shared:EthereumStatus = EthereumStatus()
    open var apiStatus = ApiStatus()
}

struct ApiStatus {
    var coinGecko = true
    var ethplorer = true
    var etherscan = true
}
