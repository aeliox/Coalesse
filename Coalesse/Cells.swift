//
//  Cells.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 4/5/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit

class SavedDesignCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	
	var design: Design? = nil {
		didSet {
			if self.design != nil {
				
				imageView.image = self.design!.image()
				
			} else {
				imageView.image = nil
			}
		}
	}
	
	override func prepareForReuse() {
		imageView.image = nil
	}
}