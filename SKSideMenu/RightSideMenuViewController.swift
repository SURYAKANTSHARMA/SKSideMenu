//
//  RightSideMenuViewController.swift
//  SKSideMenu
//
//  Created by SuryaKant Sharma on 29/04/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit

class RightSideMenuViewController: UIViewController {

    @IBAction func vc1Pressed(_ sender: UIButton) {
        if let containerViewController = self.parent as? ContainerViewController {
            containerViewController.showVC1()
        }
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        if let containerViewController = self.parent as? ContainerViewController {
            containerViewController.addHomeAsChildVC()
        }
    }

}
