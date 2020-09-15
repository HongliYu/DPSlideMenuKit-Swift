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
    return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
  }
  
}

public extension String {
  
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
  
}

public extension Int {
  
  func times(block: () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        block()
      }
    }
  }
  
  func times(block: @autoclosure () -> ()) {
    if self > 0 {
      for _ in 0..<self {
        block()
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

  /// Generate view controllers from storyboard or code
  /// - Parameters:
  ///   - type: view controller type array
  ///   - storyboard: default is 'Main', need to be set as nil, if the view controller is not gererated from the storyboard
  ///   - bundle: Bundle
  /// - Returns: view controller array
  static func viewControllers(_ types: [UIViewController.Type]?, storyboard: String? = "Main",
                              bundle: Bundle? = nil) -> [UIViewController]? {
    guard let types = types else { return nil }
    let typeStrings = types.map{ String(describing: $0) }
    var retControllers: [UIViewController] = []
    for typeString in typeStrings {
      if let storyboard = storyboard {
        let relatedStoryboard = UIStoryboard(name: storyboard, bundle: bundle)
        let controller = relatedStoryboard.instantiateViewController(withIdentifier: typeString)
        retControllers.append(controller)
      } else {
        guard let CFBundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String,
          let aClass = NSClassFromString("\(CFBundleName).\(typeString)") as? UIViewController.Type
          else { continue }
        retControllers.append(aClass.init())
      }
    }
    return retControllers
  }

  /// Generate view controller from storyboard or code
  /// - Parameters:
  ///   - type: view controller type
  ///   - storyboard: default is 'Main'
  ///   - bundle: Bundle
  /// - Returns: a view controller
  static func viewController(_ type: UIViewController.Type?, storyboard: String? = "Main",
                             bundle: Bundle? = nil) -> UIViewController? {
    guard let type = type else { return nil }
    let typeString = String(describing: type)
    if let storyboard = storyboard {
      let relatedStoryboard = UIStoryboard(name: storyboard, bundle: bundle)
      return relatedStoryboard.instantiateViewController(withIdentifier: typeString)
    } else {
      guard let CFBundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String,
        let aClass = NSClassFromString("\(CFBundleName).\(typeString)") as? UIViewController.Type
        else { return nil }
      return aClass.init()
    }
  }

  func instantiateVC<T: UIViewController>(_ type: T.Type) -> T? {
    let id = String(describing: T.self)
    return storyboard?.instantiateViewController(withIdentifier: id) as? T
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

}

public extension UITableView {
  
  func registerCell(cellTypes: [AnyClass]) {
    for cellType in cellTypes {
      let typeString = String(describing: cellType)
      let xibPath = Bundle(for: cellType).path(forResource: typeString, ofType: "nib")
      if xibPath == nil {
        register(cellType, forCellReuseIdentifier: typeString)
      } else {
        register(UINib(nibName: typeString, bundle: nil),
                 forCellReuseIdentifier: typeString)
      }
    }
  }
  
}

extension ScreenType: Comparable {

  public static func < (lhs: ScreenType, rhs: ScreenType) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }

}

public extension UIScreen {

  static var current: ScreenType {
    let screenLongestSide: CGFloat = max(main.bounds.width, main.bounds.height)
    switch screenLongestSide {
    case 480:
      return .iPhone3_5
    case 568:
      return .iPhone4_0
    case 667:
      return .iPhone4_7
    case 736:
      return .iPhone5_5
    case 812:
      return .iPhone5_8
    case 896:
      return main.scale == 3 ? .iPhone6_5 : .iPhone6_1
    case 1024:
      return .iPad9_7
    case 1112:
      return .iPad10_5
    case 1366:
      return .iPad12_9
    default:
      return .unknown
    }
  }

  var iPhoneBangsScreen: Bool {
    return UIScreen.current == .iPhone5_8
      || UIScreen.current == .iPhone6_1
      || UIScreen.current == .iPhone6_5
  }

}
