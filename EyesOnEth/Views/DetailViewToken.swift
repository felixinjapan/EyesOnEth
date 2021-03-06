//
//  DetailView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 6/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI

struct DetailViewToken: View {
    let token: Token
    let subInfo: CoinGeckoSimpleTokenPrice?
    @State private var tokenPrice:String?
    @State private var priceDiff:String?
    @State private var tokenValue:String?
    @State private var priceDiff7days:String?
    @State var icon:NSImage?
    
    var body: some View {
        VStack() {
            HStack(alignment: .top){
                HStack {
                    CircleImage(image: icon)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text(token.name)
                        .font(.headline)
                        .aspectRatio(contentMode: .fit)
                        .multilineTextAlignment(.leading)
                        
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }.padding()
                Spacer()
                VStack(alignment: .trailing) {
                    if let tokenPrice = self.tokenPrice{
                        Text("$ \(tokenPrice)")
                            .font(.headline)
                    }
                    if let priceDiff = self.priceDiff, !priceDiff.isEmpty {
                        Text("1d: \(priceDiff)")
                            .font(.caption)
                    }
                    if let priceDiff7days = self.priceDiff7days, !priceDiff7days.isEmpty {
                        Text("7d: \(priceDiff7days)")
                            .font(.caption)
                    }
                }.padding()
            }
            Divider()
            if let tokenValue = self.tokenValue {
                HStack {
                    VStack() {
                        Text("Value:").font(.caption).foregroundColor(.secondary)
                        Text("$ \(tokenValue)")
                            .font(.body)
                        Spacer()
                    }.padding()
                    Spacer()
                    Divider()
                    VStack() {
                        Text("Token Balance:").font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(token.balance)")
                            .font(.body)
                        Spacer()
                    }.padding()
                    Spacer()
                }.padding()
                Spacer()
                
            }
            Divider()
            HStack {
                if let url = EthereumUtil.getExternalLink(target: token.website, type: ExternalSite.website) {
                    CircleImage(image: NSImage(imageLiteralResourceName: "website"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            NSWorkspace.shared.open(url)
                        }
                        .onHover(perform: { hovering in
                            if hovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        })
                }
                if let url = EthereumUtil.getExternalLink(target: token.coingecko, type: ExternalSite.coingecko) {
                    CircleImage(image: NSImage(imageLiteralResourceName: "coingecko"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            NSWorkspace.shared.open(url)
                        }
                        .onHover(perform: { hovering in
                            if hovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        })
                }
                if let url = EthereumUtil.getExternalLink(target: token.facebook, type: ExternalSite.facebook) {
                    CircleImage(image: NSImage(imageLiteralResourceName: "facebook"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            NSWorkspace.shared.open(url)
                        }
                        .onHover(perform: { hovering in
                            if hovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        })
                }
                if let url = EthereumUtil.getExternalLink(target: token.twitter, type: ExternalSite.twitter) {
                    CircleImage(image: NSImage(imageLiteralResourceName: "twitter"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            NSWorkspace.shared.open(url)
                        }
                        .onHover(perform: { hovering in
                            if hovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        })
                }
                if let url = EthereumUtil.getExternalLink(target: token.reddit, type: ExternalSite.reddit) {
                    CircleImage(image: NSImage(imageLiteralResourceName: "reddit"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            NSWorkspace.shared.open(url)
                        }
                        .onHover(perform: { hovering in
                            if hovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        })
                }
                if let url = EthereumUtil.getExternalLink(target: token.telegram, type: ExternalSite.telegram) {
                    CircleImage(image: NSImage(imageLiteralResourceName: "telegram"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            NSWorkspace.shared.open(url)
                        }
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
        .onAppear(){
            getTokenPrice()
            if token.image.isEmpty == false, let url = URL(string: Constants.baseImageUrlEthPlorer + token.image) {
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
    
    func getTokenPrice() {
        if token.price > 0 {
            self.tokenPrice = EthereumUtil.tokenPriceForDetailView(token.price)
            self.tokenValue = EthereumUtil.tokenPriceForDetailView(token.value)
        } else {
            if let subInfo = subInfo?.array[token.contractAddr] {
                self.tokenPrice = EthereumUtil.tokenPriceForDetailView(subInfo.usd)
                self.tokenValue = EthereumUtil.tokenPriceForDetailView(subInfo.usd*token.balance)
            } else {
                self.tokenValue = EthereumUtil.tokenPriceForDetailView(token.value)
                self.tokenPrice = "N/A"
            }
        }
        self.priceDiff = EthereumUtil.tokenPriceDiffString(token.priceDiff)
        self.priceDiff7days = EthereumUtil.tokenPriceDiffString(token.priceDiff7days)
    }
    
}

struct DetailViewToken_Previews: PreviewProvider {
    static var previews: some View {
        //token_preview.json
        let token:Token = Bundle.main.decode(Token.self, from: "token_preview.json")
        DetailViewToken(token: token, subInfo: nil, icon: NSImage(imageLiteralResourceName: "ethereum2"))
    }
}


