//
//  Constants.swift
//  
//  https://www.coingecko.com/api/documentations/v3#/
//  Created by Chon, Felix  on 2021/01/04.
//
import Foundation
import SwiftyJSON

class CoinGeckoSimplePrice {
    
    private var _ethPriceInUSD:Double
    private var _eth24hrChange:Double
    private var _eth24hrVolume:Double
    private var _ethMarketCap:Double?
    
    var ethPriceInUSD:Double {
        return _ethPriceInUSD
    }
    
    var eth24hrChange:Double {
        return _eth24hrChange
    }
    
    var eth24hrVolume:Double {
        return _eth24hrVolume
    }
    
    var ethMarketCap:Double? {
        return _ethMarketCap
    }
    
    init?(simplePrice: JSON) {
        let eth = simplePrice["ethereum"]
        guard eth.type == .dictionary,
              let ethPriceInUSD = eth["usd"].double,
              let eth24hrChange = eth["usd_24h_change"].double,
              let eth24hrVolume = eth["usd_24h_vol"].double else {
            return nil
        }

        self._ethPriceInUSD = ethPriceInUSD
        self._eth24hrChange = eth24hrChange
        self._eth24hrVolume = eth24hrVolume
        self._ethMarketCap = eth["usd_market_cap"].double
    }
    
}
