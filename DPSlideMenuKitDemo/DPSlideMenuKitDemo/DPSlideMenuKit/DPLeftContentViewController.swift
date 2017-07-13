//
//  DPLeftContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 05/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

public class DPLeftContentViewController: UIViewController {

  var embedViewController: UIViewController?
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
  }

  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func config(embedViewController: UIViewController) {
    self.embedViewController = embedViewController
    self.addChildViewController(embedViewController)
    embedViewController.view.frame = self.view.bounds
    self.view.addSubview(embedViewController.view)
  }
  
}
