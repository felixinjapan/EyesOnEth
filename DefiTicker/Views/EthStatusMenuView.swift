//
//  ContentView.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import SwiftUI
import os

struct EthStatusMenuView: View {
    
    @State private var ethPrice: String = "-"
    @State private var priceDiff: Float = 0
    @State private var priceDiffString: String = "-"
    
    var body: some View {
        VStack {
            HStack {
                Text("Ether price")
                    .font(.system(size: 9, weight: .light, design: .default))
            }
            HStack {
                VStack{
                    Image("ethereum2")
                        .resizable()
                        .scaledToFit()
                }
                VStack{
                    Text(self.ethPrice)
                        .foregroundColor(.primary)
                        .scaledToFill()
                        .font(.system(size: 17, weight: .light, design: .default))
                }
                VStack{
                    if(self.priceDiff > 0){
                        Text("+" + self.priceDiffString)
                            .foregroundColor(.green)
                            .scaledToFill()
                            .font(.system(size: 9, weight: .light, design: .default))
                    } else {
                        Text("-" + self.priceDiffString)
                            .foregroundColor(.red)
                            .scaledToFill()
                            .font(.system(size: 9, weight: .light, design: .default))
                    }

                }
            }
        }
        .frame(width: 140, height: 40)
        .padding()
        .onAppear(){
            updateEthereumPrice()
        }
    }
   
    func updateEthereumPrice(){
        let updateGasPrice: () -> Void = {
            if let coinGeckoSimplePrice = EthereumStatus.shared.coinGeckoSimplePrice {
                DispatchQueue.main.async {
                    let ethPrice = String(format: "%.0f", coinGeckoSimplePrice.ethPriceInUSD)
                    self.ethPrice = String("$ \(ethPrice)")
                    self.priceDiff = Float(coinGeckoSimplePrice.eth24hrChange)
                    self.priceDiffString = String(format: "%.2f", self.priceDiff) + "%"
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
