//
//  NumberViews.swift
//  Park Run WatchKit Extension
//
//  Created by Charlie on 4/9/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import SwiftUI
import Combine

enum ButtonType: Int {
	case zero = 0, one, two, three, four, five, six, seven, eight, nine, delete, confirm
}

struct NumberView: View {

	@State var number: String = "A"
	let buttonData: Array<Array<ButtonType>> = [
		[.one, .two, .three], [.four, .five, .six], [.seven, .eight, .nine], [.delete, .zero, .confirm]
	]
	
	var manager: RunnerManager
	
	var body: some View {
	
		VStack(alignment: .center, spacing: 0, content: {
		
			Text("\(number)")
				.frame(height: 30, alignment: .center)
				.foregroundColor(Color(red: 1.00, green: 1.00, blue: 1.00))
				.font(Font.system(size: 15, weight: .heavy, design: .rounded))

			ForEach(buttonData, id: \.self, content: { row in
			
				HStack(alignment: .center, spacing: 0, content: {
				
					ForEach(row, id: \.self, content: { button in
						NumberButton(type: button, manager: self.manager, number: self.$number)
					})
				
				})
			
			})
		
		})
			.padding(.bottom, 6)
			.padding(.horizontal, 2)
			.edgesIgnoringSafeArea(.bottom)
		
	}
	
}

struct NumberButton: View {

	private let duration: Double = 0.07
	
	@State var alpha: Double = 1.0
	@State var scale: CGFloat = 1.0
	@State var background: Color = Color(red: 0.16, green: 0.15, blue: 0.20)

	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	let type: ButtonType
	var manager: RunnerManager
	
	@Binding var number: String

	var body: some View {
	
		ZStack(alignment: .topLeading, content: {
		
			background
				.cornerRadius(10)
				
			if type.rawValue > 9 {
			
				Image(systemName: type == .confirm ? "checkmark.circle.fill" : "delete.left.fill")
					.font(Font.system(size: 15, weight: .black))
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
					.foregroundColor(type == .confirm ? Color(red: 0.56, green: 0.87, blue: 0.44) : Color(red: 0.95, green: 0.43, blue: 0.43))
					.opacity(alpha)
			
			} else {
			
				Text("\(type.rawValue)")
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
					.foregroundColor(Color(red: 1.00, green: 1.00, blue: 1.00))
					.font(Font.system(size: 22, weight: .heavy, design: .rounded))
					.opacity(alpha)
			
			}
				
		})
			.padding(.all, 3)
			.scaleEffect(scale)
			.onTapGesture(perform: {
			
				if self.type.rawValue <= 9 {
					self.number += "\(self.type.rawValue)"
				} else if self.type == .delete && self.number.count > 1 {
					self.number.removeLast(1)
				} else if self.type == .confirm {
					self.manager.addRunner(runner: Runner(name: "Number Wang", number: self.number))
					self.presentationMode.wrappedValue.dismiss()
				}
			
				withAnimation(.easeIn(duration: self.duration), {
					self.scale = 0.9
					self.alpha = 0.6
				})
				
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration, execute: {
					withAnimation(.easeIn(duration: self.duration), {
						self.scale = 1.0
						self.alpha = 1.0
					})
				})
			
			})
	
	}

}
