//
//  DPLeftMenuViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/17/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
import Foundation

// MARK: Extension
extension String {
  var localized: String {
    return NSLocalizedString(self,
                             tableName: nil,
                             bundle: Bundle.main,
                             value: "",
                             comment: "")
  }
}

// MARK: Constant
let kDPColorsViewControllerCellReuseID: String = "kDPColorsViewControllerCellReuseID"
let kDefaultCellHeight: CGFloat = 88.0
let kDefaultHeaderHeight: CGFloat = 44.0

open class DPLeftMenuViewController: UITableViewController {
  
  var drawerControllerWillOpen:(()->Void)? {
    set(drawerControllerWillOpen) {
      if let aDrawerControllerWillOpen = drawerControllerWillOpen {
        self.drawerControllerWillOpenStored = aDrawerControllerWillOpen
      }
    }
    get {
      return self.drawerControllerWillOpenStored
    }
  }
  fileprivate var drawerControllerWillOpenStored:(()->Void)?
  
  var drawerControllerDidOpen:(()->Void)? {
    set(drawerControllerDidOpen) {
      if let aDrawerControllerDidOpen = drawerControllerDidOpen {
        self.drawerControllerDidOpenStored = aDrawerControllerDidOpen
      }
    }
    get {
      return self.drawerControllerDidOpenStored
    }
  }
  fileprivate var drawerControllerDidOpenStored:(()->Void)?
  
  var drawerControllerWillClose:(()->Void)? {
    set(drawerControllerWillClose) {
      if let aDrawerControllerWillClose = drawerControllerWillClose {
        self.drawerControllerWillCloseStored = aDrawerControllerWillClose
      }
    }
    get {
      return self.drawerControllerWillCloseStored
    }
  }
  fileprivate var drawerControllerWillCloseStored:(()->Void)?
  
  var drawerControllerDidClose:(()->Void)? {
    set(drawerControllerDidClose) {
      if let aDrawerControllerDidClose = drawerControllerDidClose {
        self.drawerControllerDidCloseStored = aDrawerControllerDidClose
      }
    }
    get {
      return self.drawerControllerDidCloseStored
    }
  }
  fileprivate var drawerControllerDidCloseStored:(()->Void)?
  
  weak var drawer: DPDrawerViewController?
  fileprivate(set) open var slideMenuModels: [DPSlideMenuModel]?
  fileprivate(set) open var lastRow: Int = 0
  fileprivate(set) open var configuredInStoryboard: Bool = false
  fileprivate(set) open var relatedStoryboard: UIStoryboard?

  // MARK: Life Cycle
  public init(slideMenuModels: [DPSlideMenuModel]?, storyboard: UIStoryboard?) {
    super.init(style:.grouped)
    self.slideMenuModels = slideMenuModels
    self.relatedStoryboard = storyboard
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UITableViewCell.self,
                                 forCellReuseIdentifier: kDPColorsViewControllerCellReuseID)
    self.tableView.separatorStyle = .none
    self.tableView.backgroundColor = UIColor.init(red: 86 / 255.0,
                                                  green: 202 / 255.0,
                                                  blue: 139 / 255.0,
                                                  alpha: 1.0)
    self.drawerControllerWillOpen = {
      [weak self] in
      if let this = self {
        this.view.isUserInteractionEnabled = false
      }
    }
    
    self.drawerControllerDidOpen = {
      [weak self] in
      if let this = self {
        this.view.isUserInteractionEnabled = true
      }
    }
    
    self.drawerControllerWillClose = {
      [weak self] in
      if let this = self {
        this.view.isUserInteractionEnabled = false
      }
    }
    
    self.drawerControllerDidClose = {
      [weak self] in
      if let this = self {
        this.view.isUserInteractionEnabled = true
      }
    }
    
  }
  
  override open var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }

  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Data Source
  open override func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int {
    if let slideMenuModels = self.slideMenuModels {
      return slideMenuModels.count
    }
    return 0
  }
  
  override open func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: kDPColorsViewControllerCellReuseID,
                                                                             for: indexPath)
    let slideMenuModel: DPSlideMenuModel? = slideMenuModels?[(indexPath as NSIndexPath).row]
    cell?.textLabel?.text = slideMenuModel?.title?.localized
    cell?.textLabel?.textColor = UIColor.white
    cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell?.backgroundColor = self.slideMenuModels?[(indexPath as NSIndexPath).row].color
    return cell!
  }
  
  // MARK: Delegate
  override open func tableView(_ tableView: UITableView,
                                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if (indexPath as NSIndexPath).row == self.lastRow {
      self.drawer?.close()
    } else {
      let slideMenuModel: DPSlideMenuModel? = slideMenuModels?[(indexPath as NSIndexPath).row]

      // Reload the current center view controller and update its background color
//      self.drawer?.reloadCenterViewControllerUsingBlock {
//        [weak self] in
//        if let this = self {
//          this.drawer!.centerViewController!.view.backgroundColor = slideMenuModel?.color
//        }
//      }
      
      // Replace the current center view controller with a new one
      if let controllerClassName = slideMenuModel?.controllerClassName {
        var viewController: DPContentViewController?
        if self.relatedStoryboard != nil {
          let array: [String]? = controllerClassName.components(separatedBy: ".")
          let SBIdentifier: String? = array?.last
          if SBIdentifier != nil {
            viewController = self.relatedStoryboard?.instantiateViewController(withIdentifier: SBIdentifier!) as? DPContentViewController
          }
        } else {
          let aClass = NSClassFromString(controllerClassName) as! DPContentViewController.Type
          viewController = aClass.init()
        }
        if viewController != nil {
          self.drawer?.replaceCenterViewControllerWithViewController(viewController!)
        }
      } else {
        slideMenuModel?.actionBlock?()
      }
    }
    self.lastRow = (indexPath as NSIndexPath).row
  }
  
  override open func tableView(_ tableView: UITableView,
                                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let slideMenuModel: DPSlideMenuModel? = slideMenuModels?[(indexPath as NSIndexPath).row]
    if slideMenuModel?.cellHeight != nil {
      return (slideMenuModel?.cellHeight!)!
    }
    return kDefaultCellHeight
  }
  
  override open func tableView(_ tableView: UITableView,
                                 heightForHeaderInSection section: Int) -> CGFloat {
    return kDefaultHeaderHeight
  }
  
}
