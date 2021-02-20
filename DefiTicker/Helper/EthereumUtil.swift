//
//  EventMonitor.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import Cocoa
import AppKit
import SwiftUI

class EthereumUtil: NSWindowController {
   static func getAbbreviateAddress(_ ethAddr: String) -> String {
        let prefix = ethAddr.prefix(6)
        let suffix = ethAddr.suffix(4)
        return "\(prefix)...\(suffix)"
    }
    
    static func roundUpTotal(_ doubleValue: Double) -> String {
        return String(format: "%.0f", doubleValue)
    }
}
