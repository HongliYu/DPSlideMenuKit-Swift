//
//  DPBaseEmbedViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

open class DPBaseEmbedViewController: UIViewController {
  
  public var positionState: MenuPosition = .left
  
  open func setPositionState(positionState: MenuPosition) {
    self.positionState = positionState
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
  }

}
