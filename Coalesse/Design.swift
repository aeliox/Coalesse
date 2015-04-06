//
//  Design.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 4/5/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import Realm

class Design: RLMObject {
	dynamic var colorsData: NSData = NSData()
	dynamic var locationsData: NSData = NSData()
	dynamic var finish = 0
	dynamic var imageData: NSData = NSData()
	
	func colors() -> [UIColor] {
		return (NSKeyedUnarchiver.unarchiveObjectWithData(self.colorsData) as [UIColor])
	}
	
	func setColors(colors: [UIColor]) {
		self.colorsData = NSKeyedArchiver.archivedDataWithRootObject(colors)
	}
	
	
	func locations() -> [Float] {
		return (NSKeyedUnarchiver.unarchiveObjectWithData(self.locationsData) as [Float])
	}
	
	func setLocations(locations: [Float]) {
		self.locationsData = NSKeyedArchiver.archivedDataWithRootObject(locations)
	}
	
	
	func image() -> UIImage {
		return (NSKeyedUnarchiver.unarchiveObjectWithData(self.imageData) as UIImage)
	}
	
	func setImage(image: UIImage) {
		self.imageData = NSKeyedArchiver.archivedDataWithRootObject(image)
	}
}