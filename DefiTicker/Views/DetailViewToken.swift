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
    
    @State private var catImage: NSImage?
    @State private var imageIsFlipped = false
    
    var body: some View {
        VStack {
            Text("balance:\(token.balance)")
                .font(.system(size: 10))
            Text("market capital:\(token.marketCapUsd)")
                .font(.system(size: 10))
            Text("price:\(token.price)")
                .font(.system(size: 10))
            Text("priceDiff:\(token.priceDiff)")
                .font(.system(size: 10))
            Text("price7daysDiff:\(token.priceDiff7days)")
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

struct DetailViewToken_Previews: PreviewProvider {
    static var previews: some View {
        //token_preview.json
        let token:Token = Bundle.main.decode(Token.self, from: "token_preview.json")
        DetailViewToken(token: token)
    }
}


