//
//  DPChannelViewModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/18/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class DPChannelSectionViewModel {
  
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

class DPChannelCellViewModel {
  
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

class DPChannelViewModel {
  
  var channelCellViewModels: [DPChannelCellViewModel]?
  var channelSectionViewModel: DPChannelSectionViewModel?
  
  init(channelCellViewModels: [DPChannelCellViewModel]?,
       channelSectionViewModel: DPChannelSectionViewModel?) {
    self.channelCellViewModels = channelCellViewModels
    self.channelSectionViewModel = channelSectionViewModel
  }
  
}
