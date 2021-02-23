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
    
    static func roundUpTotal(_ doubleValue: Double) -> Double {
        return round(doubleValue)
    }
    
    static func tokenPriceForDetailView(_ doubleValue: Double) -> String {
        if doubleValue >= 1.0 {
            let rt = Double(round(100*doubleValue)/100)
            return formattedWithSeparator(rt) ?? "N/A"
        } else {
            let rt = Double(round(1000000*doubleValue)/1000000)
            return String(format: "%f", rt)
        }
    }
    
    static func tokenPriceDiffString(_ priceDiff: Float) -> String {
        if priceDiff == 0 {
            return ""
        }
        if(priceDiff > 0){
            return "+" + String(format: "%.2f", priceDiff) + "%"
        } else {
            return String(format: "%.2f", priceDiff) + "%"
        }
    }
    
    static func formattedWithSeparator(_ double: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(for: double)
    }
    
    static func getExternalLink(target:String, type:ExternalSite) -> URL? {
        if target.isEmpty {
            return nil
        }
        if let format = Constants.externalServiceUrl[type.rawValue] {
            let link = String(format: format, target)
            
            if let url = URL(string: link) {
                return url
            }
        }
        return nil
    }
}
