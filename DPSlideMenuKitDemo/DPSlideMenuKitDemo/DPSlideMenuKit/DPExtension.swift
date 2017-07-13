//
//  DPExtension.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import Foundation
import UIKit

public extension CGFloat {
  
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
  
}

public extension UIColor {
  
  static func random() -> UIColor {
    return UIColor(red:   .random(),
                   green: .random(),
                   blue:  .random(),
                   alpha: 1.0)
  }
  
}

public extension String {
  
  var localized: String {
    return NSLocalizedString(self,
                             tableName: nil,
                             bundle: Bundle.main,
                             value: "",
                             comment: "")
  }
  
}

public extension Int {
  
  func times(f: () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        f()
      }
    }
  }
  
  func times(f: @autoclosure () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        f()
      }
    }
  }
  
}

public extension UIFont {
  
  class func fontAwesome(ofSize: CGFloat) -> UIFont? {
    return UIFont(name: "FontAwesome", size: ofSize)
  }
  
}

public extension UIViewController {
  
  /**
   1. If storyboardName is nil, then the view controller is generated from code
   2. If storyboardName is not nil, then try to generate the view controller from story board
   */
  static func generateViewControllersFrom(viewControllerNameArray: [String],
                                          storyboardName: String?, bundle: Bundle?) -> [UIViewController] {
    var retViewControllerArray: [UIViewController] = []
    var relatedStoryboard: UIStoryboard?
    if storyboardName == nil {
      relatedStoryboard = nil
    } else {
      relatedStoryboard = UIStoryboard(name: storyboardName!, bundle: bundle)
    }
    for controllerClassName in viewControllerNameArray {
      var leftMenuViewController: UIViewController?
      if relatedStoryboard != nil {
        let SBIdentifier = controllerClassName
        leftMenuViewController = relatedStoryboard?.instantiateViewController(withIdentifier: SBIdentifier)
      } else {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + controllerClassName
        let aClass = NSClassFromString(className) as! UIViewController.Type
        leftMenuViewController = aClass.init()
      }
      if leftMenuViewController != nil { // vital issue
        retViewControllerArray.append(leftMenuViewController!)
      }
    }
    return retViewControllerArray
  } // TODO: What about xib
  
  func alert(_ title: String, message: String? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let dismiss = "Dismiss"
    alertController.addAction(UIAlertAction(title: dismiss, style: UIAlertActionStyle.default, handler: nil))
    alertController.view.tintColor = UIColor.red
    present(alertController, animated: true, completion: {
      alertController.view.tintColor = UIColor.red
    })
  }
  
}
