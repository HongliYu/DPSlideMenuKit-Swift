//
//  DPContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

public class DPContentViewController: UIViewController {
  
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
  private var drawerControllerWillOpenStored:(()->Void)?

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
  private var drawerControllerDidOpenStored:(()->Void)?

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
  private var drawerControllerWillCloseStored:(()->Void)?

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
  private var drawerControllerDidCloseStored:(()->Void)?
  
  weak var drawer: DPDrawerViewController?
  private var openDrawerButton: DPMenuButton = DPMenuButton.init(type:.Custom)
  
  // MARK: Life Cycle
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.openDrawerButton.frame = CGRectMake(8.0, 25.0, 34.0, 34.0)
    self.openDrawerButton.addTarget(self, action: #selector(openDrawer(_:)),
                                     forControlEvents: .TouchUpInside)
    self.openDrawerButton.lineWidth = 34.0
    self.openDrawerButton.lineMargin = 12
    self.openDrawerButton.lineCapRound = true
    self.openDrawerButton.thickness = 6
    self.openDrawerButton.slideLeftToRight = false
    self.openDrawerButton.backgroundColor = UIColor.clearColor()
    self.openDrawerButton.cornerRadius = 0
    self.view.addSubview(self.openDrawerButton)
    
    self.drawerControllerWillOpen = {
      [weak self] in
      if let this = self {
        this.view.userInteractionEnabled = false
        this.openDrawerButton.selected = true
      }
    }
    
    self.drawerControllerDidOpen = {

    }

    self.drawerControllerWillClose = {
      [weak self] in
      if let this = self {
        this.openDrawerButton.selected = false
      }
    }
    
    self.drawerControllerDidClose = {
      [weak self] in
      if let this = self {
        this.view.userInteractionEnabled = true
      }
    }

  }
  
  // MARK: Actions
  func openDrawer(sender: DPMenuButton) {
    if self.drawer?.drawerState == .DPDrawerControllerStateOpen {
      self.drawer?.close()
      sender.selected = false
    } else {
      self.drawer?.open()
      sender.selected = true
    }
  }
  
}
