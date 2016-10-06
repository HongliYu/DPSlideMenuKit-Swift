//
//  DPSlideMenuModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/18/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

open class DPSlideMenuModel {
  
  fileprivate(set) open var color: UIColor?
  fileprivate(set) open var controllerClassName: String?
  fileprivate(set) open var title: String?
  fileprivate(set) open var cellHeight: CGFloat?

  var actionBlock:(()->Void)? {
    set(actionBlock) {
      if let aActionBlock = actionBlock {
        self.actionBlockStored = aActionBlock
      }
    }
    get {
      return self.actionBlockStored
    }
  }
  fileprivate var actionBlockStored:(()->Void)?

  public init(color: UIColor?,
              controllerClassName: String?,
              title: String?,
              cellHeight: CGFloat?,
              actionBlock: (()->Void)?) {
    self.color = color
    let prodName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    if controllerClassName != nil && prodName != nil {
      self.controllerClassName = prodName! + "." + controllerClassName!
    }
    self.title = title
    self.cellHeight = cellHeight
    self.actionBlock = actionBlock
  }
  
}
