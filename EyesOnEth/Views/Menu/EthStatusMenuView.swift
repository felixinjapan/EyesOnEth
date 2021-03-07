//
//  ContentView.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import SwiftUI
import os
import SwiftyJSON

struct EthStatusMenuView: View {
    
    @State private var ethPrice: String = "-"
    @State private var priceDiff: Float = 0
    @State private var priceDiffString: String = "-"
    @State private var priceDiffColor: Color = Color.white
    
    var body: some View {
        VStack {
            HStack(alignment:.center) {
                Text("Ether price")
                    .font(.system(size: 9, weight: .light, design: .default))
                Image("ethereum2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14)
            }
            HStack(alignment:.center) {
                VStack{
                    Text(self.ethPrice)
                        .foregroundColor(.primary)
                        .scaledToFill()
                        .font(.system(size: 19, weight: .light, design: .default))
                }
                VStack{
                    Text(self.priceDiffString)
                        .foregroundColor(self.priceDiffColor)
                        .scaledToFill()
                        .font(.system(size: 10, weight: .light, design: .default))
                }
            }
        }
        .frame(width: 140, height: 40)
        .padding()
        .onAppear(){
            if let checker = UserStatus.shared.ethPriceViewIntervalChecker {
                if checker() {
                    self.updateEthereumPrice()
                }
            } else {
                UserStatus.shared.ethPriceViewIntervalChecker = EthereumUtil.getIntervalChecker(forInterval: Constants.ethPriceViewInterval.1)
                self.updateEthereumPrice()
            }
        }
    }
    
    func updateEthereumPrice(){
        let updateGasPrice: (JSON) -> Void = { json in
            EthereumStatus.shared.coinGeckoSimplePrice = CoinGeckoSimplePrice(simplePrice: json)
            if let coinGeckoSimplePrice = EthereumStatus.shared.coinGeckoSimplePrice {
                DispatchQueue.main.async {
                    let ethPrice = EthereumUtil.roundUpTotal(coinGeckoSimplePrice.ethPriceInUSD)
                    self.ethPrice = String("$ \(ethPrice)")
                    if coinGeckoSimplePrice.eth24hrChange > 0 {
                        self.priceDiffColor = Color.green
                    } else {
                        self.priceDiffColor = Color.red
                    }
                    self.priceDiff = Float(coinGeckoSimplePrice.eth24hrChange)
                    self.priceDiffString = EthereumUtil.tokenPriceDiffString(self.priceDiff)
                    os_log("eth price was %f, diff was %@", log: OSLog.default, type: .debug, self.ethPrice, self.priceDiff)
                }
            }
        }
        PriceService.getEthereumPrice(updateGasPrice)
    }
    
}

struct EthStatusMenuView_Previews: PreviewProvider {
    static var previews: some View {
        EthStatusMenuView()
    }
}
