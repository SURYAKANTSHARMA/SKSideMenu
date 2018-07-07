//
//  HomeViewController.swift
//  SKSideMenu
//
//  Created by SuryaKant Sharma on 29/04/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit

@objc
protocol ContainerControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}

class HomeViewController: UIViewController {
    
    var delegate: ContainerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func leftMenuPressed(_ sender: UIBarButtonItem) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func rightMenuPressed(_ sender: UIBarButtonItem) {
        delegate?.toggleRightPanel?()
    }
    
}
