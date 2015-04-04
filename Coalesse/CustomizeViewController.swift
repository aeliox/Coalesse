//
//  CustomizeViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/14/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class CustomizeViewController: UIViewController {
	@IBOutlet weak var shadowsImageView: UIImageView!
	@IBOutlet weak var mainImageView: GPUImageView!
	@IBOutlet weak var chairFinishToggle: UISegmentedControl!
	@IBOutlet weak var gradientCreatorView: GradientCreatorView!
	
	
	var gradientColors: [UIColor] = []
	var gradientOffsets: [Float] = []
	
	var gpuChair: GPUImagePicture?
	var gpuGradient: GPUImagePicture?
	var gpuChairMask: GPUImagePicture?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		gradientCreatorView.startColor = UIColor.random()
		gradientCreatorView.endColor = UIColor.random()
		
		mainImageView.backgroundColor = UIColor.clearColor()
		mainImageView.setBackgroundColorRed(1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateGradient", name: "GradientCreatorChanged", object: nil)
		
		
		updateGradient()
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
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
	
	
// MARK: Images
	
	@IBAction func didChangeChairFinish() {
		gradientOffsets = []
		updateGradient()
	}
	
	func updateGradient() {
		if self.gradientCreatorView.colors != gradientColors || self.gradientCreatorView.offsets != gradientOffsets {
			gradientColors = self.gradientCreatorView.colors
			gradientOffsets = self.gradientCreatorView.offsets
			
			
			UIGraphicsBeginImageContextWithOptions(mainImageView.bounds.size, false, 0.0)
			let context = UIGraphicsGetCurrentContext()
			let locations = [CGFloat(gradientOffsets[0]),CGFloat(gradientOffsets[1])]
			let colors = [gradientColors[0].CGColor!,gradientColors[1].CGColor!]
			let colorspace = CGColorSpaceCreateDeviceRGB()
			let gradient = CGGradientCreateWithColors(colorspace, colors, locations)
			let startPoint = CGPointMake(0, 0)
			let endPoint = CGPointMake(0,mainImageView.bounds.size.height)
			CGContextDrawLinearGradient(context, gradient,startPoint, endPoint, 0);
			let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext();
			
			//shadowsImageView.image = gradientImage
			
			gpuGradient = GPUImagePicture(image: gradientImage)
			var finish = ( self.chairFinishToggle.selectedSegmentIndex == 0 ? "gloss" : "matte")
			gpuChair = GPUImagePicture(image: UIImage(named: "chair_custom_\(finish)"))
			gpuChairMask = GPUImagePicture(image: UIImage(named: "chair_custom_mask"))
			
			let maskFilter = GPUImageMaskFilter()
			let blendFilter = GPUImageOverlayBlendFilter()
			
			gpuChair!.addTarget(blendFilter)
			gpuGradient!.addTarget(blendFilter)
			
			blendFilter.addTarget(maskFilter)
			gpuChairMask!.addTarget(maskFilter)
			
			maskFilter.addTarget(self.mainImageView)
			
			//gpuGradient!.addTarget(blendFilter)
			
			//blendFilter.addTarget(self.mainImageView)
			
			gpuChair!.processImage()
			gpuGradient!.processImage()
			gpuChairMask!.processImage()
		}
	}
}