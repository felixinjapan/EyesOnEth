//
//  ContentView.swift
//  
//
//  Created by Chon, Felix  on 2020/11/18.
//

import SwiftUI

class RegisterAddressViewModel {
    var closeAction: () -> Void
    var registerAction: (String) -> Void
    init() {
        print("init")
        self.closeAction = {}
        self.registerAction = {_ in}
    }
}

struct RegisterAddressView: View {
    
    var vm : RegisterAddressViewModel
    // sheet dismissed using Environment presentation mode
    @Environment(\.presentationMode) var presentationMode
    // without private it does not work
    @State private var enteredText: String = ""

    var body: some View {
        VStack {
            HStack {
                Image("ethereum")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("The Ethereum Blockchain Explorer")
                    .font(.body)
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
            }
            TextField("Type address here", text: $enteredText)
                .padding()
                .onHover(perform: { hovering in
                    if hovering {
                        NSCursor.iBeam.push()
                        
                    } else {
                        NSCursor.pop()
                    }
                })
            
            HStack {
                Button("Ok") {
                    // sheet dismissed using Binding
                    // self.isVisible = false
                    
                    self.vm.registerAction(enteredText)
                    // sheet dismissed using Environment presentation mode
                    self.presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Cancel") {
                    // sheet dismissed using Binding
                    // self.isVisible = false
                    
                    self.enteredText = "Cancel clicked in Sheet"
                    
                    self.vm.closeAction()
                }
            }
        }
        .frame(width: 400, height: 150)
        .padding()
    }
}

struct RegisterAddressView_Previews: PreviewProvider {
    static var previews: some View {
        let bridge = RegisterAddressViewModel()
        RegisterAddressView(vm: bridge)
    }
}
