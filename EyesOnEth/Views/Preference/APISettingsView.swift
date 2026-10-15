import SwiftUI

struct APISettingsView: View {
    @ObservedObject private var ethereumStatus = EthereumStatus.shared

    var body: some View {
        VStack {
            Text("API Status").font(.headline)
            Spacer().frame(height: 70)
            ForEach(ExternalSiteApi.allCases) { type in
                ApiStatusView(type: type, isOnline: isOnline(for: type))
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }

    private func isOnline(for type: ExternalSiteApi) -> Bool {
        switch type {
        case .coingecko:
            return ethereumStatus.apiStatus.coinGecko
        case .ethplorer:
            return ethereumStatus.apiStatus.ethplorer
        case .etherscan:
            return ethereumStatus.apiStatus.etherscan
        }
    }
}

enum StatusText: String {
    case Offline
    case Online
}

struct ApiStatusView: View {
    let type: ExternalSiteApi
    let isOnline: Bool

    private var color: Color {
        isOnline ? .green : .red
    }

    private var status: StatusText {
        isOnline ? .Online : .Offline
    }

    var body: some View {
        HStack {
            Text(type.rawValue)
            Spacer()
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(status.rawValue).foregroundColor(color)
        }
    }
}
