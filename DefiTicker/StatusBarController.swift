//
//  StatusBarController.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
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
    // Create the SwiftUI view that provides the window contents.
    lazy var bridge = RegisterAddressViewModel()
    lazy var preferenceView =  WindowViewController(PrefsView(prefs: Prefs()))
    
    var appMenu = NSMenu()
    
    let registerNewAddress  = NSMenuItem(title: "Add new address",  action: #selector(StatusBarController.actionMenuAddNewAddress(_:)),  keyEquivalent: "")
    let resetAddresses  = NSMenuItem(title: "reset",  action: #selector(StatusBarController.actionResetAddress(_:)),  keyEquivalent: "")
    let preference = NSMenuItem(title: "Preference", action: #selector(StatusBarController.actionPreference(_:)), keyEquivalent: "p")
    var priceUpdateTimer: Timer?
    
    var gasIndicatorMenuView:GasIndicatorView = GasIndicatorView()
    var ethStatusMenuView:EthStatusMenuView = EthStatusMenuView()
    
    
    
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
                         selector:#selector(self.resetMenu),
                         name: .resetMenu,
                         object: nil)
        bridge.closeAction = {
            self.popover.close()
        }
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentViewController = MainViewController()
        popover.contentSize = NSSize(width: 500, height: 100)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "turtle")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
        }
        updateData()
        priceUpdateTimer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        
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
    
    @objc func updateData(){
        let updateMenuPrice: (JSON) -> Void = {json in
            UserStatus.shared.ethplorerGetAddressInfo = EthplorerGetAddressInfo(getAddressInfo: json)
            var missingTotal:Double = 0
            if let dict = UserStatus.shared.ethplorerGetAddressInfo?.priceFalseKV, dict.count > 0 {
                os_log("some coins price were missing. count: %d", dict.count)
                PriceService.updateTokenPriceFromCoinGecko(Array(dict.keys)){
                    data in
                    let simpleToken = CoinGeckoSimpleTokenPrice(data: data)
                    simpleToken.array.forEach { priceInfo in
                        if let bal = dict[priceInfo.key], bal > 0{
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
        // Loops over the array of menu items
        for menuItem in appMenu.items {
            // Switches off the first (and unique) 'on' item
            if  menuItem.state == NSControl.StateValue.on {
                menuItem.state = NSControl.StateValue.off
                break
            }
        }
        if let addr = sender.ethAddress {
            UserDefaults.standard.setValue(addr, forKey: Constants.activeAddress)
            UserStatus.shared.activeAddress = addr
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
        let addressDetailView = WindowViewController(AddressDetailView().environmentObject(sender.setting!))
        addressDetailView.showWindow(sender)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @objc func actionPreference(_ sender: AppMenuItem){
        preferenceView.showWindow(sender)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @objc func actionResetAddress(_ sender: NSMenuItem){
        RegisterService.reset()
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
        if let newAddr = notificationCenter.object as? String {
            let name = EthereumUtil.getAbbreviateAddress(newAddr)
            let menu  = AppMenuItem(title: name,  action: #selector(StatusBarController.actionMenu(_:)),  keyEquivalent: "")
            menu.ethAddress = newAddr
            menu.target = self
            var subMenu = SubMenu()
            subMenu.ethAddress = newAddr
            subMenu = getDetailSubMenu(subMenu)
            menu.submenu = getExternalLinkSubMenu(subMenu, type: ExternalSite.etherscan)
            menu.submenu = getExternalLinkSubMenu(subMenu, type: ExternalSite.ethplorer)
            self.appMenu.insertItem(menu, at:3)
            if UserStatus.shared.numOfMenus == 0 {
                self.appMenu.insertItem(NSMenuItem.separator(), at:4)
            }
            UserStatus.shared.numOfMenus += 1
        }
    }
    
    @objc func resetMenu(){
        self.appMenu.removeAllItems()
        UserDefaults.standard.removeObject(forKey: Constants.activeAddress)
        UserStatus.shared.numOfMenus = 0
        UserStatus.shared.activeAddress = nil
        UserStatus.shared.ethplorerGetAddressInfo = nil
        constructMenu()
    }
    
    func constructMenu() {
        registerNewAddress.target = self
        resetAddresses.target = self
        preference.target = self
        
        self.appMenu.addItem(registerNewAddress)
        self.appMenu.addItem(resetAddresses)
        self.appMenu.addItem(NSMenuItem.separator())
        setAddressMenuItems()
        setViewMenu(menuitem: ethStatusMenuView, height: 50)
        self.appMenu.addItem(NSMenuItem.separator())
        setViewMenu(menuitem: gasIndicatorMenuView, height: 80)
        self.appMenu.addItem(NSMenuItem.separator())
        self.appMenu.addItem(preference)
        self.appMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = appMenu
    }
    
    private func setViewMenu<T: View>(menuitem view:T, height:UInt){
        let gasMenuItem = NSMenuItem()
        let view = NSHostingView(rootView: view)
        let menuSize = self.appMenu.size
        let x = (menuSize.width) * 0.5
        let y = (menuSize.height) * 0.5
        view.frame = NSRect(x: x, y: y, width: menuSize.width, height: CGFloat(height))
        gasMenuItem.view = view
        self.appMenu.addItem(gasMenuItem)
    }
    
    func setAddressMenuItems() {
        let defaults = UserDefaults.standard
        if let addresses = defaults.stringArray(forKey: Constants.ethAddressKey) {
            for eth in addresses {
                let name = EthereumUtil.getAbbreviateAddress(eth)
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
                menu.submenu = getExternalLinkSubMenu(subMenu, type: ExternalSite.etherscan)
                menu.submenu = getExternalLinkSubMenu(subMenu, type: ExternalSite.ethplorer)
                UserStatus.shared.numOfMenus += 1
            }
            self.appMenu.addItem(NSMenuItem.separator())
        } else {
            if let statusBarButton = statusItem.button {
                statusBarButton.title = ""
                statusBarButton.image = #imageLiteral(resourceName: "turtle")
                statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
                statusBarButton.image?.isTemplate = true
            }
        }
    }
    
    func getExternalLinkSubMenu(_ subMenu: SubMenu, type: ExternalSite) -> SubMenu {
        let externalLinkMenu = SubMenuItem(title: "Check on \(type.rawValue)",  action: #selector(StatusBarController.openUrl(_:)),  keyEquivalent: "")
        if let format = Constants.externalServiceUrl[type.rawValue] {
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
    
    @objc func openUrl(_ sender: SubMenuItem){
        if let link = sender.link {
            NSWorkspace.shared.open(link)
        }
    }
}

extension String {
    func widthForButton() -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: nil, context: nil)
        return ceil(boundingBox.width + 20)
    }
}
