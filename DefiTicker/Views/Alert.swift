//
//  DetailView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 6/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI

struct Alert: View {
    
    var msg : String

    var body: some View {
        VStack {
            HStack {
                Image("dove")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Text("Error has been occured")
                    .font(.body)
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack {
                Text(self.msg)
                    .font(.caption)
                    .aspectRatio(contentMode: .fill)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .foregroundColor(.primary)
            }.frame(height: 60)
        }
        .frame(width: 200, height: 100)
        .padding()
    }
}

struct Alert_Previews: PreviewProvider {
    static var previews: some View {
        Alert(msg: "this is the preview.djdlkfjlfjdlk\nthis is the preview.\nthis is the preview.")
    }
}
