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
    static let activeAddress = "activeAddress"
    static let maxContractAddressCoinGecko = 186
    
//    static let tokenExternalWebs = [
//        "coingecko",
//        "reddit",
//        "twitter",
//        "telegram",
//        "facebook",
//    ]
    
    static let externalServiceUrl: Dictionary = [
        "etherscan": "https://etherscan.io/address/%@",
        "ethplorer": "https://ethplorer.io/address/%@",
        "coingecko": "https://www.coingecko.com/coins/%@",
        "reddit": "https://www.reddit.com/r/%@",
        "twitter": "https://twitter.com/%@",
        "telegram": "https://t.me/%@",
        "facebook": "https://www.facebook.com/%@"
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
}
