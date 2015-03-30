//
//  MenuViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/13/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
	let transitionManager = MenuTransitionManager()
	
	@IBOutlet weak var _menuViewHolderWidthConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var customizeButton: UIButton!
	@IBOutlet weak var standardButton: UIButton!
	@IBOutlet weak var savedButton: UIButton!
	@IBOutlet weak var settingsButton: UIButton!
	@IBOutlet weak var aboutButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.transitioningDelegate = self.transitionManager
	}
	
	func buttons() -> [UIButton] {
		return [customizeButton,standardButton,savedButton,settingsButton,aboutButton]
	}
	
	
	@IBAction func selectMenuButton(button: UIButton) {
		switch button {
		case customizeButton:
			NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "customize")
		case standardButton:
			NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "standard")
		case savedButton:
			NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "saved")
		case settingsButton:
			NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "settings")
		case aboutButton:
			NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "about")
		default:
			let z = 0
		}
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}