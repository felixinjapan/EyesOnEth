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
                    Text("1d: \(EthereumUtil.tokenPriceDiffString(eth.priceDiff))")
                        .font(.caption)
                    Text("7d: \(EthereumUtil.tokenPriceDiffString(eth.priceDiff7days))")
                        .font(.caption)
                }.padding()
            }
            Divider()
            HStack {
                VStack() {
                    Text("Value:").font(.caption).foregroundColor(.secondary)
                    Text("$ \(EthereumUtil.tokenPriceForDetailView(eth.value))")
                        .font(.body)
                    Spacer()
                }.padding()
                Spacer()
                Divider()
                VStack() {
                    Text("Token Balance:").font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(eth.balance)")
                        .font(.body)
                    Spacer()
                }.padding()
                Spacer()
            }.padding()
            Spacer()
            Divider()
            HStack {
                if let url = EthereumUtil.getExternalLink(target: "https://ethereum.org/", type: ExternalSite.website) {
                    Button {
                        NSWorkspace.shared.open(url)
                    } label: {
                        CircleImage(image: NSImage(imageLiteralResourceName: "website"))
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(Text("Open Ethereum website"))
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                }
                if let url = EthereumUtil.getExternalLink(target: "ethereum", type: ExternalSite.coingecko) {
                    Button {
                        NSWorkspace.shared.open(url)
                    } label: {
                        CircleImage(image: NSImage(imageLiteralResourceName: "coingecko"))
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(Text("Open Ethereum on CoinGecko"))
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                }
                if let url = EthereumUtil.getExternalLink(target: "ethereumproject", type: ExternalSite.facebook) {
                    Button {
                        NSWorkspace.shared.open(url)
                    } label: {
                        CircleImage(image: NSImage(imageLiteralResourceName: "facebook"))
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(Text("Open Ethereum on Facebook"))
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                }
                if let url = EthereumUtil.getExternalLink(target: "ethereum", type: ExternalSite.twitter) {
                    Button {
                        NSWorkspace.shared.open(url)
                    } label: {
                        CircleImage(image: NSImage(imageLiteralResourceName: "twitter"))
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(Text("Open Ethereum on Twitter"))
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                }
                if let url = EthereumUtil.getExternalLink(target: "ethereum", type: ExternalSite.reddit) {
                    Button {
                        NSWorkspace.shared.open(url)
                    } label: {
                        CircleImage(image: NSImage(imageLiteralResourceName: "reddit"))
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(Text("Open Ethereum on Reddit"))
                    .onHover(perform: { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                }
            }.padding()
            Spacer()
        }
        .frame(width: 420, height: 330)
    }
}

//struct DetailViewEth_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailViewEth(eth: Eth()
//    }
//}

