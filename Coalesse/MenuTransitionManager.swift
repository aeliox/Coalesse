//
//  MenuAnimator.swift
//  Thred
//
//  Created by Keiran Flanigan on 3/7/15.
//  Copyright (c) 2015 aeliox. All rights reserved.
//

import UIKit
import Foundation

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
	
	private var presenting = false
	private var originalPresentingViewController:UIViewController?
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		let container = transitionContext.containerView()
		
		let screens: (from: UIViewController, to: UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
		
		let menuViewController = !self.presenting ? screens.from as MenuViewController : screens.to as MenuViewController
		let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
		
		let menuView = menuViewController.view
		
		
		if self.presenting {
			menuViewController._menuViewHolderWidthConstraint.constant = 0
			menuViewController.updateViewConstraints()
			menuViewController.view.layoutIfNeeded()
			
			self.hideMenuButtons(menuViewController.buttons(),animated: false)
		}
		
		container.addSubview(menuView)
		
		
		let duration = self.transitionDuration(transitionContext)
		
		if self.presenting {
			
			menuViewController._menuViewHolderWidthConstraint.constant = 200
			menuViewController.updateViewConstraints()
			
			self.showMenuButtons(menuViewController.buttons())
			
			UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
				menuViewController.view.layoutIfNeeded()
				}, completion: { finished in
					transitionContext.completeTransition(true)
				}
			)

		} else {
			
			menuViewController._menuViewHolderWidthConstraint.constant = 0
			menuViewController.updateViewConstraints()
			
			self.hideMenuButtons(menuViewController.buttons())
			
			UIView.animateWithDuration(duration, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
				menuViewController.view.layoutIfNeeded()
				}, completion: { finished in
					transitionContext.completeTransition(true)
				}
			)
			
		}
	}
	
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return 0.6
	}
	
	// MARK: UIViewControllerTransitioningDelegate protocol methods
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self.presenting = true
		return self
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self.presenting = false
		return self
	}
	
	
	func showMenuButtons(buttons: [UIButton], animated: Bool = true) {
		for (index,button) in enumerate(buttons) {
			let duration = (animated ? 0.35 : 0.0)
			let delay = (animated ? (Double(index) * 0.08) : 0.0)
			
			UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
				button.transform = CGAffineTransformIdentity
				button.alpha = 1.0;
				}, completion: { finished in
				}
			)
			
		}
	}
	
	func hideMenuButtons(buttons: [UIButton], animated: Bool = true) {
		for (index,button) in enumerate(reverse(buttons)) {
			let duration = (animated ? 0.25 : 0.0)
			let delay = (animated ? (Double(index) * 0.06) : 0.0)
			
			UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
				button.transform = CGAffineTransformMakeTranslation(-20, 0)
				button.alpha = 0.0;
				}, completion: { finished in
				}
			)
			
		}
	}
}