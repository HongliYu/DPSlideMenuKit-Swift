//
//  DPMessageListViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 04/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

let kDPMessageListCellReuseID: String = "kDPMessageListCellReuseID"

class DPMessageListViewController: DPBaseEmbedViewController {

  @IBOutlet weak var mainTableView: UITableView!
  
  @IBOutlet weak var editButton: UIButton! {
    didSet {
      editButton.titleLabel!.font = UIFont(name: "fontawesome", size: 24)!
      editButton.setTitle("\u{f044}", for: .normal)
      editButton.setTitleColor(UIColor.white, for: .normal)
    }
  }
  
  fileprivate(set) var messageViewModels: [DPMessageViewModel] = []
  @IBOutlet weak var titleContentViewTopConstraints: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
    self.basicData()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Life Cycle
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  func basicUI() {
    self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDPMessageListCellReuseID)
    self.mainTableView.separatorStyle = .none
    self.mainTableView.backgroundColor = UIColor.clear
    self.mainTableView.delegate = self
    self.mainTableView.dataSource = self
    if UIScreen.current == .iPhone5_8 {
      titleContentViewTopConstraints.constant = 20
    }
  }
  
  func basicData() {
    let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
    
    // TODO: section number enumeration, better
    // section 0
    let messageCellViewModel0 = DPMessageCellViewModel(color: UIColor.random(),
                                                       title: "@hongli",
                                                       cellHeight: kDefaultCellHeight) {
                                                        var viewController: DPCenterContentViewController?
                                                        if storyboard != nil {
                                                          viewController = self.storyboard?.instantiateViewController(withIdentifier: "DPChatViewController") as? DPCenterContentViewController
                                                        } else {
                                                          let aClass = NSClassFromString("DPChatViewController") as! DPCenterContentViewController.Type
                                                          viewController = aClass.init()
                                                        }
                                                        if let viewController = viewController as? DPChatViewController {
                                                          DPSlideMenuManager.shared.replaceCenterViewControllerWith(viewController: viewController,
                                                                                                                    position: self.positionState)
                                                          viewController.bindData(title: "@hongli", message: "hi hongli~")
                                                        }
    }
    let messageCellViewModel1 = DPMessageCellViewModel(color: UIColor.random(),
                                                       title: "@ilar",
                                                       cellHeight: kDefaultCellHeight) {
                                                        var viewController: DPCenterContentViewController?
                                                        if storyboard != nil {
                                                          viewController = self.storyboard?.instantiateViewController(withIdentifier: "DPChatViewController") as? DPCenterContentViewController
                                                        } else {
                                                          let aClass = NSClassFromString("DPChatViewController") as! DPCenterContentViewController.Type
                                                          viewController = aClass.init()
                                                        }
                                                        if let viewController = viewController as? DPChatViewController {
                                                          DPSlideMenuManager.shared.replaceCenterViewControllerWith(viewController: viewController,
                                                                                                                    position: self.positionState)
                                                          viewController.bindData(title: "@ilar", message: "hi ilar~")
                                                        }
    }
    let messageCellViewModel2 = DPMessageCellViewModel(color: UIColor.random(),
                                                       title: "@TJ",
                                                       cellHeight: kDefaultCellHeight) {
                                                        var viewController: DPCenterContentViewController?
                                                        if storyboard != nil {
                                                          viewController = self.storyboard?.instantiateViewController(withIdentifier: "DPChatViewController") as? DPCenterContentViewController
                                                        } else {
                                                          let aClass = NSClassFromString("DPChatViewController") as! DPCenterContentViewController.Type
                                                          viewController = aClass.init()
                                                        }
                                                        if let viewController = viewController as? DPChatViewController {
                                                          DPSlideMenuManager.shared.replaceCenterViewControllerWith(viewController: viewController,
                                                                                                                    position: self.positionState)
                                                          viewController.bindData(title: "@TJ", message: "hi TJ~")
                                                        }
    }
    let messageSectionViewModel = DPMessageSectionViewModel(title: "RECENT", height: kDefaultSectionHeight, actionBlock: nil)
    let messageViewModel0: DPMessageViewModel = DPMessageViewModel(messageCellViewModels: [messageCellViewModel0, messageCellViewModel1, messageCellViewModel2],
                                                                   messageSectionViewModel: messageSectionViewModel)
    self.messageViewModels.append(messageViewModel0)
  }
  
}

extension DPMessageListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.messageViewModels.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    for (index, messageViewModel) in self.messageViewModels.enumerated() {
      if section == index {
        if let count = messageViewModel.messageCellViewModels?.count {
          return count
        } else {
          return 0
        }
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: kDPMessageListCellReuseID, for: indexPath)
    let messageViewModel: DPMessageViewModel? = self.messageViewModels[indexPath.section]
    let messageCellViewModel: DPMessageCellViewModel? = messageViewModel?.messageCellViewModels?[indexPath.row]
    
    cell?.textLabel?.text = messageCellViewModel?.title?.localized
    cell?.textLabel?.textColor = UIColor.white
    cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell?.backgroundColor = messageCellViewModel?.color
    
    if cell == nil {
      return UITableViewCell()
    }
    return cell!
  }
  
}

extension DPMessageListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    }
    if section == 1 {
      return kDefaultSectionHeight
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      let messageViewModel: DPMessageViewModel? = self.messageViewModels[section]
      let view = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:20))
      view.backgroundColor = UIColor.clear
      let label = UILabel(frame: CGRect(x:16, y:0, width:200, height:kDefaultSectionHeight))
      label.font = UIFont.systemFont(ofSize: 16)
      label.text = messageViewModel?.messageSectionViewModel?.title
      label.textColor = UIColor.white
      label.backgroundColor = UIColor.clear
      view.addSubview(label)
      return view
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let messageViewModel: DPMessageViewModel? = self.messageViewModels[indexPath.section]
    let messageCellViewModel: DPMessageCellViewModel? = messageViewModel?.messageCellViewModels?[indexPath.row]
    
    if messageCellViewModel?.cellHeight != nil {
      return messageCellViewModel!.cellHeight!
    }
    return kDefaultCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let messageViewModel: DPMessageViewModel? = self.messageViewModels[indexPath.section]
    let messageCellViewModel: DPMessageCellViewModel? = messageViewModel?.messageCellViewModels?[indexPath.row]
    messageCellViewModel?.actionBlock?()
  }
  
}
