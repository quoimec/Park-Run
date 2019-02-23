//
//  InterfaceController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 16/2/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import WatchKit
import Foundation
import CoreGraphics
import UIKit

class InterfaceController: WKInterfaceController {

	@IBOutlet weak var barcodeImage: WKInterfaceImage!
	
	let barcodeGenerator = GenerateBarcode(barcodeString: "A5470914")
	var barcodeRotation: GenerateBarcode.BarcodeRotation = .Default
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		print("HELLO WORLD")
		
		if let generatedImage = barcodeGenerator.generateImage(imageWidth: 460, imageHeight: 460, barcodeRotation: barcodeRotation) {
			
			barcodeImage.setImage(generatedImage)
			
		} else {
			print("FAILED")
		}
		
		self.presentTextInputController(withSuggestions: ["A9143124"], allowedInputMode: .plain, completion: { textResult in
			
			print(textResult)
		
		})

//		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
//
//			self.presentTextInputController(withSuggestions: ["A9143124"], allowedInputMode: .plain, completion: { textResult in
//
//				print(textResult)
//
//			})
//
//		})
		
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
    @IBAction func barcodeTapped(_ sender: Any) {
	
		barcodeRotation = barcodeRotation == .Default ? .Rotated : .Default
		
		if let generatedImage = barcodeGenerator.generateImage(imageWidth: 460, imageHeight: 460, barcodeRotation: barcodeRotation) {
			barcodeImage.setImage(generatedImage)
		} else {
			print("FAILED")
		}
	
	}

}
