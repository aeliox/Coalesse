//
//  ViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/13/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
	let transitionManager = ContainerTransitionManager()
	
	@IBOutlet weak var containerView: UIView!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController!.navigationBar.translucent = false
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectMenuNav:", name: "DidSelectMenuNav", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWebView:", name: "ShowWebView", object: nil)
		
		//self.transitioningDelegate = self.transitionManager
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
// MARK: Nav
	
	func didSelectMenuNav(notification: NSNotification) {
		var newViewController: UIViewController?
		
		switch notification.object as String {
		case "customize":
			newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CustomizeVC") as? CustomizeViewController
		case "standard":
			newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StandardVC") as? StandardViewController
		case "saved":
			newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SavedVC") as? SavedViewController
		case "settings":
			newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingsVC") as? SettingsViewController
		case "about":
			newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AboutVC") as? AboutViewController
		default:
			newViewController = nil
		}
		
		
		if newViewController != nil {
			let newController = newViewController!
			let oldController = childViewControllers.last as UIViewController
			
			oldController.willMoveToParentViewController(nil)
			newController.willMoveToParentViewController(self)
			self.addChildViewController(newController)
			newController.view.frame = oldController.view.frame
			newController.view.alpha = 0.0;
			newController.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
			
			
			self.transitionFromViewController(oldController, toViewController: newController, duration: 0.5, options: .TransitionNone, animations:{ () -> Void in
				
				oldController.view.alpha = 0.0;
				oldController.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
				
				}, completion: { finished in
					
					UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: nil, animations: {
						
						newController.view.alpha = 1.0;
						newController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
						
						}, completion: { finished in
							oldController.removeFromParentViewController()
							newController.didMoveToParentViewController(self)
						}
					)
					
				}
			)
			
		}
	}
	
	@IBAction func unwindToMainViewController(sender: UIStoryboardSegue){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	func showWebView(notification: NSNotification) {
		let webNavVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebNavVC") as? UINavigationController
		let webVC = webNavVC!.viewControllers![0] as? WebViewController
		
		webVC!.url = (notification.object as NSURL)
		
		self.navigationController!.presentViewController(webNavVC!, animated: true, completion: nil)
	}
}


class DefaultViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	deinit {
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	@IBAction func standardAction() {
		NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "standard")
	}
	
	@IBAction func customizeAction() {
		NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "customize")
	}
}