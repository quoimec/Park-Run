//
//  BarcodeViews.swift
//  Park Run WatchKit Extension
//
//  Created by Charlie on 2/9/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import SwiftUI

struct Barcode {

	func generateImage(number: String, width: Int) -> CGImage? {
	
		let pixelArray = generatePixels(number: number, width: width)
		let imageSize = Int(Double(pixelArray.count).squareRoot())

		var pixelData = pixelArray
		
		guard let pixelProvider = CGDataProvider(data: NSData(bytes: &pixelData, length: pixelData.count * MemoryLayout<BarcodePixel>.size)) else { return nil }

		guard let coreImage = CGImage(width: imageSize, height: imageSize, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: imageSize * MemoryLayout<BarcodePixel>.size, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue), provider: pixelProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { return nil }
		
		return coreImage

	}
	
	private func generatePixels(number: String, width: Int) -> Array<BarcodePixel> {

		var pixelArray = Array<BarcodePixel>()
		let memberData = Array(number).map({ String($0) })
		
		// 	LinesCount -> Charachter count + start code & check sum + stop code
		let linesCount = (memberData.count * 11) + (2 * 11) + (1 * 13)
		let linesWidth = Int(ceil(Float(width) / Float(linesCount)))
	
		let mainRow: Array<BarcodePixel> = codeBarcode(passedCharachter: BarcodeControl.Start.rawValue, valueWidth: linesWidth) + memberData.map({ codeBarcode(passedCharachter: $0, valueWidth: linesWidth) }).reduce([], { $0 + $1 }) + codeBarcode(passedCharachter: BarcodeControl.Stop.rawValue, valueWidth: linesWidth)

		for _ in 0 ..< mainRow.count { pixelArray += mainRow }
		
		return pixelArray

	}
	
	private func codeBarcode(passedCharachter: String, valueWidth: Int) -> Array<BarcodePixel> {
	
		switch passedCharachter {
		
			case BarcodeControl.Start.rawValue:
			return encodeString(passedString: "11010010000", valueWidth: valueWidth, barcodeControl: BarcodeControl.Start)
			
			case BarcodeControl.Stop.rawValue:
			return encodeString(passedString: "1100011101011", valueWidth: valueWidth, barcodeControl: BarcodeControl.Stop)
		
			case "0":
			return encodeString(passedString: "10011101100", valueWidth: valueWidth)
			
			case "1":
			return encodeString(passedString: "10011100110", valueWidth: valueWidth)
			
			case "2":
			return encodeString(passedString: "11001110010", valueWidth: valueWidth)
			
			case "3":
			return encodeString(passedString: "11001011100", valueWidth: valueWidth)
			
			case "4":
			return encodeString(passedString: "11001001110", valueWidth: valueWidth)
			
			case "5":
			return encodeString(passedString: "11011100100", valueWidth: valueWidth)
			
			case "6":
			return encodeString(passedString: "11001110100", valueWidth: valueWidth)
			
			case "7":
			return encodeString(passedString: "11101101110", valueWidth: valueWidth)
			
			case "8":
			return encodeString(passedString: "11101001100", valueWidth: valueWidth)
			
			case "9":
			return encodeString(passedString: "11100101100", valueWidth: valueWidth)
			
			case "A":
			return encodeString(passedString: "10100011000", valueWidth: valueWidth)
			
			default:
			return encodeString(passedString: "00000000000", valueWidth: valueWidth)
		
		}
	
	}
	
	private func encodeString(passedString: String, valueWidth: Int, barcodeControl: BarcodeControl? = nil) -> Array<BarcodePixel> {
	
		var additionalData = Array<BarcodePixel>()
		var checkSum = CheckSum()
	
		if let safeControl = barcodeControl {
		
			if safeControl == .Start {
				checkSum.resetData(startCode: passedString)
			} else if safeControl == .Stop {
				additionalData = Array(checkSum.calculateSum()).map({ [BarcodePixel](repeating: BarcodePixel(binaryValue: $0), count: valueWidth) }).reduce([], { $0 + $1 })
			}
		
		} else {
			checkSum.addValue(valueCode: passedString)
		}
	
		return additionalData + Array(passedString).map({ [BarcodePixel](repeating: BarcodePixel(binaryValue: $0), count: valueWidth) }).reduce([], { $0 + $1 })
		
	}
	
	private struct CheckSum {

		private var startValue: Int = 0
		private var runningValue = Array<Int>()
		
		mutating func resetData(startCode: String) {
			self.startValue = lookupArray.firstIndex(of: startCode)!
			self.runningValue = Array<Int>()
		}
		
		mutating func addValue(valueCode: String) {
			self.runningValue.append(lookupArray.firstIndex(of: valueCode)!)
		}
		
		func calculateSum() -> String {
			
			print("Running values: \(self.runningValue)")
			print("Scaled values: \(self.runningValue.enumerated().map({ (($0 + 1) * $1) }))")
			print("Startcode value: \(self.startValue)")
			
//			print("Calculated Checksum: \((self.runningValue.enumerated().map({ (($0 + 1) * $1) }).reduce(0, { $0 + $1 }) + startValue) % 103)")
		
			return lookupArray[(self.runningValue.enumerated().map({ (($0 + 1) * $1) }).reduce(0, { $0 + $1 }) + startValue) % 103]
		}

		private let lookupArray: Array<String> = [
		
			"11011001100",
			"11001101100",
			"11001100110",
			"10010011000",
			"10010001100",
			"10001001100",
			"10011001000",
			"10011000100",
			"10001100100",
			"11001001000",
			"11001000100",
			"11000100100",
			"10110011100",
			"10011011100",
			"10011001110",
			"10111001100",
			"10011101100",
			"10011100110",
			"11001110010",
			"11001011100",
			"11001001110",
			"11011100100",
			"11001110100",
			"11101101110",
			"11101001100",
			"11100101100",
			"11100100110",
			"11101100100",
			"11100110100",
			"11100110010",
			"11011011000",
			"11011000110",
			"11000110110",
			"10100011000",
			"10001011000",
			"10001000110",
			"10110001000",
			"10001101000",
			"10001100010",
			"11010001000",
			"11000101000",
			"11000100010",
			"10110111000",
			"10110001110",
			"10001101110",
			"10111011000",
			"10111000110",
			"10001110110",
			"11101110110",
			"11010001110",
			"11000101110",
			"11011101000",
			"11011100010",
			"11011101110",
			"11101011000",
			"11101000110",
			"11100010110",
			"11101101000",
			"11101100010",
			"11100011010",
			"11101111010",
			"11001000010",
			"11110001010",
			"10100110000",
			"10100001100",
			"10010110000",
			"10010000110",
			"10000101100",
			"10000100110",
			"10110010000",
			"10110000100",
			"10011010000",
			"10011000010",
			"10000110100",
			"10000110010",
			"11000010010",
			"11001010000",
			"11110111010",
			"11000010100",
			"10001111010",
			"10100111100",
			"10010111100",
			"10010011110",
			"10111100100",
			"10011110100",
			"10011110010",
			"11110100100",
			"11110010100",
			"11110010010",
			"11011011110",
			"11011110110",
			"11110110110",
			"10101111000",
			"10100011110",
			"10001011110",
			"10111101000",
			"10111100010",
			"11110101000",
			"11110100010",
			"10111011110",
			"10111101110",
			"11101011110",
			"11110101110",
			"11010000100",
			"11010010000",
			"11010011100",
			"11000111010"
		
		]

	}

}

