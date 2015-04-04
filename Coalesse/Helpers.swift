//
//  Helpers.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 4/3/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit


typealias dispatch_cancelable_closure = (cancel : Bool) -> ()

func delay(time:NSTimeInterval, closure:()->()) ->  dispatch_cancelable_closure? {
	
	func dispatch_later(clsr:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(time * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), clsr)
	}
	
	var closure:dispatch_block_t? = closure
	var cancelableClosure:dispatch_cancelable_closure?
	
	let delayedClosure:dispatch_cancelable_closure = { cancel in
		if let clsr = closure {
			if (cancel == false) {
				dispatch_async(dispatch_get_main_queue(), clsr);
			}
		}
		closure = nil
		cancelableClosure = nil
	}
	
	cancelableClosure = delayedClosure
	
	dispatch_later {
		if let delayedClosure = cancelableClosure {
			delayedClosure(cancel: false)
		}
	}
	
	return cancelableClosure;
}

func cancel_delay(closure:dispatch_cancelable_closure?) {
	
	if closure != nil {
		closure!(cancel: true)
	}
}

extension UIColor {

	class func random() -> UIColor {
		var hue = ( Float(arc4random_uniform(256)) / 256.0 );  //  0.0 to 1.0
		var saturation = ( Float(arc4random_uniform(128)) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
		var brightness = ( Float(arc4random_uniform(128)) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
		
		let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
		
		return color
	}
	
}