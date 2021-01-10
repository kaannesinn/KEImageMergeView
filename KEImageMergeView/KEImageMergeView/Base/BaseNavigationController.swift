//
//  BaseNavigationViewController.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private var isPushing = false
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.topViewController?.preferredStatusBarStyle ?? .default }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }
    override var childForStatusBarStyle: UIViewController? { return self.topViewController }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    deinit {
        self.delegate = nil
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.shadowImage = UIImage()
        self.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.isPushing = false
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard !self.isPushing else { return }
        self.isPushing = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.isPushing = false
        }
        super.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard !self.isPushing else { return }
        self.isPushing = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.isPushing = false
            completion?()
        }
        super.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        
        return viewControllers.count > 1 && self.isPushing == false
    }
}
