//
//  ContentView.swift
//  
//
//  Created by Chon, Felix  on 2020/11/18.
//

import SwiftUI

class RegisterAddressViewModel {
    var closeAction: () -> Void
    var registerAction: (String) -> RegisterAddressResult
    init() {
        print("init")
        self.closeAction = {}
        self.registerAction = { _ in .invalidAddress }
    }
}

struct RegisterAddressView: View {
    
    var vm : RegisterAddressViewModel
    // sheet dismissed using Environment presentation mode
    @Environment(\.presentationMode) var presentationMode
    // without private it does not work
    @State private var enteredText: String = ""
    @State private var registrationFeedback = ""
    @State private var isShowingRegistrationFeedback = false

    var body: some View {
        VStack {
            HStack {
                Image("ethereum")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Register new wallet address")
                    .font(.body)
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
            }
            TextField("Enter your eth address", text: $enteredText)
                .padding()
                .onHover(perform: { hovering in
                    if hovering {
                        NSCursor.iBeam.push()
                        
                    } else {
                        NSCursor.pop()
                    }
                })
            
            HStack {
                Button("Register") {
                    switch self.vm.registerAction(enteredText) {
                    case .success:
                        self.presentationMode.wrappedValue.dismiss()
                    case .invalidAddress:
                        self.registrationFeedback = "Enter a valid Ethereum address."
                        self.isShowingRegistrationFeedback = true
                    case .duplicateAddress:
                        self.registrationFeedback = "This Ethereum address is already registered."
                        self.isShowingRegistrationFeedback = true
                    }
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
        .alert(isPresented: $isShowingRegistrationFeedback) {
            Alert(
                title: Text("Unable to Register Wallet"),
                message: Text(registrationFeedback),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RegisterAddressView_Previews: PreviewProvider {
    static var previews: some View {
        let bridge = RegisterAddressViewModel()
        RegisterAddressView(vm: bridge)
    }
}
