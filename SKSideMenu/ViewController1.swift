//
//  ViewController1.swift
//  SKSideMenu
//
//  Created by SuryaKant Sharma on 28/04/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {
    
    var delegate: ContainerControllerDelegate?
    
    @IBAction func leftMenuPressed(_ sender: UIBarButtonItem) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func rightMenuPressed(_ sender: UIBarButtonItem) {
        delegate?.toggleRightPanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
