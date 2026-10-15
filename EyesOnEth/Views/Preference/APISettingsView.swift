import SwiftUI

struct APISettingsView: View {
    @ObservedObject var prefs: Prefs

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Provider API Keys").font(.headline)
            SecureField("Etherscan API key", text: $prefs.etherscanApiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Ethplorer API key", text: $prefs.ethplorerApiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Keys entered in a client app can be extracted from the app or this Mac. Use provider-side restrictions and grant only the access this app needs.")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            Text("API Status").font(.headline)
            ForEach(ExternalSiteApi.allCases) { type in
                ApiStatusView(type: type)
            }
        }
        .padding(20)
        .frame(width: 420)
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
