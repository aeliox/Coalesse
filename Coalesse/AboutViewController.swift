//
//  AboutViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/26/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController, UITextViewDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.titleView = nil
			self.parentViewController!.navigationItem.title = "About"
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func textView(textView: UITextView!, shouldInteractWithURL URL: NSURL!, inRange characterRange: NSRange) -> Bool {
		NSNotificationCenter.defaultCenter().postNotificationName("ShowWebView", object: URL)
		
		return false
	}
}