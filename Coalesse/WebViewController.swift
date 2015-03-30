//
//  WebViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/29/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
	
	var url: NSURL? = nil
	var webView: WKWebView!
	
	private var myContext = 0
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var urlLabel: UILabel!
	
	@IBOutlet weak var progressView: UIProgressView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView = WKWebView()
		webView.setTranslatesAutoresizingMaskIntoConstraints(false)
		webView.navigationDelegate = self
		
		self.view.insertSubview(webView, belowSubview: progressView)
		
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["webView": webView]))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["webView": webView]))
		
		
		self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: &myContext)
		
		
		let closeButton = UIBarButtonItem(image: UIImage(named: "icon_close"), style: .Plain, target: self, action: "closeAction")
		closeButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
		let shareButton = UIBarButtonItem(image: UIImage(named: "icon_share"), style: .Plain, target: self, action: "openAction")
		shareButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -10)
		
		self.navigationItem.rightBarButtonItems = [closeButton,shareButton]
	}
	
	deinit {
		self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.url != nil {
			self.urlLabel.text = self.url!.absoluteString
			webView.loadRequest(NSURLRequest(URL: self.url!))
		}
	}
	
	
	@IBAction func closeAction() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func openAction() {
		if self.webView.URL != nil {
			UIApplication.sharedApplication().openURL(self.webView.URL!)
		}
	}
	
	
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		if context == &myContext {
			self.progressView.progress = Float(change[NSKeyValueChangeNewKey]! as NSNumber)
			progressViewDidChange()
		} else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	
// MARK: WebView
	
	func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
		if webView.title != nil {
			self.titleLabel.text = webView.title!
		}
		
		if webView.canGoBack || webView.canGoForward {
			let backButton = UIBarButtonItem(image: UIImage(named: "icon_web_back"), style: .Plain, target: self.webView, action: "goBack")
			backButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -10)
			backButton.enabled = webView.canGoBack
			let forwardButton = UIBarButtonItem(image: UIImage(named: "icon_web_forward"), style: .Plain, target: self.webView, action: "goForward")
			forwardButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
			forwardButton.enabled = webView.canGoForward
			
			self.navigationItem.leftBarButtonItems = [backButton,forwardButton]
			
			self.titleLabel.textAlignment = .Center
			self.urlLabel.textAlignment = .Center
		} else {
			self.navigationItem.leftBarButtonItems = []
			
			self.titleLabel.textAlignment = .Left
			self.urlLabel.textAlignment = .Left
		}
	}
	
	func progressViewDidChange() {
		if self.progressView.progress == 0.0 || self.progressView.progress == 1.0 {
			self.progressView.alpha = 0.0
		} else {
			self.progressView.alpha = 1.0
		}
	}
}