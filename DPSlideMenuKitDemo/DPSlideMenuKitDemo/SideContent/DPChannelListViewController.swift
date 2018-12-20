//
//  DPChannelListViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 04/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

let kDPChannelListCellReuseID: String = "kDPChannelListCellReuseID"
let kDefaultCellHeight: CGFloat = 44.0
let kDefaultSectionHeight: CGFloat = 44.0

class DPChannelListViewController: DPBaseEmbedViewController {
  
  @IBOutlet weak var mainTableView: UITableView!
  
  private(set) var channelViewModels: [DPChannelViewModel] = []
  private var addChannelAction:(()->Void)?
  
  @IBOutlet weak var teamIconImageView: UIImageView! {
    didSet {
      teamIconImageView.layoutIfNeeded()
      teamIconImageView.layer.cornerRadius = 5
      teamIconImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var titleContentViewTopConstraints: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    basicUI()
    basicData()
  }
  
  func basicUI() {
    mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDPChannelListCellReuseID)
    mainTableView.separatorStyle = .none
    mainTableView.backgroundColor = UIColor.clear
    mainTableView.delegate = self
    mainTableView.dataSource = self
    if UIScreen().iPhoneBangsScreen {
      titleContentViewTopConstraints.constant = 20
    }
  }
  
  func basicData() {
    let channelCellViewModel = DPChannelCellViewModel(color: UIColor.clear,
                                                      title: "# All Threads",
                                                      cellHeight: kDefaultCellHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.alert("All Thread Action! Function: \(#function), line: \(#line)")
    }
    let channelSectionViewModel = DPChannelSectionViewModel(title: "",
                                                            height: kDefaultSectionHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.alert("Section Action! Function: \(#function), line: \(#line)")
    }
    let channelViewModel0: DPChannelViewModel =
      DPChannelViewModel(channelCellViewModels: [channelCellViewModel],
                         channelSectionViewModel: channelSectionViewModel)
    channelViewModels.append(channelViewModel0)
    
    let channelCellViewModel0 = DPChannelCellViewModel(color: Palette.main,
                                                       title: "# awesome channel 0",
                                                       cellHeight: kDefaultCellHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      if let viewController =
        UIViewController.viewController(DPChatViewController.self,
                                        storyboard: "Pages") as? DPChatViewController {
        DPSlideMenuManager.shared.replaceCenter(viewController, position: strongSelf.positionState)
        viewController.bindData(title: "channel 0", message: "this is awesome channel 0")
      }
    }
    let channelSectionViewModel0 = DPChannelSectionViewModel(title: "CHANNELS",
                                                             height: kDefaultSectionHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.alert("CHANNELS Section Action! Function: \(#function), line: \(#line)")
    }
    
    let channelCellViewModel1 = DPChannelCellViewModel(color: Palette.blue,
                                                       title: "# awesome channel 1",
                                                       cellHeight: kDefaultCellHeight) {
      [weak self] in
      guard let strongSelf = self else { return }
      if let viewController =
        UIViewController.viewController(DPChatViewController.self,
                                        storyboard: "Pages") as? DPChatViewController {
        DPSlideMenuManager.shared.replaceCenter(viewController, position: strongSelf.positionState)
        viewController.bindData(title: "channel 1", message: "this is awesome channel 1")
      }
    }

    let channelCellViewModel2 = DPChannelCellViewModel(color: UIColor.random(),
                                                       title: "# Rate",
                                                       cellHeight: kDefaultCellHeight) {
      let urlString: String = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=910117892" // replace 910117892 with your appid
      UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }

    let channelCellViewModel3 = DPChannelCellViewModel(color: UIColor.random(),
                                                       title: "# Donate",
                                                       cellHeight: kDefaultCellHeight) {
      let targetURL: String = "https://qr.alipay.com/apeez0tpttrt2yove2"
      UIApplication.shared.open(URL(string: targetURL)!, options: [:], completionHandler: nil) // Donate with alipay
    }
    
    let channelViewModel1: DPChannelViewModel = DPChannelViewModel(
      channelCellViewModels: [channelCellViewModel0, channelCellViewModel1,
                              channelCellViewModel2, channelCellViewModel3],
      channelSectionViewModel: channelSectionViewModel0)
    channelViewModels.append(channelViewModel1)
  }
  
  func updateUI() {
    mainTableView.reloadData()
  }
    
}

extension DPChannelListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return channelViewModels.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    for (index, channelViewModel) in channelViewModels.enumerated() {
      if section == index {
        return channelViewModel.channelCellViewModels?.count ?? 0
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kDPChannelListCellReuseID, for: indexPath)
    let channelViewModel: DPChannelViewModel? = channelViewModels[indexPath.section]
    let channelCellViewModel: DPChannelCellViewModel? = channelViewModel?.channelCellViewModels?[indexPath.row]
    
    cell.textLabel?.text = channelCellViewModel?.title?.localized
    cell.textLabel?.textColor = UIColor.white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell.backgroundColor = channelCellViewModel?.color
    return cell
  }

}

extension DPChannelListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 1 ? kDefaultSectionHeight : 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 1 else { return nil}
    let channelViewModel: DPChannelViewModel? = channelViewModels[section]
    addChannelAction = channelViewModel?.channelSectionViewModel?.actionBlock
    
    let view = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:20))
    view.backgroundColor = UIColor.clear
    
    let label = UILabel(frame: CGRect(x:16, y:0, width:200, height:kDefaultSectionHeight))
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = channelViewModel?.channelSectionViewModel?.title
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.clear
    view.addSubview(label)
    
    let addChannelButton: UIButton = UIButton(frame:
      CGRect(x: UIScreen.main.bounds.width + kDPDrawerControllerLeftViewInitialOffset - kDefaultSectionHeight,
             y: 0, width: kDefaultSectionHeight, height: kDefaultSectionHeight))
    addChannelButton.backgroundColor = UIColor.clear
    addChannelButton.titleLabel!.font = UIFont(name: "fontawesome", size: 24)!
    addChannelButton.setTitle("\u{f055}", for: .normal)
    addChannelButton.setTitleColor(UIColor.white, for: .normal)
    addChannelButton.addTarget(self, action: #selector(self.addChannelAction(_:)), for: .touchUpInside)
    view.addSubview(addChannelButton)
    return view
  }

  @objc func addChannelAction(_ sender: UIButton) {
    addChannelAction?()
  }

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let channelViewModel: DPChannelViewModel? = channelViewModels[indexPath.section]
    let channelCellViewModel: DPChannelCellViewModel? = channelViewModel?.channelCellViewModels?[indexPath.row]
    return channelCellViewModel?.cellHeight ?? kDefaultCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let channelViewModel: DPChannelViewModel? = channelViewModels[indexPath.section]
    let channelCellViewModel: DPChannelCellViewModel? = channelViewModel?.channelCellViewModels?[indexPath.row]
    channelCellViewModel?.actionBlock?()
  }

}
