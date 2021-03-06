//
//  ContentView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 6/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI
import AppKit
import SwiftyJSON
import os

struct TokenListView: View {
    @EnvironmentObject var settings: EthereumSetting
    @State private var info: EthplorerGetAddressInfo?
    @State private var tokenPriceInfo: CoinGeckoSimpleTokenPrice?
    
    fileprivate func isValidToken(_ tokenInfo: Token) -> Bool {
        if tokenInfo.symbol.isEmpty || tokenInfo.name.isEmpty {
            return false
        }
        if let falsePriceList = self.info?.priceFalseKV {
            if falsePriceList[tokenInfo.contractAddr] != nil, self.tokenPriceInfo?.array[tokenInfo.contractAddr] == nil {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            List {
                if let info = self.info, let tokenPriceInfo = self.tokenPriceInfo {
                    Section(header: Header(totalValue: getTotalBalance(info.totalValue), activeAddress: settings.address)) {
                        NavigationLink(destination: DetailViewEth(eth: info.ethModel)) {
                            TableRowViewEthereum(eth: info.ethModel)
                        }
                        
                        ForEach(info.tokens) { tokenInfo in
                            if isValidToken(tokenInfo) {
                                NavigationLink(destination: DetailViewToken(token: tokenInfo, subInfo: self.tokenPriceInfo)) {
                                    TableRowViewToken(info: tokenInfo, subInfo: tokenPriceInfo)
                                }
                            }
                        }
                    }.collapsible(false)
                } else {
                    Text("Loading...")
                    LoadingAnimation()
                }
            }
            .frame(width: 270, height: 330)
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.readData()
        }
    }
    func readData() {
        let address = settings.address
        
        let updateMenuPrice: (JSON) -> Void = { json in
            self.info = EthplorerGetAddressInfo(getAddressInfo: json)
            PriceService.updateTokenPriceFromCoinGecko(self.info!.contractAddressList){ data in
                EthereumStatus.shared.coinGeckoSimpleTokenPrice = CoinGeckoSimpleTokenPrice(data: data)
                self.tokenPriceInfo = EthereumStatus.shared.coinGeckoSimpleTokenPrice
                os_log("read Data complete")
            }
        }
        PriceService.updateAddressInfoFromEthplorer(address, updateMenuPrice)
    }
    
    func getTotalBalance(_ balance:Double) -> Double {
        var missingBalance:Double = 0
        if let token = self.tokenPriceInfo?.array, let info = self.info {
            info.priceFalseKV.forEach { falsePrice in
                if let price = token[falsePrice.key]?.usd {
                    missingBalance += price * falsePrice.value
                }
            }
        }
        return missingBalance + balance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TokenListView().environmentObject(EthereumSetting())
    }
}

struct Header: View {
    var totalValue:Double?
    var activeAddress:String?
    
    var body: some View {
        HStack(spacing: 5) {
            Text(EthereumUtil.getAbbreviateAddress(activeAddress!, (6,4)))
                .layoutPriority(1)
                .onHover(perform: { hovering in
                    if hovering {
                        NSCursor.contextualMenu.push()
                    } else {
                        NSCursor.pop()
                    }
                })
                .onTapGesture {
                    let board = NSPasteboard.general
                    board.clearContents()
                    board.setString(activeAddress!, forType: .string)
                    NSCursor.pop()
                }
            Spacer()
            if let total = self.totalValue, let rt = EthereumUtil.roundUpTotal(total){
                Text("total: $\(EthereumUtil.formattedWithSeparator(rt)!)")
                    .layoutPriority(1)
            }
        }
    }
    
}

struct TableRowViewEthereum: View {
    let eth: Eth
    
    var body: some View {
        HStack(spacing: 0) {
            Image("ethereum2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 20)
            
            Text("ETH")
                .frame(width: 60)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer().frame(width:20)
            Text("Ethereum")
                .truncationMode(.tail)
        }
    }
}

struct TableRowViewToken: View {
    let info: Token
    let subInfo: CoinGeckoSimpleTokenPrice
    @State private var icon: NSImage?
    
    var body: some View {
        HStack(spacing: 0) {
            if let icon = self.icon {
                Image(nsImage: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:20, height: 20)
            } else {
                Spacer().frame(width:20)
            }
            
            Text(info.symbol)
                .frame(width: 60)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer().frame(width:20)
            
            Text(info.name)
                .truncationMode(.tail)
            Spacer()
        }.onAppear(){
            if info.image.isEmpty == false, let url = URL(string: Constants.baseImageUrlEthPlorer + info.image) {
                getIconImage(url: url)
            }
        }
    }
    
    func getIconImage(url:URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                DispatchQueue.main.async {
                    self.icon = NSImage(data: data)
                }
            }
        }
        task.resume()
    }
}
