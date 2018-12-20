//
//  DPMessageViewModel.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 10/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

class DPMessageSectionViewModel {
  
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

class DPMessageCellViewModel {
  
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

class DPMessageViewModel {
  
  var messageCellViewModels: [DPMessageCellViewModel]?
  var messageSectionViewModel: DPMessageSectionViewModel?
  
  init(messageCellViewModels: [DPMessageCellViewModel]?,
       messageSectionViewModel: DPMessageSectionViewModel?) {
    self.messageCellViewModels = messageCellViewModels
    self.messageSectionViewModel = messageSectionViewModel
  }

}
