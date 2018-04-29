//
//  ViewController.swift
//  SKSideMenu
//
//  Created by SuryaKant Sharma on 28/04/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var currentlyShownNavigationController: UINavigationController!
    var currentlyShownViewController: UIViewController!
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = (currentState != .bothCollapsed)
            //self.showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: UIViewController?
    var rightViewController: UIViewController?
    
    let centerPanelExpandedOffset: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentlyShownViewController = UIStoryboard.homeViewController()
        if let currentlyShownViewController = currentlyShownViewController as? HomeViewController {
            currentlyShownViewController.delegate  = self
        }
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        currentlyShownNavigationController = UINavigationController(rootViewController: currentlyShownViewController)
        view.addSubview(currentlyShownNavigationController.view)
        addChildViewController(currentlyShownNavigationController)
        currentlyShownNavigationController.didMove(toParentViewController: self)
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//   currentlyShownNavigationController.view.addGestureRecognizer(panGestureRecognizer)
   
    }
    func showVC1() {
        
        currentlyShownViewController?.willMove(toParentViewController: nil)
        currentlyShownNavigationController?.view.removeFromSuperview()
        currentlyShownNavigationController.removeFromParentViewController()
        
        currentlyShownViewController = UIStoryboard.VC1()
        currentlyShownNavigationController.popViewController(animated: false)
        currentlyShownNavigationController.viewControllers = [currentlyShownViewController]
        view.addSubview(currentlyShownNavigationController.view)
        addChildViewController(currentlyShownNavigationController)
        currentlyShownNavigationController.didMove(toParentViewController: self)
    }
}

extension ContainerViewController: ContainerControllerDelegate {
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    func toggleRightPanel() {
        
    }
    func collapseSidePanels() {
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    func addLeftPanelViewController() {
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController() {
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    func addChildSidePanelController(_ sidePanelController: UIViewController) {
        //sidePanelController.delegate = centerViewController
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
        
    }
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: currentlyShownNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.currentlyShownNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
}

extension UIStoryboard {
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
    
    static func leftViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "leftVC") as? UIViewController
    }
    static func VC1() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "VC1") as? UIViewController
    }
    static func VC2() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "VC2") as? UIViewController
    }
    static func rightViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "rightVC") as? UIViewController
    }
    
    static func homeViewController() -> HomeViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
    }
}

