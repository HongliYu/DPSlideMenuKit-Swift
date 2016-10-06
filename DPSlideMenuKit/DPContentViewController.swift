//
//  DPContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

open class DPContentViewController: UIViewController {
  
  var drawerControllerWillOpen:(()->Void)? {
    set(drawerControllerWillOpen) {
      if let aDrawerControllerWillOpen = drawerControllerWillOpen {
        self.drawerControllerWillOpenStored = aDrawerControllerWillOpen
      }
    }
    get {
      return self.drawerControllerWillOpenStored
    }
  }
  fileprivate var drawerControllerWillOpenStored:(()->Void)?

  var drawerControllerDidOpen:(()->Void)? {
    set(drawerControllerDidOpen) {
      if let aDrawerControllerDidOpen = drawerControllerDidOpen {
        self.drawerControllerDidOpenStored = aDrawerControllerDidOpen
      }
    }
    get {
      return self.drawerControllerDidOpenStored
    }
  }
  fileprivate var drawerControllerDidOpenStored:(()->Void)?

  var drawerControllerWillClose:(()->Void)? {
    set(drawerControllerWillClose) {
      if let aDrawerControllerWillClose = drawerControllerWillClose {
        self.drawerControllerWillCloseStored = aDrawerControllerWillClose
      }
    }
    get {
      return self.drawerControllerWillCloseStored
    }
  }
  fileprivate var drawerControllerWillCloseStored:(()->Void)?

  var drawerControllerDidClose:(()->Void)? {
    set(drawerControllerDidClose) {
      if let aDrawerControllerDidClose = drawerControllerDidClose {
        self.drawerControllerDidCloseStored = aDrawerControllerDidClose
      }
    }
    get {
      return self.drawerControllerDidCloseStored
    }
  }
  fileprivate var drawerControllerDidCloseStored:(()->Void)?
  
  weak var drawer: DPDrawerViewController?
  fileprivate var openDrawerButton: DPMenuButton = DPMenuButton.init(type:.custom)
  
  // MARK: Life Cycle
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    self.openDrawerButton.frame = CGRect(x: 8.0, y: 25.0, width: 34.0, height: 34.0)
    self.openDrawerButton.addTarget(self, action: #selector(openDrawer(_:)),
                                     for: .touchUpInside)
    self.openDrawerButton.lineWidth = 34.0
    self.openDrawerButton.lineMargin = 12
    self.openDrawerButton.lineCapRound = true
    self.openDrawerButton.thickness = 6
    self.openDrawerButton.slideLeftToRight = false
    self.openDrawerButton.backgroundColor = UIColor.clear
    self.openDrawerButton.cornerRadius = 0
    self.view.addSubview(self.openDrawerButton)
    
    self.drawerControllerWillOpen = {
      [weak self] in
      if let this = self {
        this.view.isUserInteractionEnabled = false
        this.openDrawerButton.isSelected = true
      }
    }
    
    self.drawerControllerDidOpen = {

    }

    self.drawerControllerWillClose = {
      [weak self] in
      if let this = self {
        this.openDrawerButton.isSelected = false
      }
    }
    
    self.drawerControllerDidClose = {
      [weak self] in
      if let this = self {
        this.view.isUserInteractionEnabled = true
      }
    }

  }
  
  // MARK: Actions
  func openDrawer(_ sender: DPMenuButton) {
    if self.drawer?.drawerState == .dpDrawerControllerStateOpen {
      self.drawer?.close()
      sender.isSelected = false
    } else {
      self.drawer?.open()
      sender.isSelected = true
    }
  }
  
}
