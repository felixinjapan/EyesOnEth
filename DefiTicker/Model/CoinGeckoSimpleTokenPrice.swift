//
//  Constants.swift
//  DefiTicker
//  https://www.coingecko.com/api/documentations/v3#/
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//
import Foundation
import Cocoa
struct PriceInfo: Codable{
    let usd:Double
}

class CoinGeckoSimpleTokenPrice {
    let array:[String : PriceInfo]
    
    init(data: Data?){
        
        let result = Bundle.main.decode([String:PriceInfo].self, from: data!)
        var temp = [String : PriceInfo]()
        for (key, value) in result {
            temp[key] = value
        }
        self.array = temp
    }
}