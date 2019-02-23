
let mainRow: Array<Int> = [Int](repeating: 1, count: 3) + [Int](repeating: 2, count: 3)
print(mainRow)

////: Playground - noun: a place where people can play
//
//import Foundation
//import CoreGraphics
//import UIKit
//
//struct PixelData {
//    var a: UInt8
//    var r: UInt8
//    var g: UInt8
//    var b: UInt8
//}
//
//struct BarcodeSize {
//
//	var width: Int
//	var height: Int
//
//}
//
//struct InsetSpace {
//
//	var top: Int
//	var bottom: Int
//	var left: Int
//	var right: Int
//
//	init(valueWidth: Int, valueCount: Int, barcodeSize: BarcodeSize) {
//
//		let moduloValue = barcodeSize.width % valueCount
//
//		self.top = valueWidth * 11
//		self.bottom = barcodeSize.height - (valueWidth * 11)
//		
//		if moduloValue == 0 {
//
//			self.left = valueWidth * 11
//			self.right = valueWidth * 11
//
//		} else if moduloValue % 2 == 0 {
//
//			self.left = (valueWidth * 11) + (moduloValue / 2)
//			self.right = (valueWidth * 11) + (moduloValue / 2)
//
//		} else {
//
//			let floorValue = Int(floor(Float(moduloValue) / 2.0))
//
//			self.left = (valueWidth * 11) + floorValue + 1
//			self.right = (valueWidth * 11) + floorValue + 1
//
//		}
//
//	}
//
//}
//
//func barcodeArray(memberNumber: String, barcodeSize: BarcodeSize) -> Array<PixelData> {
//
//	var finalArray = Array<PixelData>()
//	var memberData = Array(memberNumber)
//	let valueCount = (memberData.count * 11) + (4 * 11) + (1 * 13)
//	let valueWidth = Int(floor(Float(barcodeSize.width) / Float(valueCount)))
//	let insetSpace = InsetSpace(valueWidth: valueWidth, valueCount: valueCount, barcodeSize: barcodeSize)
//
//	for eachRow in 0 ..< barcodeSize.height {
//
//		if eachRow <= insetSpace.top || eachRow >= insetSpace.bottom {
//			finalArray += [PixelData](repeating: PixelData(a: 255, r: 255, g: 0, b: 0), count: barcodeSize.width)
//		} else {
//			finalArray += [PixelData](repeating: PixelData(a: 255, r: 255, g: 255, b: 255), count: barcodeSize.width)
//		}
//
//	}
//
//	return finalArray
//
//}
//
//
//func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
//    guard width > 0 && height > 0 else { return nil }
//    guard pixels.count == width * height else { return nil }
//
//    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
//    let bitsPerComponent = 8
//    let bitsPerPixel = 32
//
//    var data = pixels // Copy to mutable []
//    guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
//                            length: data.count * MemoryLayout<PixelData>.size)
//        )
//        else { return nil }
//
//    guard let cgim = CGImage(
//        width: width,
//        height: height,
//        bitsPerComponent: bitsPerComponent,
//        bitsPerPixel: bitsPerPixel,
//        bytesPerRow: width * MemoryLayout<PixelData>.size,
//        space: rgbColorSpace,
//        bitmapInfo: bitmapInfo,
//        provider: providerRef,
//        decode: nil,
//        shouldInterpolate: true,
//        intent: .defaultIntent
//        )
//        else { return nil }
//
//    return UIImage(cgImage: cgim)
//}
//
//
//let thing = imageFromARGB32Bitmap(pixels: barcodeArray(memberNumber: "ABCDEFG", barcodeSize: BarcodeSize(width: 500, height: 300)), width: 500, height: 300)
//
