//
//  ProgressBar.swift
//  SwURL
//
//  Created by Callum Trounce on 02/10/2019.
//

import Foundation
import SwiftUI



struct ProgressBar: View {
	func getProgressBarWidth(geometry: GeometryProxy) -> CGFloat {
		let frame = geometry.frame(in: .global)
		return frame.size.width * progressValue
	}
	
	let progressValue: CGFloat
	
	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
					.opacity(0.1)
				Rectangle()
					.frame(minWidth: 0, idealWidth: self.getProgressBarWidth(geometry: geometry),
						   maxWidth: self.getProgressBarWidth(geometry: geometry))
					.opacity(0.5)
					.background(Color.green)
					.animation(.default)
			}
			.frame(height:10)
		}
	}
}
