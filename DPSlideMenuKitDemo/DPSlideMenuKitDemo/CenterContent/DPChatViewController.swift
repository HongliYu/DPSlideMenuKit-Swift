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
  
  override init(nibName nibNameOrNil: String?,
                bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }
  
  required internal init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if UIScreen.current == .iPhone5_8 {
      titleContentViewTopConstraints.constant = 44
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func bindData(title: String, message: String) {
    self.titleLabel.text = title
    self.messageLabel.text = message
  }
  
}
