//
//  Constants.swift
//  DefiTicker
//  https://ethplorer.io/
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//
import Foundation
import SwiftyJSON

struct Eth {
    var _balance:Double
    var _price:Double
    var _priceDiff:String
    var _priceDiff7days:String
    var _marketCap:String
    var _value:Double
}

struct Token {
    var _contractAddr:String
    var _balance:Double
    var _name:String
    var _price:Double
    var _priceDiff:String
    var _priceDiff7days:String
    var _marketCap:String
    var _value:Double
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
        self._ethModel = Eth(_balance: ethBalance, _price: ethPrice, _priceDiff: ethPriceDiff, _priceDiff7days: ethPriceDiff7days, _marketCap: ethMarketCap, _value: value)
        
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
            let token = Token(_contractAddr: contractAddr, _balance: balance, _name: name, _price: price, _priceDiff: priceDiff, _priceDiff7days: priceDiff7days, _marketCap: marketCap, _value: value)
            self._tokens.append(token)
        }
    }
    
}
