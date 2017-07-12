//
//  DPBaseEmbedViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPBaseEmbedViewController: UIViewController {
  
  fileprivate (set) var positionState: DPEmbedViewControllerPositionState = .left
  
  func setPositionState(positionState: DPEmbedViewControllerPositionState) {
    self.positionState = positionState
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    

}
