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
	@IBOutlet weak var aboutTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if self.view.bounds.size.height <= 568.0 || UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			var text = aboutTextView.attributedText.mutableCopy() as NSMutableAttributedString
			text.beginEditing()
			text.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, text.length), options: nil, usingBlock: { (let value, let range, let stop) -> Void in
				if value != nil {
					let oldFont = value as UIFont;
					let newFont = oldFont.fontWithSize((UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 18.0 : (self.view.bounds.size.height <= 480.0 ? 11.0 : 13.0 )))
					text.removeAttribute(NSFontAttributeName, range: range)
					text.addAttribute(NSFontAttributeName, value: newFont, range: range)
				}
			})
			text.endEditing()
			
			aboutTextView.attributedText = text
		}
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.titleView = nil
			self.parentViewController!.navigationItem.title = "About"
			
			self.parentViewController!.navigationItem.rightBarButtonItem = nil
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