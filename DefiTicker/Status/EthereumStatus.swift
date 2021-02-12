//
//  EventMonitor.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import Cocoa

class EthereumStatus {
    open var estherscanGastracker: EtherscanGastracker?
    open var coinGeckoSimplePrice: CoinGeckoSimplePrice?
    static let shared:EthereumStatus = EthereumStatus()
}
