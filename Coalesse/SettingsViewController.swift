//
//  SettingsViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/26/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
	@IBOutlet weak var pushNotificationsSwitch: UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.pushNotificationsSwitch.setOn(UIApplication.sharedApplication().isRegisteredForRemoteNotifications(), animated: true)
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.titleView = nil
			self.parentViewController!.navigationItem.title = "Settings"
			
			self.parentViewController!.navigationItem.rightBarButtonItem = nil
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	@IBAction func switchChanged() {
		if self.pushNotificationsSwitch.on {
			(UIApplication.sharedApplication().delegate as! AppDelegate).registerForPushNotifications()
		} else {
			UIApplication.sharedApplication().unregisterForRemoteNotifications()
		}
	}
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		switch indexPath.row {
		case 1:
			NSNotificationCenter.defaultCenter().postNotificationName("ShowWebView", object: NSURL(string: "http://www.coalesse.com/privacy"))
		case 2:
			NSNotificationCenter.defaultCenter().postNotificationName("ShowWebView", object: NSURL(string: "http://www.coalesse.com"))
		default:
			let z = 0
		}
	}
}