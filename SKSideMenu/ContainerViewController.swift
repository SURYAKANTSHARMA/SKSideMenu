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
    
    var currentlyShownNavigationController: UINavigationController! {
        didSet {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            currentlyShownNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    var currentlyShownViewController: UIViewController!
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = (currentState != .bothCollapsed)
            self.showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: UIViewController?
    var rightViewController: UIViewController?
    
    let centerPanelExpandedOffset: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHomeAsChildVC()
    }
    
    func addHomeAsChildVC() {
        collapseSidePanels()
        
        currentlyShownNavigationController?.willMove(toParentViewController: nil)
        currentlyShownNavigationController?.view.removeFromSuperview()
        currentlyShownNavigationController?.removeFromParentViewController()
        currentlyShownViewController = UIStoryboard.homeViewController()
        if let currentlyShownViewController = currentlyShownViewController as? HomeViewController {
            currentlyShownViewController.delegate  = self
        }
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar

        if let currentlyShownNavigationController = currentlyShownNavigationController, currentlyShownNavigationController.viewControllers.count > 0 {
         self.currentlyShownNavigationController?.viewControllers.remove(at: 0)
         self.currentlyShownNavigationController?.viewControllers = [currentlyShownViewController]
        } else {
            currentlyShownNavigationController = UINavigationController(rootViewController: currentlyShownViewController)
        }
        
        self.view.addSubview(self.currentlyShownNavigationController.view)
        view.addSubview(currentlyShownNavigationController.view)
        addChildViewController(currentlyShownNavigationController)
        currentlyShownNavigationController.didMove(toParentViewController: self)
    }
    func showVC1() {
           collapseSidePanels()

            self.currentlyShownViewController?.willMove(toParentViewController: nil)
            self.currentlyShownNavigationController?.view.removeFromSuperview()
            self.currentlyShownNavigationController.removeFromParentViewController()
            
            self.currentlyShownViewController = UIStoryboard.VC1()
            if let currentlyShownViewController = self.currentlyShownViewController as? ViewController1 {
                currentlyShownViewController.delegate = self
            }
           if let currentlyShownNavigationController = currentlyShownNavigationController, currentlyShownNavigationController.viewControllers.count > 0 {
            self.currentlyShownNavigationController?.viewControllers.remove(at: 0)
            self.currentlyShownNavigationController?.viewControllers = [currentlyShownViewController]
           } else {
            currentlyShownNavigationController = UINavigationController(rootViewController: currentlyShownViewController)
          }
            self.view.addSubview(self.currentlyShownNavigationController.view)
            addChildViewController(self.currentlyShownNavigationController)
            currentlyShownNavigationController.didMove(toParentViewController: self)
        
        
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                } else {
                    addRightPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
            
        case .changed:
            //change recognizer view's center by changed x
            if let recognizerView = recognizer.view {
                recognizerView.center.x = recognizerView.center.x + recognizer.translation(in: recognizerView).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if let _ = leftViewController, let recognizerView = recognizer.view {
                let hasMoveGreaterThanHalfAway = recognizerView.center.x > view.bounds.width
                animateLeftPanel(shouldExpand: hasMoveGreaterThanHalfAway)
            }
            if let _ = rightViewController, let recognizerView = recognizer.view {
                let hasMoveGreaterThanHalfAway = recognizerView.center.x < 0
                animateRightPanel(shouldExpand: hasMoveGreaterThanHalfAway)
            }
        default:
            break
        }
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
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
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
    func addRightPanelViewController() {
        
        guard rightViewController == nil else { return }
        
        if let vc = UIStoryboard.rightViewController() {
            addChildSidePanelController(vc)
            rightViewController = vc
        }
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
    
    func animateRightPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: -currentlyShownNavigationController.view.frame.width + centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
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
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            currentlyShownNavigationController?.view.layer.shadowOpacity = 1
            currentlyShownNavigationController?.view.layer.shadowRadius = 5
        } else {
            currentlyShownNavigationController?.view.layer.shadowOpacity = 0.0
            currentlyShownNavigationController?.view.layer.shadowRadius = 0
        }
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
    
    static func rightViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "rightVC") as? UIViewController
    }
    
    static func homeViewController() -> HomeViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
    }
}

