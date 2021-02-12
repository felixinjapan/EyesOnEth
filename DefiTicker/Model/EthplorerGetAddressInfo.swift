//
//  Constants.swift
//  DefiTicker
//  https://ethplorer.io/
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//
import Foundation
import SwiftyJSON

struct Eth {
    var balance:Double
    var price:Double
    var priceDiff:String
    var priceDiff7days:String
    var marketCap:String
    var value:Double
}

struct Token {
    var contractAddr:String
    var balance:Double
    var name:String
    var price:Double
    var priceDiff:String
    var priceDiff7days:String
    var marketCap:String
    var value:Double
}

class EthplorerGetAddressInfo {
    
    private var _ethModel:Eth!
    private var _tokens = [Token]()
    
    var ethModel:Eth {
        if _ethModel == nil {
            _ethModel = nil
        }
        return _ethModel
    }
    
    var tokens:[Token] {
        return _tokens
    }
    
    var totalValue: Double = 0
    
    init(getAddressInfo: JSON) {
        
        let eth = getAddressInfo["ETH"]
        let ethBalance = eth["balance"].doubleValue
        let ethPrice = eth["price"]["rate"].doubleValue
        let ethPriceDiff = eth["price"]["diff"].stringValue
        let ethPriceDiff7days = eth["price"]["diff7d"].stringValue
        let ethMarketCap = eth["price"]["marketCapUsd"].stringValue
        // unit of ethBalance is eth
        let value = (ethPrice * ethBalance)
        self.totalValue += value
        self._ethModel = Eth(balance: ethBalance, price: ethPrice, priceDiff: ethPriceDiff, priceDiff7days: ethPriceDiff7days, marketCap: ethMarketCap, value: value)
        
        let tokenList = getAddressInfo["tokens"].arrayValue
        
        tokenList.forEach { token in
            let tokenInfo = token["tokenInfo"]
            let balance = token["balance"].doubleValue
            let contractAddr = tokenInfo["address"].stringValue
            let name = tokenInfo["name"].stringValue
            let price = tokenInfo["price"]["rate"].doubleValue
            let priceDiff = tokenInfo["price"]["diff"].stringValue
            let priceDiff7days = tokenInfo["price"]["diff7d"].stringValue
            let marketCap = tokenInfo["price"]["marketCapUsd"].stringValue
            // unit of ethBalance is wei
            // 1000000000000000000 wei = 1 eth
            let value = (price * balance) / 1000000000000000000
            self.totalValue += value
            let token = Token(contractAddr: contractAddr, balance: balance, name: name, price: price, priceDiff: priceDiff, priceDiff7days: priceDiff7days, marketCap: marketCap, value: value)
            self._tokens.append(token)
        }
    }
    
}
