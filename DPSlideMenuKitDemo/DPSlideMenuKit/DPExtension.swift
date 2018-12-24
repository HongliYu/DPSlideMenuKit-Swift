//
//  DPExtension.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public extension CGFloat {
  
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
  
}

public extension UIColor {
  
  static func random() -> UIColor {
    return UIColor(red: .random(),
                   green: .random(),
                   blue: .random(),
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

public extension CALayer {
  func applyAnimation(_ animation: CABasicAnimation) {
    let copy = animation.copy() as! CABasicAnimation
    if copy.fromValue == nil {
      copy.fromValue = self.presentation()!.value(forKeyPath: copy.keyPath!)
    }
    self.add(copy, forKey: copy.keyPath)
    self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
  }
}

public extension UIViewController {
  
  static func baseEmbedControllers(_ types: [UIViewController.Type]?,
                                   storyboard: String? = "Main",
                                   bundle: Bundle? = nil) -> [DPBaseEmbedViewController]? {
    guard let types = types else { return nil }
    let typeStrings = types.map{ String(describing: $0) }
    var retControllers: [DPBaseEmbedViewController] = []
    let relatedStoryboard: UIStoryboard? = (storyboard == nil)
      ? nil
      : UIStoryboard(name: storyboard!, bundle: bundle)
    for typeString in typeStrings {
      let menuViewController = (relatedStoryboard == nil)
        ? {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + typeString
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
        }()
        : {
          return relatedStoryboard!.instantiateViewController(withIdentifier: typeString)
        }()
      if let controller = menuViewController as? DPBaseEmbedViewController {
        retControllers.append(controller)
      }
    }
    return retControllers
  }
  
  static func viewController(_ type: UIViewController.Type?,
                             storyboard: String? = "Main",
                             bundle: Bundle? = nil) -> UIViewController? {
    guard let type = type else { return nil }
    let typeString = String(describing: type)
    let relatedStoryboard: UIStoryboard? = (storyboard == nil)
      ? nil
      : UIStoryboard(name: storyboard!, bundle: bundle)
    if relatedStoryboard == nil {
      let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + typeString
      let aClass = NSClassFromString(className) as! UIViewController.Type
      return aClass.init()
    }
    return relatedStoryboard!.instantiateViewController(withIdentifier: typeString)
  }
  
  func alert(_ title: String, message: String? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let dismiss = "Dismiss"
    alertController.addAction(UIAlertAction(title: dismiss, style: .default, handler: nil))
    alertController.view.tintColor = UIColor.red
    present(alertController, animated: true, completion: {
      alertController.view.tintColor = UIColor.red
    })
  }
  
  func instantiateVC<T: UIViewController>(_ type: T.Type) -> T? {
    let id = String(describing: T.self)
    return storyboard?.instantiateViewController(withIdentifier: id) as? T
  }

}

public extension UITableView {
  
  func registerCell(cellTypes:[AnyClass]) {
    for cellType in cellTypes {
      let typeString = String(describing: cellType)
      let xibPath = Bundle(for: cellType).path(forResource: typeString, ofType: "nib")
      if xibPath == nil {
        register(cellType, forCellReuseIdentifier: typeString)
      }
      else {
        register(UINib(nibName: typeString, bundle: nil),
                 forCellReuseIdentifier: typeString)
      }
    }
  }
  
}
