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
		return geometry.size.width * progress
	}
	
	var progress: CGFloat = 0
	
	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle().foregroundColor(Color(.systemBackground))
				Rectangle()
					.frame(width: self.getProgressBarWidth(geometry: geometry))
					.foregroundColor(.accentColor)
					.animation(.default)
			}
		}
	}
}

struct ProgressBar_Previews: PreviewProvider {
	static var previews: some View {
		ProgressBar(progress: 0.3)
			.frame(width: 320, height: 10, alignment: .center)
			.previewLayout(.sizeThatFits)
	}
}
