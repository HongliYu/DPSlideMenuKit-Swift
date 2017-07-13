//
//  DPRightContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 10/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPRightContentViewController: UIViewController {

  var embedViewController: UIViewController?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func config(embedViewController: UIViewController) {
    self.embedViewController = embedViewController
    self.addChildViewController(embedViewController)
    embedViewController.view.frame = self.view.bounds
    self.view.addSubview(embedViewController.view)
  }

}
