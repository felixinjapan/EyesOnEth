//
//  Constants.swift
//  
//
//  Created by Chon, Felix  on 2021/01/04.
//

import Foundation

struct Constants {
    
    static let baseImageUrlEthPlorer = "https://ethplorer.io/"
    // user default keys
    static let activeAddress = "activeAddress"
    static let ethAddressKey = "ethAddressKey"
    static let ethplorerApiKey = "ethplorerApiKey"
    
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

enum ExternalSiteApi: String, CaseIterable, Identifiable {
    var id: ExternalSiteApi{self}

    case etherscan = "etherscan"
    case ethplorer = "ethplorer"
    case coingecko = "coingecko"
}

enum ExternalSite: String, CaseIterable {
    case twitter = "twtitter"
    case reddit = "reddit"
    case coingecko = "coingecko"
    case facebook = "facebook"
    case telegram = "telegram"
    case website = "website"
}
