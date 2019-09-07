//
//  ListViews.swift
//  Park Run WatchKit Extension
//
//  Created by Charlie on 4/9/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import SwiftUI

struct ListView: View {
	
	@ObservedObject var manager: RunnerManager = RunnerManager()
	
	var body: some View {
		
		List(content: {

			ForEach(manager.runnerData, content: { runner in
				
				NavigationLink(destination: RunnerView(runner: runner)) {
					ListRowRunner(runner: runner)
				}
					.listRowBackground(Color(red: 0.16, green: 0.15, blue: 0.20).cornerRadius(24))

			})
			
			NavigationLink(destination: NumberView(manager: manager)) {
				ListRowAdd()
			}
				.listRowBackground(Color(red: 0.16, green: 0.15, blue: 0.20).cornerRadius(20).frame(width: 40, height: 40))
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
				.padding(.trailing, -8)
			
		})
			.onAppear(perform: { self.manager.updateRunners() })
		
	}
	
	
	
	
	
	
//
//
//
////			List(listData, rowContent: { row in
////
////				switch row.type {
////
////					case .RunnerRow:
////
////				}
////
////
////
////			})
////				.listStyle(CarouselListStyle())
////				.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
////
////			List(content: {
////
////
////
////			})
//
//
//
//
////		List(content: {
////
////			NavigationLink(destination: NumberView()) { ListRowAdd() }
////				.listRowBackground(
////					Color(red: 0.16, green: 0.15, blue: 0.20)
////						.cornerRadius(20)
////						.frame(width: 40, height: 40)
////				)
////				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
////				.padding(.trailing, -8)
////				.brightness(1.0)
////
////		})
////			.listStyle(CarouselListStyle())
////			.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
////			.onAppear(perform: {
////
////				guard let savedData = UserDefaults.standard.value(forKey: "RunnerList") as? Array<Runner> else {
////					self.runnerData = [Runner(name: "Charlie Schacher", number: "A62342"), Runner(name: "Ben Jon", number: "A252342")]
////					UserDefaults.standard.setValue(self.runnerData, forKey: "RunnerList")
////					return
////				}
////				self.runnerData = savedData
////
////			})
//
//	}

}

struct ListRowRunner: View {

	var runnerName: RunnerName
	
	private var runnerTop: CGFloat = 2.0
	private var runnerBottom: CGFloat = 4.0

	init(runner: Runner) {
		runnerName = RunnerName(runner: runner)
	}
	
	var body: some View {
	
		VStack(alignment: .leading, spacing: -3, content: {
			
			runnerName
				.padding(.horizontal, 10)
				.padding(.top, 14 + runnerTop)
				.padding(.bottom, 14 + runnerBottom)
		
		})
			.listRowBackground(
				Color(red: 0.16, green: 0.15, blue: 0.20)
					.cornerRadius(24)
					.padding(.top, runnerTop)
					.padding(.bottom, runnerBottom)
			)
			.listRowPlatterColor(Color(red: 0.00, green: 0.00, blue: 0.00))
		
	}

}

struct ListRowAdd: View {
	
	private var runnerTop: CGFloat = 2.0
	private var runnerBottom: CGFloat = 4.0

	var body: some View {
	
		HStack(alignment: .center, spacing: 0, content: {
					
			Image("AddIcon")
				.resizable()
				.frame(width: 40, height: 40)
		
		})
			.padding(.vertical, 14)
			.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
		
	}

}

