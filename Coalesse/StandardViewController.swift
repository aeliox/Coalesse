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
	
	var rotateIndex = 1
	var swatches: [[String:String]] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		swatches = [
			["title": "Neutral Light to Dark", "key": "neutral"],
			["title": "Neutral Dark to Light", "key": "neutral-flipped"],
			["title": "3k Woven Carbon Fiber", "key": "carbon"],
			["title": "Denim Blue", "key": "denim"],
			["title": "Metalllic Copper Paint", "key": "copper"],
			["title": "Color Red to Pink", "key": "redtopink"]
		]
		
		(self.swatchesView.viewWithTag(0)! as SwatchThumbnail).selected = true
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.title = nil
			
			let logoImageView = UIImageView(image: UIImage(named: "header_logo"))
			logoImageView.frame = CGRectMake(0,0,144,14)
			logoImageView.contentMode = .ScaleAspectFit
			
			self.parentViewController!.navigationItem.titleView = logoImageView
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
// MARK:
	
	@IBAction func changeSwatch(gesture: UITapGestureRecognizer) {
		let swatch = gesture.view! as SwatchThumbnail
		
		for view in swatchesView.subviews {
			if let swatch = view as? SwatchThumbnail {
				swatch.selected = false
			}
		}
		
		swatch.selected = true
		
		let swatchInfo = swatches[swatch.tag]
		let key = swatchInfo["key"]
		titleLabel.text = swatchInfo["title"]
		
		UIView.transitionWithView(chairImageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
			self.chairImageView.image = UIImage(named: "chair_standard_\(key!)_\(self.rotateIndex)")
			}, completion: { finished in
				
			})
	}
}