//
//  DPDropShadowView.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
import Foundation

public class DPDropShadowView: UIView {

  override public func drawRect(rect: CGRect) {
    self.layer.shadowOffset = CGSizeZero
    self.layer.shadowOpacity = 0.7
    self.layer.shadowPath = UIBezierPath(rect:self.bounds).CGPath
  }
  
}
