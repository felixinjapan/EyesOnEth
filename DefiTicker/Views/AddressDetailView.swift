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

struct AddressDetailView: View {
    @EnvironmentObject var settings: EthereumSetting
    @State private var info: EthplorerGetAddressInfo?
    @State private var tokenPriceInfo: CoinGeckoSimpleTokenPrice?
    
    var body: some View {
        NavigationView {
            List {
                if let info = self.info, let tokenPriceInfo = self.tokenPriceInfo {
                    Section(header: Header(totalValue: info.totalValue, activeAddress: settings.address)) {
                        NavigationLink(destination: DetailViewEth(eth: info.ethModel)) {
                            TableRowViewEthereum(eth: info.ethModel)
                        }
                        ForEach(info.tokens) { tokenInfo in
                            NavigationLink(destination: DetailViewToken(token: tokenInfo)) {
                                TableRowViewToken(info: tokenInfo, subInfo: tokenPriceInfo)
                            }
                        }
                    }.collapsible(false)
                }
            }
            .frame(minWidth: 250, maxWidth: 350)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddressDetailView().environmentObject(EthereumSetting())
    }
}

struct SectionHeaderView: View {
    let section: HttpSection
    
    var body: some View {
        HStack(spacing: 20) {
            Text(section.headerCode)
                .layoutPriority(1)
            
            Text(section.headerText)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
        }
    }
}

struct Header: View {
    var totalValue:Double?
    var activeAddress:String?
    
    var body: some View {
        HStack(spacing: 5) {
            Text(EthereumUtil.getAbbreviateAddress(activeAddress!))
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
            Text("balance: $\(EthereumUtil.roundUpTotal(self.totalValue ?? 0))")
                .layoutPriority(1)
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
            Spacer().frame(width:40)
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
        HStack(spacing: 20) {
            Text(info.symbol)
                .frame(width: 60)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(info.name)
                .truncationMode(.tail)
            
            Spacer()
        }
    }
    
    //    func getIconImage() {
    //     let url =
    //        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            if let error = error {
    //                print(error)
    //            } else if let data = data {
    //                DispatchQueue.main.async {
    //                    self.icon = NSImage(data: data)
    //                }
    //            }
    //        }
    //        task.resume()
    //    }
}
