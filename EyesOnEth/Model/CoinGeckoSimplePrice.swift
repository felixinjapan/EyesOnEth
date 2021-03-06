//
//  Constants.swift
//  DefiTicker
//  https://www.coingecko.com/api/documentations/v3#/
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//
import Foundation
import SwiftyJSON

class CoinGeckoSimplePrice {
    
    private var _ethPriceInUSD:Double
    private var _eth24hrChange:Double
    private var _eth24hrVolume:Double
    private var _ethMarketCap:Double
    
    var ethPriceInUSD:Double {
        return _ethPriceInUSD
    }
    
    var eth24hrChange:Double {
        return _eth24hrChange
    }
    
    var eth24hrVolume:Double {
        return _eth24hrVolume
    }
    
    var ethMarketCap:Double {
        return _ethMarketCap
    }
    
    init(simplePrice: JSON) {
        let eth = simplePrice["ethereum"]
        self._ethPriceInUSD = eth["usd"].doubleValue
        self._eth24hrChange = eth["usd_24h_change"].doubleValue
        self._eth24hrVolume = eth["usd_24h_vol"].doubleValue
        self._ethMarketCap = eth["usd_market_cap"].doubleValue
    }
    
}
