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
import Realm
import MessageUI

class CustomizeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
	@IBOutlet weak var shadowsImageView: UIImageView!
	@IBOutlet weak var mainImageView: GPUImageView!
	@IBOutlet weak var chairFinishToggle: UISegmentedControl!
	@IBOutlet weak var gradientCreatorView: GradientCreatorView!
	@IBOutlet weak var colorPickerView: ColorPickerView!
	@IBOutlet weak var _colorPickerViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var _colorPickerViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var _colorPickerViewHidingTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var _colorPickerViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var _colorPickerViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var _colorPickerViewHeightConstraint: NSLayoutConstraint!
	
	
	var gradientColors: [UIColor]?
	var gradientOffsets: [Float] = []
	
	var swatchEditing: SwatchThumbnail?
	
	var gpuChair: GPUImagePicture?
	var gpuGradient: GPUImagePicture?
	var gpuChairMask: GPUImagePicture?
	
	
	var design: Design?
	
	let imagePicker = UIImagePickerController()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.imagePicker.delegate = self
		
		
		if self.design == nil {
			gradientColors = [UIColor.random(),UIColor.random()]
			gradientOffsets = [0.0,1.0]
		} else {
			gradientColors = self.design!.colors()
			gradientOffsets = self.design!.locations()
			chairFinishToggle.selectedSegmentIndex = self.design!.finish
		}
		
		gradientCreatorView.startColor = gradientColors![0]
		gradientCreatorView.endColor = gradientColors![1]
		
		mainImageView.backgroundColor = UIColor.clearColor()
		mainImageView.setBackgroundColorRed(1.0, green: 1.0, blue: 1.0, alpha: 0.0)
		
		
		
		
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateGradient", name: "GradientCreatorChanged", object: nil)
		
		delay(0.1) {
			if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
				self.view.removeConstraint(self._colorPickerViewTopConstraint)
				self.view.removeConstraint(self._colorPickerViewHidingTopConstraint)
				self.view.removeConstraint(self._colorPickerViewWidthConstraint)
				self.view.removeConstraint(self._colorPickerViewHeightConstraint)
				
				self.view.addConstraint(self._colorPickerViewBottomConstraint)
				
				self.colorPickerView.alpha = 0.0
				self._colorPickerViewBottomConstraint.constant = 0.0
				self.colorPickerView.layer.cornerRadius = 12.0
				self.colorPickerView.layer.shadowColor = UIColor.grayColor().CGColor
				self.colorPickerView.layer.shadowOpacity = 0.3
				self.colorPickerView.layer.shadowRadius = 12.0
			}
			
			
			self.gradientCreatorView.offsets = self.gradientOffsets
			self.gradientOffsets = []
			
			self.updateGradient()
		}
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.titleView = nil
			self.parentViewController!.navigationItem.title = "Customize Colors"
			
			
			var shareButton = UIBarButtonItem(image: UIImage(named: "icon_share"), style: .Plain, target: self, action: "shareAction")
			shareButton.tintColor = UIColor.lightGrayColor()
			self.parentViewController!.navigationItem.rightBarButtonItem = shareButton
		}
	}
	
	override func didMoveToParentViewController(parent: UIViewController?) {
		super.didMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			
			if NSUserDefaults.standardUserDefaults().objectForKey("hasVisitedTheCustomizer") == nil {
				
				let alertController = UIAlertController(title: "Custom Design Builder", message: "Tap the color swatches below to change their color. Drag the color swatches to adjust the gradient.", preferredStyle: .Alert)
				
				let cancelAction = UIAlertAction(title: "Got It!", style: .Cancel) { (action) in
					
				}
				alertController.addAction(cancelAction)
				
				self.presentViewController(alertController, animated: true) {
					NSUserDefaults.standardUserDefaults().setObject("yup", forKey: "hasVisitedTheCustomizer")
					NSUserDefaults.standardUserDefaults().synchronize()
				}
				
			}
			
		}
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
		
		self.gradientCreatorView.offsets = self.gradientOffsets
		self.gradientOffsets = []
		
		updateGradient()
		
		if self.swatchEditing != nil && UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			var offset = self.swatchEditing!.frame.origin.x + (self.swatchEditing!.bounds.size.width / 2.0) - (self.colorPickerView.bounds.size.width / 2.0)
			_colorPickerViewLeadingConstraint.constant = min(max(0,offset),(self.view.bounds.size.width - self.colorPickerView.bounds.size.width))
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
// MARK: Colors
	
	@IBAction func editSwatch(tap: UITapGestureRecognizer) {
		self.swatchEditing = (tap.view! as! SwatchThumbnail)
		self.colorPickerView.color = self.swatchEditing!.swatchView.backgroundColor!
		
		
		if NSUserDefaults.standardUserDefaults().objectForKey("hasVisitedTheColorPicker") == nil {
			
			let alertController = UIAlertController(title: "Custom Design Color Picker", message: "Drag to select a hue, saturation, and brightness value. Alternatively, tap the camera icon in the top right corner to match a color from a photo.", preferredStyle: .Alert)
			
			let cancelAction = UIAlertAction(title: "Got It!", style: .Cancel) { (action) in
				
			}
			alertController.addAction(cancelAction)
			
			self.presentViewController(alertController, animated: true) {
				NSUserDefaults.standardUserDefaults().setObject("yup", forKey: "hasVisitedTheColorPicker")
				NSUserDefaults.standardUserDefaults().synchronize()
			}
			
		}
		
		
		var cameraButton = UIBarButtonItem(image: UIImage(named: "icon_camera"), style: .Plain, target: self, action: "cameraAction")
		cameraButton.tintColor = UIColor.lightGrayColor()
		self.parentViewController!.navigationItem.rightBarButtonItem = cameraButton
		
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			var offset = self.swatchEditing!.frame.origin.x + (self.swatchEditing!.bounds.size.width / 2.0) - (self.colorPickerView.bounds.size.width / 2.0)
			_colorPickerViewLeadingConstraint.constant = min(max(0,offset),(self.view.bounds.size.width - self.colorPickerView.bounds.size.width))
			_colorPickerViewBottomConstraint.constant = 50.0
			UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: nil, animations: {
				self.view.layoutIfNeeded()
				self.colorPickerView.alpha = 1.0
				}, completion: { finished in
					
			})
		} else {
			_colorPickerViewHidingTopConstraint.priority = 600
			UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: nil, animations: {
				self.view.layoutIfNeeded()
				}, completion: { finished in
					
			})
		}
	}
	
	@IBAction func chooseColorAction() {
		if self.swatchEditing == self.gradientCreatorView.startSwatchThumbnail {
			self.gradientCreatorView.startColor = self.colorPickerView.color
		} else {
			self.gradientCreatorView.endColor = self.colorPickerView.color
		}
		
		self.swatchEditing = nil
		
		var shareButton = UIBarButtonItem(image: UIImage(named: "icon_share"), style: .Plain, target: self, action: "shareAction")
		shareButton.tintColor = UIColor.lightGrayColor()
		self.parentViewController!.navigationItem.rightBarButtonItem = shareButton
		
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			_colorPickerViewBottomConstraint.constant = 0.0
			UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: nil, animations: {
				self.view.layoutIfNeeded()
				self.colorPickerView.alpha = 0.0
				}, completion: { finished in
					self.colorPickerView.image = nil
			})
		} else {
			_colorPickerViewHidingTopConstraint.priority = 800
			UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: nil, animations: {
				self.view.layoutIfNeeded()
				}, completion: { finished in
					self.colorPickerView.image = nil
			})
		}
	}
	
	
// MARK: Actions
	
	func shareAction() {
		UIGraphicsBeginImageContextWithOptions(self.mainImageView.bounds.size, false, 0.0)
		self.mainImageView.drawViewHierarchyInRect(self.mainImageView.bounds, afterScreenUpdates: false)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			alertController.modalPresentationStyle = .Popover
			var popPresenter = alertController.popoverPresentationController!;
			popPresenter.barButtonItem = self.parentViewController!.navigationItem.rightBarButtonItem;
			popPresenter.sourceRect = self.view.bounds
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
			
		}
		alertController.addAction(cancelAction)
		
		let saveAction = UIAlertAction(title: "Save Design", style: .Default) { (action) in
			let realm = RLMRealm.defaultRealm()
			
			realm.beginWriteTransaction()
			var design = Design.createInDefaultRealmWithObject([
				"finish": self.chairFinishToggle.selectedSegmentIndex
			])
			design.setColors(self.gradientColors!)
			design.setLocations(self.gradientOffsets)
			design.setImage(image)
			realm.commitWriteTransaction()
			
			let alertController = UIAlertController(title: "Saved", message: "Your custom design has been saved!", preferredStyle: .Alert)
			
			let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
				
			}
			alertController.addAction(cancelAction)
			
			self.presentViewController(alertController, animated: true) {
				
			}
			
		}
		alertController.addAction(saveAction)
		
		let quoteAction = UIAlertAction(title: "Get a Design Quote", style: .Default) { (action) in
			var mailPicker = MFMailComposeViewController()
			
			mailPicker.mailComposeDelegate = self
			mailPicker.setToRecipients([coalesseEmail])
			mailPicker.setSubject("<5 Custom Design Quote")
			mailPicker.addAttachmentData(UIImageJPEGRepresentation(image, 0.8), mimeType: "image/jpeg", fileName: "design.jpg")
			
			let finish = self.chairFinishToggle.titleForSegmentAtIndex(self.chairFinishToggle.selectedSegmentIndex)
			let startColor = self.gradientColors![0].hexString
			let endColor = self.gradientColors![1].hexString
			mailPicker.setMessageBody("Name:\nPhone:\n\nChair Finish: \(finish!)\nColors: \(startColor!) \(endColor!)", isHTML: false)
			
			self.presentViewController(mailPicker, animated: true, completion: nil)
		}
		alertController.addAction(quoteAction)
		
		let shareAction = UIAlertAction(title: "Share Design", style: .Default) { (action) in
			let text = "Custom Coalesse <5 Chair"
			let website = NSURL(string: "http://www.coalesse.com/")!
			
			let activityVC = UIActivityViewController(activityItems: [image,text,website], applicationActivities: nil)
			if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
				activityVC.modalPresentationStyle = .Popover
				var popPresenter = activityVC.popoverPresentationController!;
				popPresenter.barButtonItem = self.parentViewController!.navigationItem.rightBarButtonItem;
				popPresenter.sourceRect = self.view.bounds
			}
			
			activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact]
			
			self.presentViewController(activityVC, animated: true, completion: nil)
		}
		alertController.addAction(shareAction)
		
		self.presentViewController(alertController, animated: true) {
			
		}
	}
	
	
// MARK: Color Match
	
	func cameraAction() {
		let alertController = UIAlertController(title: "Color Match", message: "Match a color from a photo.", preferredStyle: .Alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
			
		}
		alertController.addAction(cancelAction)
		
		let photoAction = UIAlertAction(title: "Choose Photo", style: .Default) { (action) in
			self.imagePicker.allowsEditing = false
			self.imagePicker.sourceType = .PhotoLibrary
			self.presentViewController(self.imagePicker, animated: true, completion: nil)
		}
		alertController.addAction(photoAction)
		
		if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
			let cameraAction = UIAlertAction(title: "Take a Photo", style: .Default) { (action) in
				self.imagePicker.allowsEditing = false
				self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
				self.imagePicker.cameraCaptureMode = .Photo
				self.presentViewController(self.imagePicker, animated: true, completion: nil)
			}
			alertController.addAction(cameraAction)
		}
		
		self.presentViewController(alertController, animated: true) {
			
		}
	}
	
	func hueWheelAction() {
		self.colorPickerView.image = nil
		
		var cameraButton = UIBarButtonItem(image: UIImage(named: "icon_camera"), style: .Plain, target: self, action: "cameraAction")
		cameraButton.tintColor = UIColor.lightGrayColor()
		self.parentViewController!.navigationItem.rightBarButtonItem = cameraButton
	}
	
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		var image = info[UIImagePickerControllerOriginalImage] as! UIImage
		self.colorPickerView.image = image
		
		var hueWheelButton = UIButton(frame: CGRectMake(0,0,26,26))
		hueWheelButton.setImage(UIImage(named: "icon_color_hue_wheel"), forState: .Normal)
		hueWheelButton.addTarget(self, action: "hueWheelAction", forControlEvents: .TouchUpInside)
		var hueWheelBarButton = UIBarButtonItem(customView: hueWheelButton)
		self.parentViewController!.navigationItem.rightBarButtonItem = hueWheelBarButton
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
// MARK: Images
	
	@IBAction func didChangeChairFinish() {
		gradientOffsets = []
		updateGradient()
	}
	
	func updateGradient() {
		if self.gradientCreatorView.colors != gradientColors! || self.gradientCreatorView.offsets != gradientOffsets {
			gradientColors = self.gradientCreatorView.colors
			gradientOffsets = self.gradientCreatorView.offsets
			
			
			if self.swatchEditing != nil && UIDevice.currentDevice().userInterfaceIdiom == .Pad {
				self.swatchEditing = nil
				
				_colorPickerViewBottomConstraint.constant = 0.0
				UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: nil, animations: {
					self.view.layoutIfNeeded()
					self.colorPickerView.alpha = 0.0
					}, completion: { finished in
						self.colorPickerView.image = nil
				})
			}
			
			
			UIGraphicsBeginImageContextWithOptions(mainImageView.bounds.size, false, 0.0)
			let context = UIGraphicsGetCurrentContext()
			let locations = [CGFloat(gradientOffsets[0]),CGFloat(gradientOffsets[1])]
			let colors = [gradientColors![0].CGColor!,gradientColors![1].CGColor!]
			let colorspace = CGColorSpaceCreateDeviceRGB()
			let gradient = CGGradientCreateWithColors(colorspace, colors, locations)
			let startPoint = CGPointMake(0, 0)
			let endPoint = CGPointMake(0,mainImageView.bounds.size.height)
			CGContextDrawLinearGradient(context, gradient,startPoint, endPoint, 0);
			let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext();
			
			
			gpuGradient = GPUImagePicture(image: gradientImage)
			let finish = ( self.chairFinishToggle.selectedSegmentIndex == 0 ? "gloss" : "matte")
			gpuChair = GPUImagePicture(image: UIImage(named: "chair_custom_\(finish)"))
			gpuChairMask = GPUImagePicture(image: UIImage(named: "chair_custom_mask"))
			
			let maskFilter = GPUImageMaskFilter()
			let blendFilter = GPUImageOverlayBlendFilter()
			
			gpuChair!.addTarget(blendFilter)
			gpuGradient!.addTarget(blendFilter)
			
			blendFilter.addTarget(maskFilter)
			gpuChairMask!.addTarget(maskFilter)
			
			maskFilter.addTarget(self.mainImageView)
			
			
			gpuChair!.processImage()
			gpuGradient!.processImage()
			gpuChairMask!.processImage()
		}
	}
}


class SaveDesign: UIActivity {
	var designImage: UIImage?
	var designDict: [String:AnyObject]?
	
	override func activityType() -> String? {
		return "com.coalesse.Coalesse.SaveDesign"
	}
	
	override func activityTitle() -> String? {
		return "Save Design"
	}
	
	override func activityImage() -> UIImage? {
		return UIImage(named: "icon_standard")
	}
	
	override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
		return true
	}
	
	override func prepareWithActivityItems(activityItems: [AnyObject]) {
		for item in activityItems {
			if let dict = item as? [String:AnyObject] {
				self.designDict = dict
			} else if let image = item as? UIImage {
				self.designImage = image
			}
		}
	}
	
	override func performActivity() {
		let realm = RLMRealm.defaultRealm()
		
		realm.beginWriteTransaction()
		var design = Design.createInDefaultRealmWithObject([
			"finish": self.designDict!["finish"] as! Int
			])
		design.setColors(self.designDict!["colors"] as! [UIColor])
		design.setLocations(self.designDict!["locations"] as! [Float])
		design.setImage(self.designImage!)
		realm.commitWriteTransaction()
	}
}