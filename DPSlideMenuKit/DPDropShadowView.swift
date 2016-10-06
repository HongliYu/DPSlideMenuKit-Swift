//
//  DPDropShadowView.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
import Foundation

open class DPDropShadowView: UIView {

  override open func draw(_ rect: CGRect) {
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowOpacity = 0.7
    self.layer.shadowPath = UIBezierPath(rect:self.bounds).cgPath
  }
  
}
