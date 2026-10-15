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
        guard let data = data, let result = Self.decodedPrices(from: data) else {
            os_log("error during the decoding process", log: .default, type: .error)
            self.array = [:]
            return
        }
        self.array = result
    }

    static func isValidResponse(_ data: Data) -> Bool {
        return decodedPrices(from: data) != nil
    }

    private static func decodedPrices(from data: Data) -> [String: PriceInfo]? {
        guard let result = try? JSONDecoder().decode([String: PriceInfo].self, from: data),
              !result.isEmpty else {
            return nil
        }
        return result
    }
}
