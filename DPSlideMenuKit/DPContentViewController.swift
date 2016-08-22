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
        self.view.userInteractionEnabled = false
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
        self.view.userInteractionEnabled = true
        self.drawerControllerDidCloseStored = aDrawerControllerDidClose
      }
    }
    get {
      return self.drawerControllerDidCloseStored
    }
  }
  private var drawerControllerDidCloseStored:(()->Void)?
  
  weak var drawer: DPDrawerViewController?
  private var openDrawerButton: UIButton = UIButton.init(type:.Custom)
  
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
    self.openDrawerButton.setTitle("\u{0000e9bd}", forState: .Normal)
    self.openDrawerButton.titleLabel?.font = UIFont.init(name: "dp_iconfont", size: 28.0)
    self.openDrawerButton.addTarget(self, action: #selector(openDrawer(_:)),
                                     forControlEvents: .TouchUpInside)
    self.view.addSubview(self.openDrawerButton)
  }
  
  // MARK: Actions
  func openDrawer(sender: AnyObject) {
    if self.drawer?.drawerState == .DPDrawerControllerStateOpen {
      self.drawer?.close()
    } else {
      self.drawer?.open()
    }
  }
  
}
