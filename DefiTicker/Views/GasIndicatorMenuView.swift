//
//  ContentView.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import SwiftUI

class GasIndicatorViewModel {
    var closeAction: () -> Void
    var registerAction: (String) -> Void
    init() {
        self.closeAction = {}
        self.registerAction = {_ in}
    }
}

struct GasIndicatorView: View {
    
    //    var vm : GasIndicatorViewModel
    // sheet dismissed using Environment presentation mode
    @Environment(\.presentationMode) var presentationMode
    // without private it does not work
    @State private var gasTracker: EtherscanGastracker?
    @State private var safeGasPrice: String = "11"
    @State private var proposeGasPrice: String = "22"
    @State private var fastGasPrice: String = "33"

    var body: some View {
//        var safeGasPrice: String = "11"
//        var proposeGasPrice: String = "22"
//        var fastGasPrice: String = "33"
        VStack {
            HStack {
                Text("Gas price in Gwei")
                .font(.system(size: 9, weight: .light, design: .default))
            
            }
            HStack {
                Spacer().frame(width:13)
                VStack{
                    Image("turtle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text(self.safeGasPrice)
                        .font(.body)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                }
                Spacer().frame(width:13)
                VStack{
                    Image("rabbit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text(self.proposeGasPrice)
                        .font(.body)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                }
                Spacer().frame(width:13)
                VStack{
                    Image("dove")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text(self.fastGasPrice)
                        .font(.body)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                }
            }
        }
        .frame(width: 140, height: 70)
        .padding()
        .onAppear(){
            self.getGasPrice()
        }
    }
    
    func getGasPrice(){
        let updateGasPrice: () -> Void = {
            if let tracker = EthereumStatus.shared.estherscanGastracker {
                DispatchQueue.main.async {
                    self.fastGasPrice = String(tracker.result.fastGasPrice)
                    self.proposeGasPrice = String(tracker.result.proposeGasPrice)
                    self.safeGasPrice = String(tracker.result.safeGasPrice)
                    print("gas price updated")
                }
            }
        }
        PriceService.getGasPrice(updateGasPrice)
    }
}

struct GasIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        let bridge = GasIndicatorViewModel()
        GasIndicatorView()
    }
}
