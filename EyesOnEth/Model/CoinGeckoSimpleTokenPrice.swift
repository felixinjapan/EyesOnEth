//
//  Constants.swift
//  
//  https://www.coingecko.com/api/documentations/v3#/
//  Created by Chon, Felix  on 2021/01/04.
//
import Foundation
import Cocoa
import os
struct PriceInfo: Codable{
    let usd:Double
}

class CoinGeckoSimpleTokenPrice {
    let array:[String : PriceInfo]
    
    init(data: Data?){
        do {
            let result = try Bundle.main.decode([String:PriceInfo].self, from: data!)
            var temp = [String : PriceInfo]()
            for (key, value) in result {
                temp[key] = value
            }
            self.array = temp
        } catch {
            os_log("error during the decoding process %@", log: .default, type: .error, String(describing: error))
            self.array = [:]
        }
    }
}
