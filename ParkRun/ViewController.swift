//
//  ViewController.swift
//  ParkRun
//
//  Created by Charlie on 16/2/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit



//	17	1	10011100110
//	18	2	11001110010
//	19	3	11001011100
//	20	4	11001001110
//	21	5	11011100100
//	22	6	11001110100
//	23	7	11101101110
//	24	8	11101001100
//	25	9	11100101100

class ViewController: UIViewController {

	let imageView = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.blue
		imageView.backgroundColor = UIColor.green
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(imageView)
		
		self.view.addConstraints([
		
			// Image View
			NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 0.6, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
		
		])
		
//		if let coreImage = barcodeGenerator.generateImage(imageWidth: Int(UIScreen.main.bounds.width), imageHeight: Int(UIScreen.main.bounds.width * 0.6)) {
//			imageView.image = UIImage(cgImage: coreImage)
//		} else {
//			print("Fail here")
//		}
		
		
		
		
//		imageFromARGB32Bitmap(pixels: barcodeArray(memberNumber: "A5470914", barcodeSize: BarcodeSize(width: 500, height: 300)), width: 500, height: 300)

	}
	
}

