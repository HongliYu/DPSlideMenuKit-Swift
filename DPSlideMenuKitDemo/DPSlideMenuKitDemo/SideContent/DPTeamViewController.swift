//
//  DPTeamViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 04/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPTeamViewController: DPBaseEmbedViewController {
  
  @IBOutlet weak var avatarImageView: UIImageView! {
    didSet {
      avatarImageView.layoutIfNeeded()
      avatarImageView.layer.cornerRadius = 10
      avatarImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var accountButton: UIButton! {
    didSet {
      accountButton.layer.borderWidth = 1
      accountButton.layer.borderColor = UIColor.white.cgColor
      accountButton.layer.cornerRadius = 4
      accountButton.layer.masksToBounds = true
    }
  }
  
  @IBOutlet weak var settingsButton: UIButton! {
    didSet {
      settingsButton.layer.borderWidth = 1
      settingsButton.layer.borderColor = UIColor.white.cgColor
      settingsButton.layer.cornerRadius = 4
      settingsButton.layer.masksToBounds = true
    }
  }
  
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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}
