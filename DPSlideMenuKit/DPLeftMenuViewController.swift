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
                             bundle: NSBundle.mainBundle(),
                             value: "",
                             comment: "")
  }
}

// MARK: Constant
let kDPColorsViewControllerCellReuseID: String = "kDPColorsViewControllerCellReuseID"
let kDefaultCellHeight: CGFloat = 88.0
let kDefaultHeaderHeight: CGFloat = 44.0

public class DPLeftMenuViewController: UITableViewController {
  
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
  private var drawerControllerWillOpenStored:(()->Void)?
  
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
  private var drawerControllerDidOpenStored:(()->Void)?
  
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
  private var drawerControllerWillCloseStored:(()->Void)?
  
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
  private var drawerControllerDidCloseStored:(()->Void)?
  
  weak var drawer: DPDrawerViewController?
  private(set) public var slideMenuModels: [DPSlideMenuModel]?
  private(set) public var lastRow: Int = 0
  
  // MARK: Life Cycle
  public init(slideMenuModels: [DPSlideMenuModel]?) {
    super.init(style:.Grouped)
    self.slideMenuModels = slideMenuModels
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.registerClass(UITableViewCell.self,
                                 forCellReuseIdentifier: kDPColorsViewControllerCellReuseID)
    self.tableView.separatorStyle = .None
    self.tableView.backgroundColor = UIColor.init(red: 86 / 255.0,
                                                  green: 202 / 255.0,
                                                  blue: 139 / 255.0,
                                                  alpha: 1.0)
    self.drawerControllerWillOpen = {
      [weak self] in
      if let this = self {
        this.view.userInteractionEnabled = false
      }
    }
    
    self.drawerControllerDidOpen = {
      [weak self] in
      if let this = self {
        this.view.userInteractionEnabled = true
      }
    }
    
    self.drawerControllerWillClose = {
      [weak self] in
      if let this = self {
        this.view.userInteractionEnabled = false
      }
    }
    
    self.drawerControllerDidClose = {
      [weak self] in
      if let this = self {
        this.view.userInteractionEnabled = true
      }
    }
    
  }
  
  override public func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Data Source
  public override func tableView(tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int {
    if let slideMenuModels = self.slideMenuModels {
      return slideMenuModels.count
    }
    return 0
  }
  
  override public func tableView(tableView: UITableView,
                                 cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kDPColorsViewControllerCellReuseID,
                                                                             forIndexPath: indexPath)
    let slideMenuModel: DPSlideMenuModel? = slideMenuModels?[indexPath.row]
    cell?.textLabel?.text = slideMenuModel?.title?.localized
    cell?.textLabel?.textColor = UIColor.whiteColor()
    cell?.textLabel?.font = UIFont.boldSystemFontOfSize(20.0)
    cell?.backgroundColor = self.slideMenuModels?[indexPath.row].color
    return cell!
  }
  
  // MARK: Delegate
  override public func tableView(tableView: UITableView,
                                 didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == self.lastRow {
      self.drawer?.close()
    } else {
      let slideMenuModel: DPSlideMenuModel? = slideMenuModels?[indexPath.row]

      // Reload the current center view controller and update its background color
//      self.drawer?.reloadCenterViewControllerUsingBlock {
//        [weak self] in
//        if let this = self {
//          this.drawer!.centerViewController!.view.backgroundColor = slideMenuModel?.color
//        }
//      }
      
      // Replace the current center view controller with a new one
      if let controllerClassName = slideMenuModel?.controllerClassName {
        let aClass = NSClassFromString(controllerClassName) as! DPContentViewController.Type
        let viewController = aClass.init()
        self.drawer?.replaceCenterViewControllerWithViewController(viewController)
      } else {
        slideMenuModel?.actionBlock?()
      }
    }
    self.lastRow = indexPath.row
  }
  
  override public func tableView(tableView: UITableView,
                                 heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let slideMenuModel: DPSlideMenuModel? = slideMenuModels?[indexPath.row]
    if slideMenuModel?.cellHeight != nil {
      return (slideMenuModel?.cellHeight!)!
    }
    return kDefaultCellHeight
  }
  
  override public func tableView(tableView: UITableView,
                                 heightForHeaderInSection section: Int) -> CGFloat {
    return kDefaultHeaderHeight
  }
  
}