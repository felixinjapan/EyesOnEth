//
//  ContentView.swift
//  
//
//  Created by Chon, Felix  on 2020/11/18.
//

import SwiftUI
import os

class GasIndicatorViewModel {
    var closeAction: () -> Void
    var registerAction: (String) -> Void
    init() {
        self.closeAction = {}
        self.registerAction = {_ in}
    }
}

struct GasIndicatorView: View {
    
    @State private var safeGasPrice: String = "..."
    @State private var proposeGasPrice: String = "..."
    @State private var fastGasPrice: String = "..."

    var body: some View {
        VStack {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Text("Gas price in Gwei")
                .font(.system(size: 9, weight: .light, design: .default))
            
            }
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                VStack{
                    Image("turtle_mozilla")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text(self.safeGasPrice)
                        .font(.body)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                }
                Spacer().frame(width:18)
                VStack{
                    Image("rabbit_samsung")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text(self.proposeGasPrice)
                        .font(.body)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                }
                Spacer().frame(width:18)
                VStack{
                    Image("dove_apple")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text(self.fastGasPrice)
                        .font(.body)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                }
            }
        }
        .frame(width: 140, height: 70)
        .padding()
        .onAppear(){
            if let checker = UserStatus.shared.gasPriceViewIntervalChecker {
                if checker() {
                    self.updateGasPrice()
                }
            } else {
                let time = RemoteConfigHandler.shared.getRemoteConfigValueDouble(.gasPriceViewInterval)
                UserStatus.shared.gasPriceViewIntervalChecker = EthereumUtil.getIntervalChecker(forInterval: time)
                self.updateGasPrice()
            }
        }
    }
    
    func updateGasPrice(){
        let updateGasPrice: () -> Void = {
            if let tracker = EthereumStatus.shared.estherscanGastracker {
                DispatchQueue.main.async {
                    self.fastGasPrice = String(tracker.result.fastGasPrice)
                    self.proposeGasPrice = String(tracker.result.proposeGasPrice)
                    self.safeGasPrice = String(tracker.result.safeGasPrice)
                    os_log("gas price updated", log: OSLog.default, type: .debug)
                }
            }
        }
        PriceService.getGasPrice(updateGasPrice)
    }
}

struct GasIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        GasIndicatorView()
    }
}
