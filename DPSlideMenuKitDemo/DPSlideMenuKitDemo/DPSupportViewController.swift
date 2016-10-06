//
//  DPSupportViewController.swift
//  DPSlideMenuKitDemo
//
//  Created by Hongli Yu on 8/18/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class DPSupportViewController: DPContentViewController {
  
  override init(nibName nibNameOrNil: String?,
                        bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
  }
  
  required internal init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
