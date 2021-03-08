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
    @State private var alertIsShowing = true

    var body: some View {
        HStack {
        }.alert(isPresented: $alertIsShowing) {
            Alert(title: Text("Alert"),
                  message: Text(self.msg),
                  dismissButton: .default(Text("OK")))
        }.onAppear(){
            self.alertIsShowing = false
        }
    }
}

struct Alert_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(msg: "this is the preview.djdlkfjlfjdlk\nthis is the preview.\nthis is the preview.")
    }
}
