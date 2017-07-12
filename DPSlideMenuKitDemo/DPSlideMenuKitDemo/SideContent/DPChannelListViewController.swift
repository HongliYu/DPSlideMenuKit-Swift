//
//  DPChannelListViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 04/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit
import Foundation

// MARK: Constant
let kDPChannelListCellReuseID: String = "kDPChannelListCellReuseID"
let kDefaultCellHeight: CGFloat = 44.0
let kDefaultSectionHeight: CGFloat = 44.0

class DPChannelListViewController: DPBaseEmbedViewController {
  
  @IBOutlet weak var mainTableView: UITableView!
  
  fileprivate(set) var channelViewModels: [DPChannelViewModel] = []
  fileprivate var addChannelAction:(()->Void)?
  
  @IBOutlet weak var teamIconImageView: UIImageView! {
    didSet {
      teamIconImageView.layoutIfNeeded()
      teamIconImageView.layer.cornerRadius = 5
      teamIconImageView.layer.masksToBounds = true
    }
  }
  
  // MARK: Life Cycle
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.basicUI()
    self.basicData()
  }
  
  func basicUI() {
    self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDPChannelListCellReuseID)
    self.mainTableView.separatorStyle = .none
    self.mainTableView.backgroundColor = UIColor.clear
    self.mainTableView.delegate = self
    self.mainTableView.dataSource = self
  }
  
  func basicData() {
    let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
    
    // TODO: section number enumeration, better
    // section 0
    let channelCellViewModel = DPChannelCellViewModel(color: UIColor.clear,
                                                      title: "# All Threads",
                                                      cellHeight: kDefaultCellHeight) {
                                                        self.alert("All Thread Action! Function: \(#function), line: \(#line)")
    }
    let channelSectionViewModel = DPChannelSectionViewModel(title: "", height: kDefaultSectionHeight) {
      self.alert("Section Action! Function: \(#function), line: \(#line)")
    }
    let channelViewModel0: DPChannelViewModel = DPChannelViewModel(channelCellViewModels: [channelCellViewModel],
                                                                   channelSectionViewModel: channelSectionViewModel)
    self.channelViewModels.append(channelViewModel0)

    
    // section 1
    let channelCellViewModel0 = DPChannelCellViewModel(color: Palette.main,
                                                       title: "# awesome channel 0",
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
                                                          viewController.bindData(title: "@channel 0", message: "this is awesome channel 0")
                                                        }
    }
    let channelSectionViewModel0 = DPChannelSectionViewModel(title: "CHANNELS", height: kDefaultSectionHeight) {
      self.alert("CHANNELS Section Action! Function: \(#function), line: \(#line)")
    }
    
    let channelCellViewModel1 = DPChannelCellViewModel(color: Palette.blue,
                                                       title: "# awesome channel 1",
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
                                                          viewController.bindData(title: "@channel 1", message: "this is awesome channel 1")
                                                        }
    }

    let channelCellViewModel2 = DPChannelCellViewModel(color: UIColor.random(),
                                                       title: "# Rate",
                                                       cellHeight: kDefaultCellHeight) {
      let urlString: String = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=910117892" // replace 910117892 with your appid
      UIApplication.shared.openURL(URL(string: urlString)!)
    }

    let channelCellViewModel3 = DPChannelCellViewModel(color: UIColor.random(),
                                                       title: "# Donate",
                                                       cellHeight: kDefaultCellHeight) {
      let targetURL: String = "https://qr.alipay.com/apeez0tpttrt2yove2"
      UIApplication.shared.openURL(URL(string: targetURL)!) // Donate with alipay
    }
    
    let channelViewModel1: DPChannelViewModel = DPChannelViewModel(channelCellViewModels: [channelCellViewModel0,
                                                                                           channelCellViewModel1,
                                                                                           channelCellViewModel2,
                                                                                           channelCellViewModel3],
                                                                   channelSectionViewModel: channelSectionViewModel0)
    self.channelViewModels.append(channelViewModel1)
  }
  
  func updateUI() {
    self.mainTableView.reloadData()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension DPChannelListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.channelViewModels.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    for (index, channelViewModel) in self.channelViewModels.enumerated() {
      if section == index {
        if let count = channelViewModel.channelCellViewModels?.count {
          return count
        } else {
          return 0
        }
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: kDPChannelListCellReuseID, for: indexPath)
    let channelViewModel: DPChannelViewModel? = self.channelViewModels[indexPath.section]
    let channelCellViewModel: DPChannelCellViewModel? = channelViewModel?.channelCellViewModels?[indexPath.row]
    
    cell?.textLabel?.text = channelCellViewModel?.title?.localized
    cell?.textLabel?.textColor = UIColor.white
    cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell?.backgroundColor = channelCellViewModel?.color
    
    if cell == nil {
      return UITableViewCell()
    }
    return cell!
  }

}

extension DPChannelListViewController: UITableViewDelegate {
  
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
      return nil
    }
    if section == 1 {
      let channelViewModel: DPChannelViewModel? = self.channelViewModels[section]
      self.addChannelAction = channelViewModel?.channelSectionViewModel?.actionBlock
      
      let view = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:20))
      view.backgroundColor = UIColor.clear
      
      let label = UILabel(frame: CGRect(x:16, y:0, width:200, height:kDefaultSectionHeight))
      label.font = UIFont.systemFont(ofSize: 16)
      label.text = channelViewModel?.channelSectionViewModel?.title
      label.textColor = UIColor.white
      label.backgroundColor = UIColor.clear
      view.addSubview(label)
      
      let addChannelButton: UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width + kDPDrawerControllerLeftViewInitialOffset - kDefaultSectionHeight,
                                                              y: 0, width: kDefaultSectionHeight, height: kDefaultSectionHeight))
      addChannelButton.backgroundColor = UIColor.clear
      addChannelButton.setTitle("Add", for: .normal)
      addChannelButton.setTitleColor(UIColor.white, for: .normal)
      addChannelButton.addTarget(self, action: #selector(self.addChannelAction(_:)), for: .touchUpInside)
      view.addSubview(addChannelButton)
      
      return view
    }
    
    return nil
  }

  func addChannelAction(_ sender: UIButton) {
    self.addChannelAction?()
  }

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let channelViewModel: DPChannelViewModel? = self.channelViewModels[indexPath.section]
    let channelCellViewModel: DPChannelCellViewModel? = channelViewModel?.channelCellViewModels?[indexPath.row]
    
    if channelCellViewModel?.cellHeight != nil {
      return channelCellViewModel!.cellHeight!
    }
    return kDefaultCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let channelViewModel: DPChannelViewModel? = self.channelViewModels[indexPath.section]
    let channelCellViewModel: DPChannelCellViewModel? = channelViewModel?.channelCellViewModels?[indexPath.row]
    channelCellViewModel?.actionBlock?()
  }

}
