//
//  StandardViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/26/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit

class StandardViewController: UIViewController {
	@IBOutlet weak var chairView: UIView!
	@IBOutlet weak var chairImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var swatchesView: UIView!
	
	var rotateIndex = 0
	var swatches: [[String:String]] = []
	var swatchIndex = 0
	
	var currentPanAmount: Float = 0.0
	var panThreshold: Float = 6.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		swatches = [
			["title": "Neutral Light to Dark", "key": "light-dark"],
			["title": "Neutral Dark to Light", "key": "dark-light"],
			["title": "3k Woven Carbon Fiber", "key": "3K_carbon_fiber"],
			["title": "Denim Blue", "key": "carbon_fade"],
			["title": "Metalllic Copper Paint", "key": "metallic-copper"],
			["title": "Color Red to Pink", "key": "redpink_fade"]
		]
		
		(self.swatchesView.viewWithTag(0)! as! SwatchThumbnail).selected = true
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.title = nil
			
			let logoImageView = UIImageView(image: UIImage(named: "header_logo"))
			logoImageView.frame = CGRectMake(0,0,144,14)
			logoImageView.contentMode = .ScaleAspectFit
			
			self.parentViewController!.navigationItem.titleView = logoImageView
			
			self.parentViewController!.navigationItem.rightBarButtonItem = nil
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
// MARK:
	
	func updateImage(animated: Bool = false) {
		let swatchInfo = swatches[self.swatchIndex]
		let key = swatchInfo["key"]
		titleLabel.text = swatchInfo["title"]
		
		if animated {
			UIView.transitionWithView(chairImageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
				self.chairImageView.image = UIImage(named: "\(key!)\(self.rotateIndex)")
				}, completion: { finished in
					
			})
		} else {
			self.chairImageView.image = UIImage(named: "\(key!)\(self.rotateIndex)")
		}
	}
	
	@IBAction func changeSwatch(gesture: UITapGestureRecognizer) {
		let swatch = gesture.view! as! SwatchThumbnail
		
		for view in swatchesView.subviews {
			if let swatch = view as? SwatchThumbnail {
				swatch.selected = false
			}
		}
		
		swatch.selected = true
		self.swatchIndex = swatch.tag
		
		updateImage(animated: true)
	}
	
	
	@IBAction func didPan(pan: UIPanGestureRecognizer) {
		let touch = pan.translationInView(pan.view!)
		
		currentPanAmount += Float(touch.x)
		
		if currentPanAmount < (-1.0 * panThreshold) {
			rotateIndex += 3
			if rotateIndex > 96 {
				rotateIndex = 0
			}
			updateImage()
			
			currentPanAmount = 0.0
		} else if currentPanAmount > panThreshold {
			rotateIndex -= 3
			if rotateIndex < 0 {
				rotateIndex = 96
			}
			updateImage()
			
			currentPanAmount = 0.0
		}
		
		pan.setTranslation(CGPointZero, inView: pan.view!)
	}
}