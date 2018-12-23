//
//  DPBaseEmbedViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

open class DPBaseEmbedViewController: UIViewController {
  
  open var positionState: DPEmbedViewControllerPositionState = .left
  
  open func setPositionState(positionState: DPEmbedViewControllerPositionState) {
    self.positionState = positionState
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideStatusBar(true)
  }
  
  open func hideStatusBar(_ hide: Bool) {
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    statusBar.isHidden = hide
  }

}
