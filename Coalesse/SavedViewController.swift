//
//  SavedViewController.swift
//  Coalesse
//
//  Created by Keiran Flanigan on 3/26/15.
//  Copyright (c) 2015 ragedigital. All rights reserved.
//

import Foundation
import UIKit
import Realm

class SavedViewController: UICollectionViewController, UIActionSheetDelegate {
	var designs: RLMResults?
	var rowToDelete: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshData()
	}
	
	override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		
		if self.parentViewController != nil {
			self.parentViewController!.navigationItem.titleView = nil
			self.parentViewController!.navigationItem.title = "Saved Designs"
			
			self.parentViewController!.navigationItem.rightBarButtonItem = nil
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

// MARK: Nav
	
	@IBAction func showCustomizer() {
		NSNotificationCenter.defaultCenter().postNotificationName("DidSelectMenuNav", object: "customize")
	}
	
	
// MARK: Data
	
	func refreshData() {
		self.designs = Design.allObjects()
	}
	
	
// MARK: Collection View
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Int(self.designs!.count)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let width = collectionView.bounds.size.width / 2.0 - 0.5
		return CGSizeMake(width,width)
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SavedDesignCell", forIndexPath: indexPath) as SavedDesignCell
		
		cell.design = (self.designs!.objectAtIndex(UInt(indexPath.row)) as Design)
		cell.alpha = 1.0
		
		if rowToDelete > -1 {
			if indexPath.row != rowToDelete {
				cell.alpha = 0.2
			}
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		if self.designs!.count == 0 {
			return collectionView.bounds.size
		} else {
			return CGSizeZero
		}
	}
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let footer: UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "EmptyFooter", forIndexPath: indexPath) as UICollectionReusableView
		return footer
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let design = (self.designs!.objectAtIndex(UInt(indexPath.row)) as Design)
		
		(self.parentViewController! as MainViewController).showSavedDesign(design)
	}
	
	@IBAction func didLongPress(gesture: UILongPressGestureRecognizer) {
		if gesture.state == .Began {
			let touch = gesture.locationInView(gesture.view!)
			
			if let indexPath = collectionView!.indexPathForItemAtPoint(touch) {
				let cell = self.collectionView!.cellForItemAtIndexPath(indexPath)!
				rowToDelete = indexPath.row
				collectionView!.reloadData()
				
				
				let alertController = UIAlertController(title: nil, message: "Do you want to delete this saved design?", preferredStyle: .ActionSheet)
				if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
					alertController.modalPresentationStyle = .Popover
					var popPresenter = alertController.popoverPresentationController!;
					
					popPresenter.sourceView = cell
					popPresenter.sourceRect = cell.bounds
				}
				
				let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
					self.rowToDelete = -1
					self.collectionView!.reloadData()
				}
				alertController.addAction(cancelAction)
				
				let destroyAction = UIAlertAction(title: "Delete Design", style: .Destructive) { (action) in
					let indexPath = NSIndexPath(forItem: self.rowToDelete!, inSection: 0)
					self.rowToDelete = -1
					
					let design = self.designs!.objectAtIndex(UInt(indexPath.item)) as Design
					let realm = RLMRealm.defaultRealm()
					realm.beginWriteTransaction()
					realm.deleteObject(design)
					realm.commitWriteTransaction()
					
					self.collectionView!.performBatchUpdates({
						
						self.collectionView!.deleteItemsAtIndexPaths([indexPath])
						self.refreshData()
						
						}, completion: { finished in
							self.collectionView!.reloadData()
					})
				}
				alertController.addAction(destroyAction)
				
				self.presentViewController(alertController, animated: true) {
					
				}
			}
		}
	}
}