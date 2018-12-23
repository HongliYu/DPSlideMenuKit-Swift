//
//  DPBaseContentViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 2018/12/19.
//  Copyright © 2018 Hongli Yu. All rights reserved.
//

import UIKit

public class DPBaseContentViewController: UIViewController {
  
  open var embedViewController: UIViewController?
  
  open func config(_ embedViewController: UIViewController) {
    self.embedViewController = embedViewController
    self.addChild(embedViewController)
    embedViewController.view.frame = self.view.bounds
    self.view.addSubview(embedViewController.view)
  }
  
}
