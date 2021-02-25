//
//  DetailView.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 6/11/19.
//  Copyright © 2019 Sarah Reichelt. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    
    var msg : String
    @State private var alertIsShowing = false

    var body: some View {
        VStack {
        }.alert(isPresented: $alertIsShowing) {
            Alert(title: Text("Alert"),
                  message: Text("This is an alert!"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct Alert_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(msg: "this is the preview.djdlkfjlfjdlk\nthis is the preview.\nthis is the preview.")
    }
}
