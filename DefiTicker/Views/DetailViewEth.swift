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
    
    @State private var catImage: NSImage?
    @State private var imageIsFlipped = false
    
    var body: some View {
        VStack {
            Text("balance:\(eth.balance)")
                .font(.system(size: 10))
            Text("market capital:\(eth.marketCap)")
                .font(.system(size: 10))
            Text("price:\(eth.price)")
                .font(.system(size: 10))
            Text("priceDiff:\(eth.priceDiff)")
                .font(.system(size: 10))
            Text("price7daysDiff:\(eth.priceDiff7days)")
                .font(.system(size: 10))
            
            if catImage != nil {
                CatImageView(catImage: catImage!, imageIsFlipped: imageIsFlipped)
            } else {
                Spacer()
                Text("Loading...")
                    .font(.headline)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .onAppear {
            //self.getCatImage()
        }
    }
    
//    func getCatImage() {
//        let url = ""
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print(error)
//            } else if let data = data {
//                DispatchQueue.main.async {
//                    self.catImage = NSImage(data: data)
//                }
//            }
//        }
//        task.resume()
//    }
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(getAddressInfo: EthplorerGetAddressInfo(getAddressInfo: JSON(nil))).environmentObject(Prefs())
//    }
//}

struct CatImageView: View {
    @EnvironmentObject var prefs: Prefs
    
    let catImage: NSImage
    let imageIsFlipped: Bool
    
    var body: some View {
        Image(nsImage: catImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotation3DEffect(Angle(degrees: imageIsFlipped ? 180 : 0),
                              axis: (x: 0, y: 1, z: 0))
            .animation(.default)
            .overlay(
                Text(prefs.showCopyright ? "Copyright © https://http.cat" : "")
                    .padding(6)
                    .font(.caption)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                ,alignment: .bottomTrailing)
    }
}
