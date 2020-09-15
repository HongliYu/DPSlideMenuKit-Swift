//
//  DPEnum.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import Foundation

public enum DrawerControllerState: Int {
  
  case closed = 0
  case leftOpen
  case rightOpen
  case leftClosing
  case leftOpening
  case rightClosing
  case rightOpening

  var description: String {
    switch self {
    case .closed:
      return "closed"
    case .leftOpen:
      return "left open"
    case .rightOpen:
      return "right open"
    case .leftClosing:
      return "left closing"
    case .leftOpening:
      return "left opening"
    case .rightClosing:
      return "right closing"
    case .rightOpening:
      return "right opening"
    }
  }
  
}

public enum MenuPosition {
  
  case left
  case right
  
  var description: String {
    switch self {
    case .left:
      return "left menu"
    case .right:
      return "right menu"
    }
  }
  
}

public enum ScreenType: Int {
  /// 3.5 inch iPhone (4, 4S)
  case iPhone3_5

  /// 4.0 inch iPhone (5, 5S, 5C, SE)
  case iPhone4_0

  /// 4.7 inch iPhone (6, 7, 8)
  case iPhone4_7

  /// 5.5 inch iPhone (6+, 7+, 8+)
  case iPhone5_5

  /// 5.8 inch iPhone (X, XS)
  case iPhone5_8

  /// 6.1 inch iPhone (XR)
  case iPhone6_1

  /// 6.5 inch iPhone (XS Max)
  case iPhone6_5

  /// 9.7 inch iPad
  case iPad9_7

  /// 10.5 inch iPad
  case iPad10_5

  /// 12.9 inch iPad
  case iPad12_9

  /// Couldn't determine device
  case unknown
}
