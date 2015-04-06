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
		set(newValue) {
			_startSwatchThumbnailLeadingConstraint.constant = CGFloat(newValue[0]) * (CGFloat(self.trackView.bounds.size.width) - CGFloat(self.startSwatchThumbnail.bounds.size.width))
			_endSwatchThumbnailLeadingConstraint.constant = CGFloat(newValue[1]) * (CGFloat(self.trackView.bounds.size.width) - CGFloat(self.endSwatchThumbnail.bounds.size.width))
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


class ColorPickerView:UIView {
	@IBOutlet weak var hueWheelView: HueWheelView!
	@IBOutlet weak var hueCrosshairsView: UIView!
	@IBOutlet weak var saturationPickerView: SaturationPickerView!
	@IBOutlet weak var brightnessPickerView: BrightnessPickerView!
	@IBOutlet weak var chooseButton: UIButton!
	
	var hue: Float = 0.0 {
		didSet {
			chooseButton.backgroundColor = self.color
			
			self.saturationPickerView.update(self.hue)
			self.brightnessPickerView.update(self.hue, saturation: self.saturation)
		}
	}
	
	var saturation: Float = 1.0 {
		didSet {
			chooseButton.backgroundColor = self.color
			
			self.brightnessPickerView.update(self.hue, saturation: self.saturation)
		}
	}
	
	var brightness: Float = 1.0 {
		didSet {
			chooseButton.backgroundColor = self.color
		}
	}
	
	var color: UIColor {
		get {
			return UIColor(hue: CGFloat(self.hue), saturation: CGFloat(self.saturation), brightness: CGFloat(self.brightness), alpha: 1.0)
		}
		set(newValue) {
			var _hue: CGFloat = 0.0
			var _saturation: CGFloat = 0.0
			var _brightness: CGFloat = 0.0
			var _alpha: CGFloat = 0.0
			
			newValue.getHue(&_hue, saturation: &_saturation, brightness: &_brightness, alpha: &_alpha)
			
			self.hue = Float(_hue)
			self.saturation = Float(_saturation)
			self.brightness = Float(_brightness)
			
			updatePickerDisplays(true)
		}
	}
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		chooseButton.layer.cornerRadius = 6.0
		chooseButton.clipsToBounds = true
	}
	
	func updatePickerDisplays(crosshairs: Bool) {
		self.saturationPickerView.update(self.hue)
		self.brightnessPickerView.update(self.hue, saturation: self.saturation)
		
		if crosshairs {
			var degrees = (CGFloat(self.hue) * 360.0) - 90.0
			var radians = degrees / 180.0 * CGFloat(M_PI)
		
			self.hueCrosshairsView.transform = CGAffineTransformMakeRotation(radians)
			
			
			var saturationAdjustedWidth = self.saturationPickerView.bounds.size.width - self.saturationPickerView.crosshairsImageView.bounds.size.width
			self.saturationPickerView._crosshairsImageViewLeadingConstraint.constant = CGFloat(self.saturation) * saturationAdjustedWidth
			
			
			var brightnessAdjustedWidth = self.brightnessPickerView.bounds.size.width - self.brightnessPickerView.crosshairsImageView.bounds.size.width
			self.brightnessPickerView._crosshairsImageViewLeadingConstraint.constant = CGFloat(self.brightness) * brightnessAdjustedWidth
		}
	}
	
	
	@IBAction func didPanHueWheel(gesture: UIGestureRecognizer) {
		let touch = gesture.locationInView(self.hueWheelView)
		
		var dx = touch.x - self.hueWheelView.bounds.size.width / 2.0
		var dy = touch.y - self.hueWheelView.bounds.size.height / 2.0
		
		let angle = atan2(dy,dx)
		let degrees = angle * (180.0 / CGFloat(M_PI))
		
		var _hue = Float(degrees) + 90.0
		if _hue < 0 {
			_hue = 360.0 + _hue
		}
		self.hue = _hue / 360.0
		
		self.hueCrosshairsView.transform = CGAffineTransformMakeRotation(angle);
	}
	
	
	@IBAction func didPanColorValue(gesture: UIGestureRecognizer) {
		let colorView = gesture.view! as ColorValuePickerView
		let touch = gesture.locationInView(colorView)
		
		colorView._crosshairsImageViewLeadingConstraint.constant = touch.x - (colorView.crosshairsImageView.bounds.size.width / 2.0)
		
		var adjustedWidth = colorView.bounds.size.width - colorView.crosshairsImageView.bounds.size.width
		var value = min(adjustedWidth,max(0,colorView._crosshairsImageViewLeadingConstraint.constant))
		value = value / adjustedWidth
		
		if colorView == self.saturationPickerView {
			self.saturation = Float(value)
		} else if colorView == self.brightnessPickerView {
			self.brightness = Float(value)
		}
	}
	
}

class HueWheelView:UIView {
	
	override func awakeFromNib() {
		self.layer.cornerRadius = self.bounds.size.width / 2.0
		self.clipsToBounds = true
		
		self.backgroundColor = UIColor.clearColor()
	}
}


class ColorValuePickerView: UIView {
	@IBOutlet weak var crosshairsImageView: UIImageView!
	@IBOutlet weak var _crosshairsImageViewLeadingConstraint: NSLayoutConstraint!
	
	var gradiantLayer: CAGradientLayer = CAGradientLayer()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		gradiantLayer.bounds = self.bounds
		gradiantLayer.anchorPoint = CGPointZero
		gradiantLayer.startPoint = CGPointMake(0.0, 0.5);
		gradiantLayer.endPoint = CGPointMake(1.0, 0.5);
		
		self.layer.insertSublayer(gradiantLayer, atIndex: 0)
	}
}

class SaturationPickerView: ColorValuePickerView {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.crosshairsImageView.image = self.crosshairsImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		self.crosshairsImageView.tintColor = UIColor.blackColor()
	}
	
	func update(hue: Float) {
		self.gradiantLayer.colors = [UIColor(hue: CGFloat(hue), saturation: 0.0, brightness: 1.0, alpha: 1.0).CGColor,UIColor(hue: CGFloat(hue), saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor]
	}
}

class BrightnessPickerView: ColorValuePickerView {
	func update(hue: Float, saturation: Float) {
		self.gradiantLayer.colors = [UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: 0.0, alpha: 1.0).CGColor,UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: 1.0, alpha: 1.0).CGColor]
	}
}

