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
	override func viewDidLoad() {
		super.viewDidLoad()
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