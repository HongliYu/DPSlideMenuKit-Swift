//
//  DPBaseEmbedViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPBaseEmbedViewController: UIViewController {
  
  fileprivate (set) var positionState: DPEmbedViewControllerPositionState = .left
  
  func setPositionState(positionState: DPEmbedViewControllerPositionState) {
    self.positionState = positionState
  }
  
  override public func viewDidLoad() {
      super.viewDidLoad()
  }

  override public func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
}
