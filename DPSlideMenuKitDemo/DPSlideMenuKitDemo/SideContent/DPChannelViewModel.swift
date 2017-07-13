//
//  DPChannelViewModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/18/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class DPChannelSectionViewModel {
  
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

class DPChannelCellViewModel {
  
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

class DPChannelViewModel {
  
  var channelCellViewModels: [DPChannelCellViewModel]?
  var channelSectionViewModel: DPChannelSectionViewModel?
  
  // TODO: Need computed properties to mapping properties in sub view model
  init(channelCellViewModels: [DPChannelCellViewModel]?,
       channelSectionViewModel: DPChannelSectionViewModel?) {
    self.channelCellViewModels = channelCellViewModels
    self.channelSectionViewModel = channelSectionViewModel
  }
  
}
