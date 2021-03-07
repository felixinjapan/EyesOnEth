import SwiftUI

struct APISettingsView: View {
        
    var body: some View {
        VStack {
            Text("API Status").font(.headline)
            Spacer().frame(height: 70)
            ForEach(ExternalSiteApi.allCases) { type in
                ApiStatusView(type: type)
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}
enum StatusText: String {
    case Offline
    case Online
}

struct ApiStatusView: View {
    let type:ExternalSiteApi
    @State var color:Color = Color.red
    @State var status:StatusText = .Offline
    var body: some View {
        HStack{
            Text(type.rawValue)
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(status.rawValue).foregroundColor(color)
        }.onAppear(){
            getStatusInfo()
        }
    }
    
    func getStatusInfo(){
        var status = false
        switch type {
        case ExternalSiteApi.coingecko :
            status = EthereumStatus.shared.apiStatus.coinGecko
        case ExternalSiteApi.ethplorer :
            status = EthereumStatus.shared.apiStatus.ethplorer
        case ExternalSiteApi.etherscan :
            status = EthereumStatus.shared.apiStatus.etherscan
        }
        if status {
            self.color = Color.green
            self.status = StatusText.Online
        } else {
            self.color = Color.red
            self.status = StatusText.Offline
        }
    }
}
