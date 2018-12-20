//
//  DPSettingsViewModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPSettingsSectionViewModel {
  
  private(set) var title: String?
  private(set) var height: CGFloat?
  private(set) var actionBlock:(()->Void)?
  
  init(title: String?,
       height: CGFloat?,
       actionBlock: (()->Void)?) {
    self.title = title
    self.height = height
    self.actionBlock = actionBlock
  }
  
}

class DPSettingsCellViewModel {
  
  private(set) var color: UIColor?
  private(set) var title: String?
  private(set) var cellHeight: CGFloat?
  private(set) var actionBlock:(()->Void)?
  
  init(color: UIColor?,
       title: String?,
       cellHeight: CGFloat?,
       actionBlock: (()->Void)?) {
    self.color = color
    self.title = title
    self.cellHeight = cellHeight
    self.actionBlock = actionBlock
  }
  
}

class DPSettingsViewModel {
  
  var settingsCellViewModels: [DPSettingsCellViewModel]?
  var settingsSectionViewModel: DPSettingsSectionViewModel?
  
  init(settingsCellViewModels: [DPSettingsCellViewModel]?,
       settingsSectionViewModel: DPSettingsSectionViewModel?) {
    self.settingsCellViewModels = settingsCellViewModels
    self.settingsSectionViewModel = settingsSectionViewModel
  }

}
