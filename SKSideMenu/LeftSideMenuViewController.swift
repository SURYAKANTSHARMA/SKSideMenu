//
//  LeftSideMenuViewController.swift
//  SKSideMenu
//
//  Created by SuryaKant Sharma on 29/04/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    @IBAction func vc1Pressed(_ sender: UIButton) {
        if let containerViewController = self.parent as? ContainerViewController {
            containerViewController.showVC1()
        }
    }
    
    @IBAction func vc2Pressed(_ sender: UIButton) {
        
    }
}
