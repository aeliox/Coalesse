//
//  ImageViews.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 4/3/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit

class SwatchThumbnail:UIView {
	@IBOutlet weak var swatchView: UIView!
	var selectedShape: CAShapeLayer = CAShapeLayer()
	
	var selected: Bool = false {
		didSet {
			if selected {
				selectedShape.strokeEnd = 1
			} else {
				selectedShape.strokeEnd = 0
			}
		}
	}
	

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.swatchView.layer.cornerRadius = self.swatchView.bounds.size.width / 2.0
		self.swatchView.clipsToBounds = true
		
		let basePath = CGPathCreateMutable()
		CGPathAddArc(basePath, nil, self.bounds.size.width / 2.0, self.bounds.size.width / 2.0, self.bounds.size.width / 2.0, 0, CGFloat(M_PI*2), true)
		self.selectedShape.path = basePath
		self.selectedShape.lineWidth = 0.5
		self.selectedShape.fillColor = nil
		self.selectedShape.strokeColor = UIColor.lightGrayColor().CGColor
		self.selectedShape.strokeEnd = 0
		
		self.layer.addSublayer(selectedShape)
	}
}


class GradientCreatorView:UIView {
	@IBOutlet weak var trackView: UIView!
	@IBOutlet weak var startSwatchThumbnail: SwatchThumbnail!
	@IBOutlet weak var _startSwatchThumbnailLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var endSwatchThumbnail: SwatchThumbnail!
	@IBOutlet weak var _endSwatchThumbnailLeadingConstraint: NSLayoutConstraint!
	
	var startColor: UIColor = UIColor.whiteColor() {
		didSet {
			startSwatchThumbnail!.swatchView.backgroundColor = self.startColor
			NSNotificationCenter.defaultCenter().postNotificationName("GradientCreatorChanged", object: nil)
		}
	}
	
	var endColor: UIColor = UIColor.blackColor() {
		didSet {
			endSwatchThumbnail!.swatchView.backgroundColor = self.endColor
			NSNotificationCenter.defaultCenter().postNotificationName("GradientCreatorChanged", object: nil)
		}
	}
	
	var colors: [UIColor] {
		get {
			return [startColor,endColor]
		}
	}
	
	var offsets: [Float] {
		get {
			return [
				min(1.0,max(0.0,(Float(self._startSwatchThumbnailLeadingConstraint.constant) / (Float(self.trackView.bounds.size.width) - Float(self.startSwatchThumbnail.bounds.size.width))))),
				min(1.0,max(0.0,(Float(self._endSwatchThumbnailLeadingConstraint.constant) / (Float(self.trackView.bounds.size.width) - Float(self.endSwatchThumbnail.bounds.size.width)))))
			]
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func didPanTrackView(pan: UIGestureRecognizer) {
		var location = pan.locationInView(self.trackView)

		if pan.view! == self.startSwatchThumbnail {
			_startSwatchThumbnailLeadingConstraint.constant = location.x - self.startSwatchThumbnail.bounds.size.width / 2.0
		} else if pan.view! == self.endSwatchThumbnail {
			_endSwatchThumbnailLeadingConstraint.constant = location.x - self.endSwatchThumbnail.bounds.size.width / 2.0
		}
		
		NSNotificationCenter.defaultCenter().postNotificationName("GradientCreatorChanged", object: nil)
	}
}