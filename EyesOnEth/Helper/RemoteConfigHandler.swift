import Firebase
import FirebaseRemoteConfig

class RemoteConfigHandler {
    static let shared = RemoteConfigHandler()
    private let remoteConfig: RemoteConfig

    enum RemoteConfigKey: String {
        
        case priceTickerInterval = "priceTickerInterval"
        case gasPriceViewInterval = "gasPriceViewInterval"
        case ethPriceViewInterval = "ethPriceViewInterval"

        case etherscanKey = "etherscanKey"
        case ethplorerApiKey = "ethplorerApiKey"
        case serviceVersion = "serviceVersion"
        case maxContractAddressCoinGecko = "maxContractAddressCoinGecko"
    }

    init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
        self.remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }

    func update()  {
        self.remoteConfig.fetchAndActivate(completionHandler: { status, error in
            print(status, error as Any)
        })
    }
 
    func getRemoteConfigValueInt(_ key: RemoteConfigKey) -> Int {
        return remoteConfig.configValue(forKey: key.rawValue).numberValue.intValue
    }
    
    func getRemoteConfigValueDouble(_ key: RemoteConfigKey) -> Double {
        return remoteConfig.configValue(forKey: key.rawValue).numberValue.doubleValue
    }

    func getRemoteConfigValueString(_ key: RemoteConfigKey) -> String? {
        return remoteConfig.configValue(forKey: key.rawValue).stringValue
    }
    
}
