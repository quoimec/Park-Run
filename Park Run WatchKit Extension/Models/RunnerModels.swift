//
//  RunnerModels.swift
//  Park Run WatchKit Extension
//
//  Created by Charlie on 3/9/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class RunnerManager: ObservableObject  {

	let objectWillChange = ObservableObjectPublisher()

	var runnerData: Array<Runner> = [] {
		willSet { self.objectWillChange.send() }
	}
	
	private let runnerKey: String = "RunnerList"
	
	private let managerEncoder = JSONEncoder()
	private let managerDecoder = JSONDecoder()
	
	var RunnerPublisher = PassthroughSubject<String, Never>()
	
	func addRunner(runner: Runner) {
	
		DispatchQueue.main.async(execute: { [weak self] in
		
			guard let safe = self else { return }
			
			if safe.checkRunners(number: runner.number, runners: safe.runnerData) { return }
			
			safe.runnerData.append(runner)
			safe.saveRunners(runners: safe.runnerData)
		
		})
	
	}

	private func getRunners() -> Array<Runner> {
	
		guard let savedData = UserDefaults.standard.value(forKey: runnerKey) as? Data, let savedRunners = try? managerDecoder.decode(Array<Runner>.self, from: savedData) else {
			
			print("Unabled to decode list")
			saveRunners(runners: [])
			return []
		}
		
		return savedRunners
	
	}
	
	func updateRunners() {
	
		DispatchQueue.main.async(execute: { [weak self] in
			guard let safe = self else { return }
			safe.runnerData = safe.getRunners()
		})
	
	}
	
	private func saveRunners(runners: Array<Runner>) {
	
		guard let encoded = try? managerEncoder.encode(runners) else {
			print("Unable to encode runner data")
			return
		}
		
		UserDefaults.standard.setValue(encoded, forKey: runnerKey)
		
	}
	
	private func checkRunners(number: String, runners: Array<Runner>) -> Bool {
	
		for runner in runners { if runner.number == number { return true } }
		
		return false
	
	}

}

struct Runner: Codable, Identifiable {

	var id: String
	var name: String
	var number: String
	
	init(name: String, number: String) {
		self.name = name
		self.number = number
		self.id = number
	}

}

enum MetricType: String {
	case Time, Pace, Position, Grade
}
