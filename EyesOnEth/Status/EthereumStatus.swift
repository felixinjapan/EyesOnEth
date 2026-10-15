//
//  EventMonitor.swift
//  
//
//  Created by Chon, Felix  on 2020/11/18.
//

import Cocoa
import Combine

class EthereumStatus: ObservableObject {
    open var estherscanGastracker: EtherscanGastracker?
    open var coinGeckoSimplePrice: CoinGeckoSimplePrice?
    open var coinGeckoSimpleTokenPrice: CoinGeckoSimpleTokenPrice?
    static let shared:EthereumStatus = EthereumStatus()
    @Published open var apiStatus = ApiStatus()
}

struct ApiStatus {
    var coinGecko = true
    var ethplorer = true
    var etherscan = true
}
