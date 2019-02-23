//
//  GenerateBarcode.swift
//  ParkRun
//
//  Created by Charlie on 20/2/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class GenerateBarcode {

	var barcodeString: String
	private var checkSum: CheckSum

	init(barcodeString: String) {
	
		self.barcodeString = barcodeString
		self.checkSum = CheckSum()
		
	}
	
	func generateImage(imageWidth: Int, imageHeight: Int, barcodeRotation: BarcodeRotation) -> UIImage? {
	
		guard imageWidth > 0 && imageHeight > 0 else { return nil }
		
		let pixelArray = generatePixels(imageWidth: imageWidth, imageHeight: imageHeight, barcodeRotation: barcodeRotation)
		
		guard pixelArray.count == imageWidth * imageHeight else { return nil }

		var pixelData = pixelArray
		
		guard let pixelProvider = CGDataProvider(data: NSData(bytes: &pixelData, length: pixelData.count * MemoryLayout<PixelData>.size)) else { return nil }

		guard let coreImage = CGImage(width: imageWidth, height: imageHeight, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: imageWidth * MemoryLayout<PixelData>.size, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue), provider: pixelProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { return nil }
		
		return UIImage(cgImage: coreImage)

	}
	
	private func generatePixels(imageWidth: Int, imageHeight: Int, barcodeRotation: BarcodeRotation) -> Array<PixelData> {

		var pixelArray = Array<PixelData>()
		let memberData = Array(self.barcodeString).map({ String($0) })
		
		// 	linesCount = Charachter count + start code & check sum + stop code + 2 insets
		let insetScale = 11
		let linesCount = (memberData.count * 11) + (2 * 11) + (1 * 13) + (2 * insetScale)
		let linesWidth = Int(floor(Float(imageWidth) / Float(linesCount)))
	
		let moduloValue = imageWidth % linesCount
		let topInset = linesWidth * 11
		let bottomInset = imageHeight - (linesWidth * 11)
		let leftInset = linesWidth * insetScale
		let rightInset = linesWidth * insetScale
		var leftBlack: Int
		var rightBlack: Int
		
		if moduloValue % 2 == 0 {
			
			leftBlack = moduloValue / 2
			rightBlack = moduloValue / 2

		} else {
		
			let floorValue = Int(floor(Float(moduloValue) / 2.0))
			
			leftBlack = floorValue + 1
			rightBlack = floorValue
			
		}
	
		let insetRow: Array<PixelData> = [PixelData](repeating: PixelData(binaryValue: "0"), count: leftBlack) + [PixelData](repeating: PixelData(binaryValue: "0"), count: (imageWidth - leftBlack - rightBlack)) + [PixelData](repeating: PixelData(binaryValue: "0"), count: rightBlack)
		let barcodeSection = codeBarcode(passedCharachter: BarcodeControl.Start.rawValue, valueWidth: linesWidth) + memberData.map({ codeBarcode(passedCharachter: $0, valueWidth: linesWidth) }).reduce([], { $0 + $1 }) + codeBarcode(passedCharachter: BarcodeControl.Stop.rawValue, valueWidth: linesWidth)
		let mainRow: Array<PixelData> = [PixelData](repeating: PixelData(binaryValue: "0"), count: leftBlack) + [PixelData](repeating: PixelData(binaryValue: "0"), count: leftInset) + barcodeSection + [PixelData](repeating: PixelData(binaryValue: "0"), count: rightInset) + [PixelData](repeating: PixelData(binaryValue: "0"), count: rightBlack)
		
		if barcodeRotation == .Default {
		
			for eachRow in 0 ..< imageHeight {

				if eachRow <= topInset || eachRow >= bottomInset {
					pixelArray += insetRow
				} else {
					pixelArray += mainRow
				}

			}
		
		} else if barcodeRotation == .Rotated {
		
			for eachRow in 0 ..< imageHeight {
			
				if eachRow <= topInset || eachRow >= bottomInset {
					pixelArray += insetRow
				} else {
				
					let centralSection = [PixelData](repeating: mainRow[eachRow], count: imageWidth - (leftBlack + leftInset + rightInset + rightBlack))
				
					pixelArray += [PixelData](repeating: PixelData(binaryValue: "0"), count: leftBlack) + [PixelData](repeating: PixelData(binaryValue: "0"), count: leftInset) + centralSection + [PixelData](repeating: PixelData(binaryValue: "0"), count: rightInset) + [PixelData](repeating: PixelData(binaryValue: "0"), count: rightBlack)
				}
			
			}
		
		}
		
		return pixelArray

	}
	
	private func codeBarcode(passedCharachter: String, valueWidth: Int) -> Array<PixelData> {
	
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
	
	private func encodeString(passedString: String, valueWidth: Int, barcodeControl: BarcodeControl? = nil) -> Array<PixelData> {
	
		var additionalData = Array<PixelData>()
	
		if let safeControl = barcodeControl {
		
			if safeControl == .Start {
				self.checkSum.resetData(startCode: passedString)
			} else if safeControl == .Stop {
				additionalData = Array(self.checkSum.calculateSum()).map({ [PixelData](repeating: PixelData(binaryValue: $0), count: valueWidth) }).reduce([], { $0 + $1 })
			}
		
		} else {
			self.checkSum.addValue(valueCode: passedString)
		}
	
		return additionalData + Array(passedString).map({ [PixelData](repeating: PixelData(binaryValue: $0), count: valueWidth) }).reduce([], { $0 + $1 })
		
	}
	
	
	
	// Data Structures
	
	enum BarcodeControl: String {
		case Start, Stop
	}
	
	enum BarcodeRotation {
		case Default, Rotated
	}
	
	private struct PixelData {

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
			
			print("Calculated Checksum: \((self.runningValue.enumerated().map({ (($0 + 1) * $1) }).reduce(0, { $0 + $1 }) + startValue) % 103)")
		
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
