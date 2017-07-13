//
//  DPSettingsViewModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPSettingsSectionViewModel {
  
  fileprivate(set) var title: String?
  fileprivate(set) var height: CGFloat?
  fileprivate(set) var actionBlock:(()->Void)?
  
  init(title: String?,
       height: CGFloat?,
       actionBlock: (()->Void)?) {
    self.title = title
    self.height = height
    self.actionBlock = actionBlock
  }
  
}

class DPSettingsCellViewModel {
  
  fileprivate(set) var color: UIColor?
  fileprivate(set) var title: String?
  fileprivate(set) var cellHeight: CGFloat?
  fileprivate(set) var actionBlock:(()->Void)?
  
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
  
  // TODO: Need computed properties to mapping properties in sub view model
  init(settingsCellViewModels: [DPSettingsCellViewModel]?,
       settingsSectionViewModel: DPSettingsSectionViewModel?) {
    self.settingsCellViewModels = settingsCellViewModels
    self.settingsSectionViewModel = settingsSectionViewModel
  }

}
