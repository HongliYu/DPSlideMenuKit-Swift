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
  
  private(set) var messageViewModels: [DPMessageViewModel] = []
  @IBOutlet weak var titleContentViewTopConstraints: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    basicUI()
    basicData()
  }
  
  func basicUI() {
    mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDPMessageListCellReuseID)
    mainTableView.separatorStyle = .none
    mainTableView.backgroundColor = UIColor.clear
    mainTableView.delegate = self
    mainTableView.dataSource = self
    if UIScreen().iPhoneBangsScreen {
      titleContentViewTopConstraints.constant = 20
    }
  }
  
  func basicData() {
    let messageCellViewModel0 = DPMessageCellViewModel(color: UIColor.random(),
                                                       title: "@Alina",
                                                       cellHeight: kDefaultCellHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      if let viewController =
        UIViewController.viewController(DPChatViewController.self,
                                        storyboard: "Pages") as? DPChatViewController {
        DPSlideMenuManager.shared.replaceCenter(viewController, position: strongSelf.positionState)
        viewController.bindData(title: "@Alina", message: "Hi Alina, Wie geht es dir~")
      }
    }
    let messageCellViewModel1 = DPMessageCellViewModel(color: UIColor.random(),
                                                       title: "@Dana",
                                                       cellHeight: kDefaultCellHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      if let viewController =
        UIViewController.viewController(DPChatViewController.self,
                                        storyboard: "Pages") as? DPChatViewController {
        DPSlideMenuManager.shared.replaceCenter(viewController, position: strongSelf.positionState)
        viewController.bindData(title: "@Dana", message: "Hi Dana, Wie geht es dir~")
      }
    }
    let messageCellViewModel2 = DPMessageCellViewModel(color: UIColor.random(),
                                                       title: "@Ivana",
                                                       cellHeight: kDefaultCellHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      if let viewController =
        UIViewController.viewController(DPChatViewController.self,
                                        storyboard: "Pages") as? DPChatViewController {
        DPSlideMenuManager.shared.replaceCenter(viewController, position: strongSelf.positionState)
        viewController.bindData(title: "@Ivana", message: "Hi Ivana, Wie geht es dir~")
      }
    }
    let messageSectionViewModel = DPMessageSectionViewModel(title: "RECENT",
                                                            height: kDefaultSectionHeight,
                                                            actionBlock: nil)
    let messageViewModel0: DPMessageViewModel = DPMessageViewModel(
      messageCellViewModels: [messageCellViewModel0, messageCellViewModel1,
                              messageCellViewModel2],
      messageSectionViewModel: messageSectionViewModel)
    messageViewModels.append(messageViewModel0)
  }
  
}

extension DPMessageListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return messageViewModels.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    for (index, messageViewModel) in messageViewModels.enumerated() {
      if section == index {
        return messageViewModel.messageCellViewModels?.count ?? 0
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kDPMessageListCellReuseID, for: indexPath)
    let messageViewModel: DPMessageViewModel? = messageViewModels[indexPath.section]
    let messageCellViewModel: DPMessageCellViewModel? = messageViewModel?.messageCellViewModels?[indexPath.row]
    cell.textLabel?.text = messageCellViewModel?.title?.localized
    cell.textLabel?.textColor = UIColor.white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell.backgroundColor = messageCellViewModel?.color
    return cell
  }
  
}

extension DPMessageListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 1 ? kDefaultSectionHeight : 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 0 else { return nil }
    let messageViewModel: DPMessageViewModel? = messageViewModels[section]
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
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let messageViewModel: DPMessageViewModel? = messageViewModels[indexPath.section]
    let messageCellViewModel: DPMessageCellViewModel? = messageViewModel?.messageCellViewModels?[indexPath.row]
    return messageCellViewModel?.cellHeight ?? kDefaultCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let messageViewModel: DPMessageViewModel? = messageViewModels[indexPath.section]
    let messageCellViewModel: DPMessageCellViewModel? = messageViewModel?.messageCellViewModels?[indexPath.row]
    messageCellViewModel?.actionBlock?()
  }
  
}
