//
//  Constants.swift
//  DefiTicker
//  https://ethplorer.io/
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//
import Foundation
import SwiftyJSON

struct Eth:Identifiable, Codable{
    var id = UUID()
    
    var balance:Double
    var price:Double
    var priceDiff:String
    var priceDiff7days:String
    var marketCap:String
    var value:Double
}

struct Token:Identifiable, Codable {
    var id = UUID()
    
    var contractAddr:String
    var symbol:String
    var balance:Double
    var name:String
    var price:Double
    var priceDiff:String
    var priceDiff7days:String
    var marketCapUsd:String
    var value:Double
    var decimals:Double
}

class EthplorerGetAddressInfo {
    
    private var _ethModel:Eth!
    private var _tokens = [Token]()
    private var _contractAddressList = [String]()
    private var _priceFalseList = [String: Double]()

    
    var ethModel:Eth {
        if _ethModel == nil {
            _ethModel = nil
        }
        return _ethModel
    }
    
    var tokens:[Token] {
        return _tokens
    }
    
    var contractAddressList: [String] {
        return _contractAddressList
    }
    
    var priceFalseKV: [String: Double] {
        return _priceFalseList
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
            let decimals = tokenInfo["decimals"].doubleValue
            let balance = token["balance"].doubleValue / pow(10, decimals)
            let contractAddr = tokenInfo["address"].stringValue
            let name = tokenInfo["name"].stringValue
            let price = tokenInfo["price"]["rate"].doubleValue
            if price == 0 {
                _priceFalseList[contractAddr] = balance
            }
            let priceDiff = tokenInfo["price"]["diff"].stringValue
            let priceDiff7days = tokenInfo["price"]["diff7d"].stringValue
            let marketCap = tokenInfo["price"]["marketCapUsd"].stringValue
            let symbol = tokenInfo["symbol"].stringValue
            // unit of ethBalance is wei
            let value = (price * balance)
            self.totalValue += value
            let token = Token(contractAddr: contractAddr, symbol : symbol, balance: balance, name: name, price: price, priceDiff: priceDiff, priceDiff7days: priceDiff7days, marketCapUsd: marketCap, value: value, decimals: decimals)
            self._tokens.append(token)
            self._contractAddressList.append(contractAddr)
        }
    }
    
}
