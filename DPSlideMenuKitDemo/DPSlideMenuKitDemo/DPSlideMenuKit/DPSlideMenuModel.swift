//
//  DPSlideMenuModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/18/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

public class DPSlideMenuModel {
  
  private(set) public var color: UIColor?
  private(set) public var controllerClassName: String?
  private(set) public var title: String?
  private(set) public var cellHeight: CGFloat?

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
  private var actionBlockStored:(()->Void)?

  public init(color: UIColor?,
              controllerClassName: String?,
              title: String?,
              cellHeight: CGFloat?,
              actionBlock: (()->Void)?) {
    self.color = color
    let prodName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
    if controllerClassName != nil && prodName != nil {
      self.controllerClassName = prodName! + "." + controllerClassName!
    }
    self.title = title
    self.cellHeight = cellHeight
    self.actionBlock = actionBlock
  }
  
}
