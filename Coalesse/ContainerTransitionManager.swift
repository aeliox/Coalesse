//
//  ContainerTransitionManager.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/15/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import UIKit
import Foundation

class ContainerTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		let container = transitionContext.containerView()
		
		let screens: (from: UIViewController, to: UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
		
		let fromViewController = screens.from
		let toViewController = screens.to
		
		
		toViewController.view.alpha = 0.0;
		toViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
		
		container.addSubview(toViewController.view)
		
		
		let duration = self.transitionDuration(transitionContext)
		
		UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
			
			fromViewController.view.alpha = 0.0;
			fromViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
			
			}, completion: { finished in
				
				UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
					
					toViewController.view.alpha = 1.0;
					toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
					
					}, completion: { finished in
						transitionContext.completeTransition(true)
					}
				)
				
			}
		)
	}
	
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return 0.3
	}
	
}