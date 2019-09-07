//
//  RunnerViews.swift
//  Park Run WatchKit Extension
//
//  Created by Charlie on 2/9/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import SwiftUI
import WatchKit

struct RunnerName: View {

	var name: Text
	var number: Text

	init(runner: Runner) {
		name = Text(runner.name)
		number = Text(runner.number)
	}
	
	var body: some View {
	
		VStack(alignment: .leading, spacing: 1, content: {
		
			name
				.font(Font.system(size: 16, weight: .heavy))
				.foregroundColor(Color(red: 1.00, green: 1.00, blue: 1.00))
			
			number
				.font(Font.custom("SourceCodePro-Bold", size: 12))
				.foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.50))
		
		})
		
	}

}

struct RunnerView: View {

	let runnerData: Runner
	let barcodeGenerator = Barcode()
	let barcodeWidth = Int(WKInterfaceDevice.current().screenBounds.width)
	let barcodePadding = 22

	@State var rotation: Double = 0.0

	init(runner: Runner) {
		runnerData = runner
	}

	var body: some View {
	
		ScrollView(.vertical, showsIndicators: true, content: {
			
			ZStack(alignment: .center, content: {
			
				Color(red: 0.16, green: 0.15, blue: 0.20)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
					.cornerRadius(24)
			
				VStack(alignment: .leading, spacing: 0, content: {
				
					RunnerName(runner: runnerData)
						.padding(.horizontal, 19)
						.padding(.top, 16)
						.padding(.bottom, 10)
					
					Color(red: 0.28, green: 0.27, blue: 0.35)
						.frame(height: 2)
						.cornerRadius(1)
						.padding(.horizontal, 10)
					
					ZStack(alignment: .center, content: {
					
						Color(red: 1.00, green: 1.00, blue: 1.00)
							.cornerRadius(24)
					
						Image(decorative: barcodeGenerator.generateImage(number: runnerData.number, width: barcodeWidth - (2 * barcodePadding))!, scale: 1.0)
							.resizable()
							.padding(CGFloat(barcodePadding))
							.rotationEffect(Angle(degrees: rotation))
							
					})
						.frame(width: CGFloat(barcodeWidth), height: CGFloat(barcodeWidth), alignment: .center)
						.padding(.top, 24)
						.onTapGesture {
							self.rotation = self.rotation == 0.0 ? 90.0 : 0.0
						}
						
				})
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
			
			})
			
		})
			.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
		
			

//
//
//					VStack(alignment: .leading, spacing: 6, content: {
//
//						Text("Recent")
//							.foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.50))
//							.font(Font.system(size: 10, weight: .semibold))
//
//						HStack(alignment: .top, spacing: 0, content: {
//							UserMetric(type: .Time)
//							UserMetric(type: .Pace)
//						})
//							.frame(minWidth: 0, maxWidth: .infinity)
//
//						HStack(alignment: .top, spacing: 0, content: {
//							UserMetric(type: .Grade)
//							UserMetric(type: .Position)
//						})
//							.frame(minWidth: 0, maxWidth: .infinity)
//							.padding(.top, 6)
//
//					})
//						.padding(.top, 8)
//						.padding(.horizontal, 1)
//
//					VStack(alignment: .leading, spacing: 8, content: {
//
//						Text("Barcode")
//							.foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.50))
//							.font(Font.system(size: 10, weight: .semibold))
//
//						BarcodeView(barcodeString: "A5470914")
//
//					})
//						.padding(.top, 20)
//						.padding(.bottom, 2)
						
//				})
				
//
//			})
//
//		})
	
	}


}

struct UserMetric: View {

	private var metricIcon: Image
	private var metricName: Text
	private var metricValue: Text
	private var metricColor: Color

	init(type: MetricType) {
	
		metricIcon = Image("\(type.rawValue)Icon")
		
		switch type {
			
			case .Time:
			metricName = Text("Time")
			metricValue = Text("21:48")
			metricColor = Color(red: 0.41, green: 0.90, blue: 0.83)
			
			case .Pace:
			metricName = Text("Pace")
			metricValue = Text("14.2 k/h")
			metricColor = Color(red: 0.72, green: 0.57, blue: 0.88)
			
			case .Position:
			metricName = Text("Position")
			metricValue = Text("17th")
			metricColor = Color(red: 0.98, green: 0.76, blue: 0.47)
			
			case .Grade:
			metricName = Text("Grade")
			metricValue = Text("62.91%")
			metricColor = Color(red: 0.87, green: 0.55, blue: 0.55)
			
			
		}
	
	}

	var body: some View {
	
		HStack(alignment: .center, spacing: 5, content: {
			
			self.metricIcon
				.resizable()
				.frame(width: 26, height: 26, alignment: .leading)
				
			VStack(alignment: .leading, spacing: -2, content: {
				
				self.metricName
					.foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.50))
					.font(Font.system(size: 10, weight: .medium))
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					
				self.metricValue
					.foregroundColor(metricColor)
					.font(Font.system(size: 14, weight: .bold))
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
			
			})
				.frame(minWidth: 0, maxWidth: .infinity)
			
		})
		
	}


}
