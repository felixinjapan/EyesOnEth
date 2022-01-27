//
//  StatusBarController.swift
//  
//
//  Created by Chon, Felix  on 2020/11/18.
//

import AppKit
import SwiftUI
import SwiftyJSON
import os

class AppMenuItem : NSMenuItem {
    open var ethAddress:String?
}

class SubMenuItem : NSMenuItem {
    open var link:URL?
    open var setting:EthereumSetting?
}
class SubMenu : NSMenu {
    var ethAddress:String?
}

class StatusBarController {
    
    private var statusItem: NSStatusItem
    private var eventMonitor: EventMonitor?
    
    var popover = NSPopover.init()
    lazy var bridge = RegisterAddressViewModel()
    var prefsView: PrefsView?
    
    var appMenu = NSMenu()
    
    let registerNewAddress  = NSMenuItem(title: "Add new address",  action: #selector(StatusBarController.actionMenuAddNewAddress(_:)),  keyEquivalent: "a")
    let preference = NSMenuItem(title: "Preference", action: #selector(StatusBarController.actionPreference(_:)), keyEquivalent: "p")
    weak var priceUpdateTimer: Timer?
    
    var gasIndicatorMenuView:GasIndicatorView = GasIndicatorView()
    var ethStatusMenuView:EthStatusMenuView = EthStatusMenuView()
    
    let clickFiringChecker = EthereumUtil.getIntervalChecker(forInterval: 2)
    
    
    fileprivate func showImageStatusBar() {
        
        if let statusBarButton = statusItem.button {
            statusBarButton.title = ""
            statusBarButton.image = #imageLiteral(resourceName: "ethereum")
            self.statusItem.length = statusBarButton.title.widthForButton()
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
        }
    }
    
    init()
    {
        let notificationCenter = NotificationCenter.default
        statusItem = NSStatusBar.system.statusItem(withLength : NSStatusItem.squareLength)
        
        notificationCenter
            .addObserver(self,
                         selector:#selector(self.addNewAddressMenu),
                         name: .addNewAddressMenu,
                         object: nil)
        
        notificationCenter
            .addObserver(self,
                         selector:#selector(self.actionResetAddress),
                         name: .resetAll,
                         object: nil)
        
        notificationCenter
            .addObserver(self,
                         selector:#selector(self.removeActiveAddress),
                         name: .removeActiveAddress,
                         object: nil)
        
        notificationCenter
            .addObserver(self,
                         selector:#selector(self.initTickerTimer),
                         name: .initTickerTimer,
                         object: nil)
        
        bridge.closeAction = {
            self.popover.close()
        }
        popover.contentViewController = NSViewController()
        popover.contentSize = NSSize(width: 500, height: 100)
        
        showImageStatusBar()
        updateData()
        initTickerTimer()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
        constructMenu()
    }
    
    fileprivate func displayTotalValue(_ missingTotal:Double = 0) {
        if let totalValue = UserStatus.shared.getTotalValue(missingTotal), let button = self.statusItem.button {
            button.image = nil
            button.title = "$\(totalValue)"
            self.statusItem.length = button.title.widthForButton()
        }
    }
    
    @objc func initTickerTimer(){
        if self.priceUpdateTimer != nil {
            self.priceUpdateTimer?.invalidate()
            self.priceUpdateTimer = nil
        }
        let time = RemoteConfigHandler.shared.getRemoteConfigValueDouble(.priceTickerInterval)
        self.priceUpdateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func removeActiveAddress() {
        UserStatus.shared.activeAddress = nil
        UserStatus.shared.ethplorerGetAddressInfo = nil
        UserDefaults.standard.removeObject(forKey: Constants.activeAddress)
        self.showImageStatusBar()
    }
    
    @objc func updateData(){
        let updateMenuPrice: (JSON) -> Void = {json in
            UserStatus.shared.ethplorerGetAddressInfo = EthplorerGetAddressInfo(getAddressInfo: json)
            var missingTotal:Double = 0
            if let dict = UserStatus.shared.ethplorerGetAddressInfo?.priceFalseKV, dict.count > 0 {
                let limit = RemoteConfigHandler.shared.getRemoteConfigValueInt(.maxContractAddressCoinGecko)
                os_log("some coins price were missing. count: %d, limit: %d", dict.count, limit)
                if dict.count > limit {
                    self.removeActiveAddress()
                    let alertViewUnsupportedAddress =  WindowViewController(AlertView(msg: "This address has too many\n tokens that has no price data"))
                    alertViewUnsupportedAddress.showWindow(self)
                    return 
                }
                PriceService.updateTokenPriceFromCoinGecko(Array(dict.keys)){
                    data in
                    let simpleToken = CoinGeckoSimpleTokenPrice(data: data)
                    simpleToken.array.forEach { priceInfo in
                        if let bal = dict[priceInfo.key], bal > 0 {
                            missingTotal += priceInfo.value.usd * bal
                        }
                    }
                    self.displayTotalValue(missingTotal)
                }
            } else {
                self.displayTotalValue()
            }
        }
        PriceService.updateActiveAddressPrice(updateMenuPrice)
    }
    
    func changeState(_ sender: AppMenuItem) {
        if let current = UserStatus.shared.activeAddress, let addr = sender.ethAddress, current == addr {
            os_log("No need to call api to update the price...", log: .default, type: .debug)
            return
        }
        if !clickFiringChecker() {
            os_log("Too many firing...", log: .default, type: .debug)
            return
        }
        // Loops over the array of menu items
        for menuItem in appMenu.items {
            // Switches off the first (and unique) 'on' item
            if  menuItem.state == NSControl.StateValue.on {
                menuItem.state = NSControl.StateValue.off
                break
            }
        }
        if let addr = sender.ethAddress {
            self.initTickerTimer()
            UserDefaults.standard.setValue(addr, forKey: Constants.activeAddress)
            UserStatus.shared.activeAddress = addr
            self.updateData()
        }
        // To prevent massive api calls
        if let statusBarButton = statusItem.button {
            statusBarButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                statusBarButton.isEnabled = true
            }
        }
        os_log("%@", log: .default, type: .debug, UserStatus.shared.activeAddress!)
        sender.state = NSControl.StateValue.on
    }
    
    @objc func actionMenuAddNewAddress(_ sender: AppMenuItem){
        bridge.registerAction = { (ethAddr: String) -> Void in
            RegisterService.registerAddress(ethAddr)
            self.togglePopover(sender)
        }
        let contentView = RegisterAddressView(vm: bridge)
        let vc = NSHostingView(rootView: contentView)
        popover.contentViewController?.view = vc
        togglePopover(sender)
    }
    
    @objc func actionAddressDetail(_ sender: SubMenuItem){
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm"
        let now = Date()
        let addressDetailView = WindowViewController(title:f.string(from: now) ,TokenListView().environmentObject(sender.setting!))
        addressDetailView.showWindow(sender)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @objc func actionCopyToClipboard(_ sender: SubMenuItem){
        if let address = sender.setting?.address {
            let board = NSPasteboard.general
            board.clearContents()
            board.setString(address, forType: .string)
        }
    }
    
    @objc func actionPreference(_ sender: AppMenuItem){
        if let prefsView = self.prefsView, prefsView.prefsWindowDelegate.windowIsOpen {
            prefsView.window.makeKeyAndOrderFront(self)
        } else {
            prefsView = PrefsView(prefs: UserStatus.shared.prefs)
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func actionResetAddress(_ sender: NSMenuItem){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Constants.ethAddressKey)
        self.appMenu.removeAllItems()
        UserDefaults.standard.removeObject(forKey: Constants.activeAddress)
        UserStatus.shared.activeAddress = nil
        UserStatus.shared.ethplorerGetAddressInfo = nil
        UserStatus.shared.ethPriceViewIntervalChecker = nil
        UserStatus.shared.gasPriceViewIntervalChecker = nil
        constructMenu()
    }
    
    @objc func actionMenu(_ sender: AppMenuItem) {
        changeState(sender)
    }
    
    func togglePopover(_ sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
            eventMonitor?.start()
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
    
    @objc func addNewAddressMenu(notificationCenter:NSNotification) {
        self.appMenu.removeAllItems()
        UserStatus.shared.ethPriceViewIntervalChecker = nil
        UserStatus.shared.gasPriceViewIntervalChecker = nil
        constructMenu()
    }
    
    func constructMenu() {
        if let currentVer = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let prodVer = RemoteConfigHandler.shared.getRemoteConfigValueString(.serviceVersion) {
            // for the apple reviewer mode
            if currentVer.compare(prodVer, options: .numeric) == .orderedDescending {
                return constructReviewerModeMenu()
            }
        }
        registerNewAddress.target = self
        self.appMenu.addItem(registerNewAddress)
        self.appMenu.addItem(NSMenuItem.separator())
        setAddressMenuItems()
        preference.target = self
        setViewMenu(menuitem: ethStatusMenuView, height: 50)
        self.appMenu.addItem(NSMenuItem.separator())
        setViewMenu(menuitem: gasIndicatorMenuView, height: 80)
        self.appMenu.addItem(NSMenuItem.separator())
        self.appMenu.addItem(preference)
        self.appMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = appMenu
    }
    
    func constructReviewerModeMenu(){
//        let prefs = UserStatus.shared.prefs
//        let array = ["0x3dfd23a6c5e8bbcfc9581d2e864a68feb6a076d3", "0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5"]
//        prefs.ethAddresses = array
//        
//        setAddressMenuItems()
        setViewMenu(menuitem: ethStatusMenuView, height: 50)
        self.appMenu.addItem(NSMenuItem.separator())
        setViewMenu(menuitem: gasIndicatorMenuView, height: 80)
        self.appMenu.addItem(NSMenuItem.separator())
        self.appMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = appMenu
    }
    
    private func setViewMenu<T: View>(menuitem view:T, height:UInt){
        let menuItem = NSMenuItem()
        let view = NSHostingView(rootView: view)
        var menuSize = self.appMenu.size
        if menuSize.width == 0 {
            menuSize.width = 185
        }
        let x = (menuSize.width) * 0.5
        let y = (menuSize.height) * 0.5
        os_log("Coordinate x: %f, y: %f, width: %f", x,y,menuSize.width)
        view.frame = NSRect(x: x, y: y, width: menuSize.width, height: CGFloat(height))
        menuItem.view = view
        self.appMenu.addItem(menuItem)
    }
    
    func setAddressMenuItems() {
        let defaults = UserDefaults.standard
        if let addresses = defaults.stringArray(forKey: Constants.ethAddressKey) {
            for eth in addresses {
                let name = EthereumUtil.getAbbreviateAddress(eth, (6,4))
                let menu  = AppMenuItem(title: name,  action: #selector(StatusBarController.actionMenu(_:)),  keyEquivalent: "")
                menu.target = self
                menu.ethAddress = eth
                self.appMenu.addItem(menu)
                if let activeAddress = UserDefaults.standard.string(forKey: Constants.activeAddress), eth == activeAddress {
                    menu.state = NSControl.StateValue.on
                }
                var subMenu = SubMenu()
                subMenu.ethAddress = eth
                subMenu = getDetailSubMenu(subMenu)
                subMenu = getCopyClipboardSubMenu(subMenu)
                menu.submenu = getExternalLinkSubMenu(subMenu, type: ExternalSiteApi.etherscan)
                menu.submenu = getExternalLinkSubMenu(subMenu, type: ExternalSiteApi.ethplorer)
            }
            self.appMenu.addItem(NSMenuItem.separator())
        } else {
            showImageStatusBar()
        }
    }
    
    func getExternalLinkSubMenu(_ subMenu: SubMenu, type: ExternalSiteApi) -> SubMenu {
        let externalLinkMenu = SubMenuItem(title: "Check on \(type.rawValue)",  action: #selector(StatusBarController.openUrl(_:)),  keyEquivalent: "")
        if let format = Constants.externalTokenUrl[type.rawValue] {
            let link = String(format: format, subMenu.ethAddress!)
            externalLinkMenu.link = URL(string: link)
            externalLinkMenu.target = self
            subMenu.addItem(externalLinkMenu)
        }
        return subMenu
    }
    
    func getDetailSubMenu(_ subMenu: SubMenu) -> SubMenu {
        let detailMenu  = SubMenuItem(title: "Details...",  action: #selector(StatusBarController.actionAddressDetail(_:)),  keyEquivalent: "")
        detailMenu.target = self
        let setting = EthereumSetting()
        setting.address = subMenu.ethAddress!
        detailMenu.setting = setting
        subMenu.addItem(detailMenu)
        return subMenu
    }
    
    func getCopyClipboardSubMenu(_ subMenu: SubMenu) -> SubMenu {
        let copyClipboardMenu  = SubMenuItem(title: "Copy this address to clipboard",  action: #selector(StatusBarController.actionCopyToClipboard(_:)),  keyEquivalent: "")
        copyClipboardMenu.target = self
        let setting = EthereumSetting()
        setting.address = subMenu.ethAddress!
        copyClipboardMenu.setting = setting
        subMenu.addItem(copyClipboardMenu)
        return subMenu
    }
    
    @objc func openUrl(_ sender: SubMenuItem){
        if let link = sender.link {
            NSWorkspace.shared.open(link)
        }
    }
}
