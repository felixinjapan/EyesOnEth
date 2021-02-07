//
//  EventMonitor.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import Cocoa

class EthereumStatus {
    open var estherscanGastracker: EtherscanGastracker?
    static let shared:EthereumStatus = EthereumStatus()
}
