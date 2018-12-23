//
//  DPChatViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 10/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPChatViewController: DPCenterContentViewController {
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var titleContentViewTopConstraints: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if UIScreen().iPhoneBangsScreen {
      titleContentViewTopConstraints.constant = 44
    }
  }
  
  func bindData(title: String, message: String) {
    titleLabel.text = title
    messageLabel.text = message
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

}
