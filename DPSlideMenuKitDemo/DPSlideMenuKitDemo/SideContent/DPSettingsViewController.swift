//
//  DPSettingsViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 11/07/2017.
//  Copyright © 2017 Hongli Yu. All rights reserved.
//

import UIKit

let kDPSettingsListCellReuseID: String = "kDPSettingsListCellReuseID"
let kDPSettingsDefaultSectionHeight: CGFloat = 20

class DPSettingsViewController: DPBaseEmbedViewController {

  @IBOutlet weak var mainTableView: UITableView!
  fileprivate(set) var settingsViewModels: [DPSettingsViewModel] = []

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
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func basicUI() {
    self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDPSettingsListCellReuseID)
    self.mainTableView.separatorStyle = .none
    self.mainTableView.backgroundColor = UIColor.clear
    self.mainTableView.delegate = self
    self.mainTableView.dataSource = self
  }
  
  func basicData() {
    
    // TODO: section number enumeration, better
    // section 0
    let settingsCellViewModel0 = DPSettingsCellViewModel(color: UIColor.random(),
                                                       title: "Set a Status",
                                                       cellHeight: kDefaultCellHeight) {
                                                        self.alert("Set a Status")
    }
    let settingsCellViewModel1 = DPSettingsCellViewModel(color: UIColor.random(),
                                                       title: "Snooze Notification",
                                                       cellHeight: kDefaultCellHeight) {
                                                        self.alert("Snooze Notification")
    }
    
    let settingsSectionViewModel = DPSettingsSectionViewModel(title: nil, height: kDefaultSectionHeight, actionBlock: nil)
    let settingsViewModel0: DPSettingsViewModel = DPSettingsViewModel(settingsCellViewModels: [settingsCellViewModel0, settingsCellViewModel1],
                                                                      settingsSectionViewModel: settingsSectionViewModel)
    self.settingsViewModels.append(settingsViewModel0)
    
    
    let settingsCellViewModel2 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Activity",
                                                         cellHeight: kDefaultCellHeight) {
                                                          self.alert("Activity")
    }
    let settingsCellViewModel3 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Started Items",
                                                         cellHeight: kDefaultCellHeight) {
                                                          self.alert("Started Items")
    }
    let settingsCellViewModel4 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Your Files",
                                                         cellHeight: kDefaultCellHeight) {
                                                          self.alert("Your Files")
    }
    let settingsCellViewModel5 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Directory",
                                                         cellHeight: kDefaultCellHeight) {
                                                          self.alert("Directory")
    }

    let settingsViewModel1: DPSettingsViewModel = DPSettingsViewModel(settingsCellViewModels:
      [settingsCellViewModel2, settingsCellViewModel3, settingsCellViewModel4, settingsCellViewModel5],
                                                                      settingsSectionViewModel: settingsSectionViewModel)
    self.settingsViewModels.append(settingsViewModel1)
    
    let settingsCellViewModel6 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Edit Profile",
                                                         cellHeight: kDefaultCellHeight) {
                                                          self.alert("Edit Profile")
    }
    let settingsCellViewModel7 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Settings",
                                                         cellHeight: kDefaultCellHeight) {
                                                          self.alert("Settings")
    }
    let settingsViewModel2: DPSettingsViewModel = DPSettingsViewModel(settingsCellViewModels: [settingsCellViewModel6, settingsCellViewModel7],
                                                                      settingsSectionViewModel: settingsSectionViewModel)
    self.settingsViewModels.append(settingsViewModel2)
  }
  
}

extension DPSettingsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.settingsViewModels.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    for (index, settingsViewModel) in self.settingsViewModels.enumerated() {
      if section == index {
        if let count = settingsViewModel.settingsCellViewModels?.count {
          return count
        } else {
          return 0
        }
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: kDPSettingsListCellReuseID, for: indexPath)
    let settingsViewModel: DPSettingsViewModel? = self.settingsViewModels[indexPath.section]
    let settingsCellViewModel: DPSettingsCellViewModel? = settingsViewModel?.settingsCellViewModels?[indexPath.row]
    
    cell?.textLabel?.text = settingsCellViewModel?.title?.localized
    cell?.textLabel?.textColor = UIColor.white
    cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell?.backgroundColor = settingsCellViewModel?.color
    
    if cell == nil {
      return UITableViewCell()
    }
    return cell!
  }

}

extension DPSettingsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 100
    }
    return kDPSettingsDefaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      let settingsSectionView = Bundle.main.loadNibNamed("DPSettingsSectionView",
                                                         owner: self, options: nil)?.last as! DPSettingsSectionView
      settingsSectionView.frame = CGRect(x:0, y:0,
                                         width:self.view.bounds.width,
                                         height:100)
      return settingsSectionView
    }
    let view = UIView(frame: CGRect(x:0, y:0,
                                    width:self.view.bounds.width,
                                    height:kDPSettingsDefaultSectionHeight))
    view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
    return view
  }
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    let settingsViewModel: DPSettingsViewModel? = self.settingsViewModels[indexPath.section]
    let settingsCellViewModel: DPSettingsCellViewModel? = settingsViewModel?.settingsCellViewModels?[indexPath.row]
    
    if settingsCellViewModel?.cellHeight != nil {
      return settingsCellViewModel!.cellHeight!
    }
    return kDefaultCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let settingsViewModel: DPSettingsViewModel? = self.settingsViewModels[indexPath.section]
    let settingsCellViewModel: DPSettingsCellViewModel? = settingsViewModel?.settingsCellViewModels?[indexPath.row]
    settingsCellViewModel?.actionBlock?()
  }

}
