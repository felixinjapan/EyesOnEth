//
//  DetailView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 6/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI

struct DetailViewEth: View {
    let eth: Eth
        
    var body: some View {
        VStack() {
            HStack(alignment: .top){
                HStack {
                    CircleImage(image: NSImage(imageLiteralResourceName: "ethereum2"))
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("Ethereum")
                        .font(.headline)
                        .aspectRatio(contentMode: .fit)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }.padding()
                Spacer()
                VStack(alignment: .trailing) {
                    Text("$ \(eth.price)")
                        .font(.headline)
                    Text("1d: \(eth.priceDiff)")
                        .font(.caption)
                    Text("7d: \(eth.priceDiff7days)")
                        .font(.caption)
                }.padding()
            }
            Divider()
            HStack {
                VStack(alignment:.leading) {
                    Text("Value: $ \(EthereumUtil.tokenPriceForDetailView(eth.value))")
                        .font(.body)
                    Text("Token Balance: \(eth.balance)")
                        .font(.body)
                }.padding()
                Spacer()
            }
            Divider()
            
            Spacer()
        }
        .frame(width: 400, height: 300)
    }
}

//struct DetailViewEth_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailViewEth(eth: Eth()
//    }
//}

