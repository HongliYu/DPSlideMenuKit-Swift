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
  private(set) var settingsViewModels: [DPSettingsViewModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    basicUI()
    basicData()
  }

  func basicUI() {
    mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDPSettingsListCellReuseID)
    mainTableView.separatorStyle = .none
    mainTableView.backgroundColor = UIColor.clear
    mainTableView.delegate = self
    mainTableView.dataSource = self
  }
  
  func basicData() {
    let settingsCellViewModel0 =
      DPSettingsCellViewModel(color: UIColor.random(), title: "Set a Status", cellHeight: kDefaultCellHeight) {
        [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.alert("Set a Status")
    }
    let settingsCellViewModel1 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Snooze Notification",
                                                         cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Snooze Notification")
    }
    
    let settingsSectionViewModel = DPSettingsSectionViewModel(title: nil,
                                                              height: kDefaultSectionHeight,
                                                              actionBlock: nil)
    let settingsViewModel0: DPSettingsViewModel =
      DPSettingsViewModel(settingsCellViewModels: [settingsCellViewModel0, settingsCellViewModel1],
                          settingsSectionViewModel: settingsSectionViewModel)
    settingsViewModels.append(settingsViewModel0)
    
    let settingsCellViewModel2 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Activity", cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Activity")
    }
    let settingsCellViewModel3 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Started Items",
                                                         cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Started Items")
    }
    let settingsCellViewModel4 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Your Files",
                                                         cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Your Files")
    }
    let settingsCellViewModel5 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Directory",
                                                         cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Directory")
    }

    let settingsViewModel1: DPSettingsViewModel =
      DPSettingsViewModel(settingsCellViewModels: [settingsCellViewModel2,
                                                   settingsCellViewModel3,
                                                   settingsCellViewModel4,
                                                   settingsCellViewModel5],
                          settingsSectionViewModel: settingsSectionViewModel)
    settingsViewModels.append(settingsViewModel1)
    
    let settingsCellViewModel6 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Edit Profile",
                                                         cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Edit Profile")
    }
    let settingsCellViewModel7 = DPSettingsCellViewModel(color: UIColor.random(),
                                                         title: "Settings",
                                                         cellHeight: kDefaultCellHeight) {
                                                          [weak self] in
                                                          guard let strongSelf = self else { return }
                                                          strongSelf.alert("Settings")
    }
    let settingsViewModel2: DPSettingsViewModel =
      DPSettingsViewModel(settingsCellViewModels: [settingsCellViewModel6, settingsCellViewModel7],
                          settingsSectionViewModel: settingsSectionViewModel)
    settingsViewModels.append(settingsViewModel2)
  }
  
}

extension DPSettingsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return settingsViewModels.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    for (index, settingsViewModel) in settingsViewModels.enumerated() {
      if section == index {
        return settingsViewModel.settingsCellViewModels?.count ?? 0
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kDPSettingsListCellReuseID, for: indexPath)
    let settingsViewModel: DPSettingsViewModel? = settingsViewModels[indexPath.section]
    let settingsCellViewModel: DPSettingsCellViewModel? = settingsViewModel?.settingsCellViewModels?[indexPath.row]
    cell.textLabel?.text = settingsCellViewModel?.title?.localized
    cell.textLabel?.textColor = UIColor.white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    cell.backgroundColor = settingsCellViewModel?.color
    return cell
  }

}

extension DPSettingsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? 100 : kDPSettingsDefaultSectionHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      guard let settingsSectionView =
        Bundle.main.loadNibNamed("DPSettingsSectionView",
                                 owner: self, options: nil)?.last as? DPSettingsSectionView else {
                                  return nil
      }
      settingsSectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
      return settingsSectionView
    }
    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: kDPSettingsDefaultSectionHeight))
    view.backgroundColor = Palette.gallery
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let settingsViewModel: DPSettingsViewModel? = settingsViewModels[indexPath.section]
    let settingsCellViewModel: DPSettingsCellViewModel? = settingsViewModel?.settingsCellViewModels?[indexPath.row]
    return settingsCellViewModel?.cellHeight ?? kDefaultCellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let settingsViewModel: DPSettingsViewModel? = settingsViewModels[indexPath.section]
    let settingsCellViewModel: DPSettingsCellViewModel? = settingsViewModel?.settingsCellViewModels?[indexPath.row]
    settingsCellViewModel?.actionBlock?()
  }

}
