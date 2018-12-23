//
//  DPCenterContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

open class DPCenterContentViewController: UIViewController {
  
  open var drawerControllerWillOpen:((_ drawerButtonAnimated: Bool)->Void)?
  open var drawerControllerDidOpen:((_ drawerButtonAnimated: Bool)->Void)?
  open var drawerControllerWillClose:((_ drawerButtonAnimated: Bool)->Void)?
  open var drawerControllerDidClose:((_ drawerButtonAnimated: Bool)->Void)?
  open var openDrawerButton: DPMenuButton = DPMenuButton(type:.custom)
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    guard DPSlideMenuManager.shared.leftMenuViewController != nil else { return }

    openDrawerButton.frame = kDPDrawerButtonRect
    if UIScreen().iPhoneBangsScreen {
      openDrawerButton.frame = kDPDrawerButtonRect_Bangs
    }
    openDrawerButton.addTarget(self, action: #selector(openDrawer(_:)), for: .touchUpInside)
    openDrawerButton.lineWidth = 34.0
    openDrawerButton.lineMargin = 12
    openDrawerButton.lineCapRound = true
    openDrawerButton.thickness = 6
    openDrawerButton.slideLeftToRight = false
    openDrawerButton.backgroundColor = UIColor.clear
    openDrawerButton.cornerRadius = 0
    view.addSubview(openDrawerButton)
    
    drawerControllerWillOpen = {
      [weak self] drawerButtonAnimated in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = false
      if drawerButtonAnimated {
        strongSelf.openDrawerButton.isSelected = true
      }
    }
    
    drawerControllerDidOpen = nil
    
    drawerControllerWillClose = {
      [weak self] drawerButtonAnimated in
      guard let strongSelf = self else { return }
      if drawerButtonAnimated {
        strongSelf.openDrawerButton.isSelected = false
      }
    }
    
    drawerControllerDidClose = {
      [weak self] drawerButtonAnimated in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = true
    }

  }
  
  @objc func openDrawer(_ sender: DPMenuButton) {
    if DPSlideMenuManager.shared.drawer?.drawerState == .leftOpen {
      DPSlideMenuManager.shared.drawer?.leftClose()
      sender.isSelected = false
    } else {
      DPSlideMenuManager.shared.drawer?.leftOpen()
      sender.isSelected = true
    }
  }
  
}
