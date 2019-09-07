//
//  BarcodeModels.swift
//  Park Run WatchKit Extension
//
//  Created by Charlie on 2/9/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation

enum BarcodeControl: String {
	case Start, Stop
}

enum BarcodeRotation {
	case Default, Rotated
}

struct BarcodePixel {

	var a: UInt8
	var r: UInt8
	var g: UInt8
	var b: UInt8
	
	init(binaryValue: Character) {
	
		if binaryValue == "0" {
		
			self.a = 255
			self.r = 255
			self.g = 255
			self.b = 255
			
		} else {
		
			self.a = 255
			self.r = 0
			self.g = 0
			self.b = 0
			
		}
	
	}
	
	init(a: UInt8, r: UInt8, g: UInt8, b: UInt8) {
	
		self.a = a
		self.r = r
		self.g = g
		self.b = b
		
	}
	
}
