//
//  Constants.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2021/01/04.
//

import Foundation

struct Constants {
    
    static let baseImageUrlEthPlorer = "https://ethplorer.io/"
    static let ethAddressKey = "ethAddressKey"
    static let ethplorerApiKey = "ethplorerApiKey"
    static let activeAddress = "activeAddress"
    static let maxContractAddressCoinGecko = 116
    static let gasPriceViewInterval = 15
    static let ethPriceViewInterval = 10
    static let tickerInterval:TimeInterval = 10
    
    static let externalEthUrl: Dictionary = [
        "coingecko": "https://www.coingecko.com/coins/ethereum",
        "reddit": "https://www.reddit.com/r/ethereum",
        "twitter": "https://twitter.com/ethereum",
        "facebook": "https://www.facebook.com/ethereumproject/",
        "website": "https://ethereum.org/",
    ]
    
    static let externalTokenUrl: Dictionary = [
        "etherscan": "https://etherscan.io/address/%@",
        "ethplorer": "https://ethplorer.io/address/%@",
        "coingecko": "https://www.coingecko.com/coins/%@",
        "reddit": "https://www.reddit.com/r/%@",
        "twitter": "https://twitter.com/%@",
        "telegram": "%@",
        "facebook": "https://www.facebook.com/%@",
        "website": "%@",
    ]
}

enum ExternalSiteSubmenu: String {
    case etherscan = "etherscan"
    case ethplorer = "ethplorer"
}

enum ExternalSite: String, CaseIterable {
    case twitter = "twtitter"
    case reddit = "reddit"
    case coingecko = "coingecko"
    case facebook = "facebook"
    case telegram = "telegram"
    case website = "website"
}
