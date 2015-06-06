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
	@IBOutlet weak var aboutTitleLabel: UILabel!
	@IBOutlet weak var aboutTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var text = aboutTextView.text as NSString
		
		var attributedText = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName: UIFont(name: "Garamond", size: 18.0)!, NSForegroundColorAttributeName: UIColor.blackColor()])
		
		attributedText.addAttributes([NSFontAttributeName: UIFont(name: "Garamond-Bold", size: 18.0)!], range: text.rangeOfString("bring new life to work"))
		attributedText.addAttributes([NSFontAttributeName: UIFont(name: "Garamond-Bold", size: 18.0)!], range: text.rangeOfString("coalesse.com"))
		
		aboutTextView.text = ""
		aboutTextView.attributedText = attributedText
		
		
		if self.view.bounds.size.height <= 568.0 || UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			aboutTitleLabel.font = aboutTextView.font.fontWithSize(32.0)
			
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