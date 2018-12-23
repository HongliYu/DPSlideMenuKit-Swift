//
//  DPSettingsSectionView.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPSettingsSectionView: UIView {

  @IBOutlet weak var avatarImageView: UIImageView! {
    didSet {
      avatarImageView.layoutIfNeeded()
      avatarImageView.layer.cornerRadius = 10
      avatarImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var boldTitleLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  
  func bindData(imageURL: String, title: String, subTitle: String) {
    //...
  }
  
}
