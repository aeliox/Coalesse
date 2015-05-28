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
		
		let logoImageView = UIImageView(image: UIImage(named: "header_logo"))
		logoImageView.frame = CGRectMake(0,0,144,14)
		logoImageView.contentMode = .ScaleAspectFit
		
		self.navigationItem.titleView = logoImageView
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
		openViewController(notification)
	}
	
	func showSavedDesign(design: Design) {
		let notification = NSNotification(name: "", object: "customize")
		openViewController(notification, savedDesign: design)
	}
	
	func openViewController(notification: NSNotification, savedDesign: Design? = nil) {
		var newViewController: UIViewController?
		
		switch notification.object as! String {
		case "customize":
			newViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CustomizeVC") as? CustomizeViewController
			if savedDesign != nil {
				(newViewController as! CustomizeViewController).design = savedDesign
			}
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
			let oldController = childViewControllers.last as! UIViewController
			
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
		
		webVC!.url = (notification.object as! NSURL)
		
		self.navigationController!.presentViewController(webNavVC!, animated: true, completion: nil)
	}
}


class DefaultViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var _titleLabelLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var captionLabel: UILabel!
	@IBOutlet weak var chairImageView: UIImageView!
	@IBOutlet weak var _chairImageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var _chairImageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var _chairImageViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var _chairImageViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var standardButton: UIButton!
	@IBOutlet weak var _standardButtonCenterYConstraint: NSLayoutConstraint!
	@IBOutlet weak var _standardButtonWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var _standardButtonHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var customizeButton: UIButton!
	@IBOutlet weak var _customizeButtonTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var _customizeButtonWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var _customizeButtonHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var footerLogo: UIImageView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if self.view.bounds.size.width <= 320.0 {
			self._titleLabelLeadingConstraint.constant = 15.0
			self._standardButtonCenterYConstraint.constant = -50.0
			
			if self.view.bounds.size.height <= 480.0 {
				self._standardButtonCenterYConstraint.constant = -80.0
				self.footerLogo.hidden = true
			}
			
			self.view.updateConstraints()
			self.view.layoutIfNeeded()
		}
		
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			self.titleLabel.font = self.titleLabel.font.fontWithSize(32.0)
			self.captionLabel.font = self.captionLabel.font.fontWithSize(24.0)
			
			self.chairImageView.image = UIImage(named: "default_chair_ipad")
			self._chairImageViewWidthConstraint.constant = 278.0
			self._chairImageViewHeightConstraint.constant = 270.0
			
			self._standardButtonCenterYConstraint.constant = 80.0
			self._standardButtonWidthConstraint.constant = 434.0
			self._standardButtonHeightConstraint.constant = 60.0
			self.standardButton.setImage(UIImage(named: "default_standardcolors_ipad"), forState: .Normal)
			
			self._customizeButtonTopConstraint.constant = 50.0
			self._customizeButtonWidthConstraint.constant = 365.0
			self._customizeButtonHeightConstraint.constant = 60.0
			self.customizeButton.setImage(UIImage(named: "default_customize_ipad"), forState: .Normal)
			
			self.view.updateConstraints()
			self.view.layoutIfNeeded()
			
			delay(0.01) {
				self.view.removeConstraint(self._chairImageViewBottomConstraint)
				self.view.removeConstraint(self._chairImageViewLeadingConstraint)
				
				self.view.updateConstraints()
				self.view.layoutIfNeeded()
			}
		}
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