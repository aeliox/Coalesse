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
	@IBOutlet weak var _aboutTextViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var _aboutTextViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var linkTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var text = aboutTextView.text as NSString
		
		var attributedText = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName: UIFont(name: "Garamond", size: 18.0)!, NSForegroundColorAttributeName: UIColor.blackColor()])
		
		attributedText.addAttributes([NSFontAttributeName: UIFont(name: "Garamond-Bold", size: 18.0)!], range: text.rangeOfString("bring new life to work"))
		
		aboutTextView.text = ""
		aboutTextView.attributedText = attributedText
		
		linkTextView.font = UIFont(name: "Garamond-Bold", size: 18.0)
		
		
		if self.view.bounds.size.height <= 568.0 || UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			
			var text = aboutTextView.attributedText.mutableCopy() as! NSMutableAttributedString
			text.beginEditing()
			text.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, text.length), options: nil, usingBlock: { (let value, let range, let stop) -> Void in
				if value != nil {
					let oldFont = value as! UIFont;
					let newFont = oldFont.fontWithSize((UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 21.0 : 15.0))
					text.removeAttribute(NSFontAttributeName, range: range)
					text.addAttribute(NSFontAttributeName, value: newFont, range: range)
				}
			})
			text.endEditing()
			
			aboutTextView.attributedText = text
			
			
			linkTextView.font = UIFont(name: "Garamond-Bold", size: (UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 21.0 : 15.0))
			
			
			if self.view.bounds.size.height <= 480.0 {
				_aboutTextViewTopConstraint.constant = 30.0
				_aboutTextViewBottomConstraint.constant = 30.0
			}
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
	
	
	func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
		NSNotificationCenter.defaultCenter().postNotificationName("ShowWebView", object: URL)
		
		return false
	}
}