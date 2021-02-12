//
//  StatusBarController.swift
//  DefiTicker
//
//  Created by Chon, Felix | Felix | DCMS on 2020/11/18.
//

import AppKit
import SwiftUI
import os

class AppMenu : NSMenuItem {
    open var ethAddress:String?
}

class StatusBarController {
  
    private var statusItem: NSStatusItem
    private var eventMonitor: EventMonitor?

    var popover = NSPopover.init()
    let bridge = RegisterAddressViewModel()
    
    var appMenu = NSMenu()
    var subMenu = NSMenu()
    
    let registerNewAddress  = NSMenuItem(title: "Add new address",  action: #selector(StatusBarController.actionMenuAddNewAddress(_:)),  keyEquivalent: "")
    let resetAddresses  = NSMenuItem(title: "reset",  action: #selector(StatusBarController.actionResetAddress(_:)),  keyEquivalent: "")

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

    @objc func updateData(){
        let updateMenuPrice: () -> Void = {
            if let totalValue = UserStatus.shared.getTotalValue(), let button = self.statusItem.button {
                button.image = nil
                button.title = "$\(totalValue)"
                self.statusItem.length = button.title.widthForButton()
            }
        }
        PriceService.getCurrentTotalValue(updateMenuPrice)
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText   = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
    
    func changeState(_ sender: AppMenu) {
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
    
    @objc func actionMenuAddNewAddress(_ sender: AppMenu){
        bridge.registerAction = { (ethAddr: String) -> Void in
            RegisterService.registerAddress(ethAddr)
            self.togglePopover(sender)
        }
        let contentView = RegisterAddressView(vm: bridge)
        let vc = NSHostingView(rootView: contentView)
        popover.contentViewController?.view = vc
        togglePopover(sender)
    }
  
    @objc func actionResetAddress(_ sender: NSMenuItem){
        RegisterService.reset()
        
    }
    
    @objc func actionMenu(_ sender: AppMenu) {
        changeState(sender)
        // do menu 1 stuff
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
            let name = getAbbreviateAddress(newAddr)
            let menu  = AppMenu(title: name,  action: #selector(StatusBarController.actionMenu(_:)),  keyEquivalent: "")
            menu.ethAddress = newAddr
            menu.target = self
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
        
        self.appMenu.addItem(registerNewAddress)
        self.appMenu.addItem(resetAddresses)
        self.appMenu.addItem(NSMenuItem.separator())
        setAddressMenuItems()
        setViewMenu(menuitem: ethStatusMenuView, height: 50)
        self.appMenu.addItem(NSMenuItem.separator())
        setViewMenu(menuitem: gasIndicatorMenuView, height: 80)
        self.appMenu.addItem(NSMenuItem.separator())
        self.appMenu.addItem(NSMenuItem(title: "Preference", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "p"))
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
                let name = getAbbreviateAddress(eth)
                let menu  = AppMenu(title: name,  action: #selector(StatusBarController.actionMenu(_:)),  keyEquivalent: "")
                menu.target = self
                menu.ethAddress = eth
                self.appMenu.addItem(menu)
                if let activeAddress = UserDefaults.standard.string(forKey: Constants.activeAddress), eth == activeAddress {
                    menu.state = NSControl.StateValue.on
                }
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
    
    func getAbbreviateAddress(_ ethAddr: String) -> String {
        let prefix = ethAddr.prefix(6)
        let suffix = ethAddr.suffix(4)
        return "\(prefix)...\(suffix)"
    }
    
}
extension String {
    func widthForButton() -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: nil, context: nil)
        return ceil(boundingBox.width + 20)
    }
}
