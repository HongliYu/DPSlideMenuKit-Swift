//
//  DPCenterContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

open class DPCenterContentViewController: UIViewController {
  
  var drawerControllerWillOpen:((_ drawerButtonAnimated: Bool)->Void)?
  var drawerControllerDidOpen:((_ drawerButtonAnimated: Bool)->Void)?
  var drawerControllerWillClose:((_ drawerButtonAnimated: Bool)->Void)?
  var drawerControllerDidClose:((_ drawerButtonAnimated: Bool)->Void)?
  
  fileprivate var openDrawerButton: DPMenuButton = DPMenuButton(type:.custom)
  
  // MARK: Life Cycle
  override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    if DPSlideMenuManager.shared.leftMenuViewController == nil { return }
    
    self.openDrawerButton.frame = kDPDrawerButtonRect
    if UIScreen.current == .iPhone5_8 {
      self.openDrawerButton.frame = kDPDrawerButtonRect_iPhoneX
    }
    self.openDrawerButton.addTarget(self, action: #selector(openDrawer(_:)), for: .touchUpInside)
    self.openDrawerButton.lineWidth = 34.0
    self.openDrawerButton.lineMargin = 12
    self.openDrawerButton.lineCapRound = true
    self.openDrawerButton.thickness = 6
    self.openDrawerButton.slideLeftToRight = false
    self.openDrawerButton.backgroundColor = UIColor.clear
    self.openDrawerButton.cornerRadius = 0
    self.view.addSubview(self.openDrawerButton)
    
    self.drawerControllerWillOpen = {
      [weak self] drawerButtonAnimated in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = false
      if drawerButtonAnimated {
        strongSelf.openDrawerButton.isSelected = true
      }
    }
    
    self.drawerControllerDidOpen = nil
    
    self.drawerControllerWillClose = {
      [weak self] drawerButtonAnimated in
      guard let strongSelf = self else { return }
      if drawerButtonAnimated {
        strongSelf.openDrawerButton.isSelected = false
      }
    }
    
    self.drawerControllerDidClose = {
      [weak self] drawerButtonAnimated in
      guard let strongSelf = self else { return }
      strongSelf.view.isUserInteractionEnabled = true
    }

  }
  
  // MARK: Actions
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
