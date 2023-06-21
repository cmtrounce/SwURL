//
//  ContentView.swift
//  SwURLExample
//
//  Created by Callum Trounce on 20/06/2023.
//

import SwiftUI
import SwURL

struct RowView: View {
    let value: String
    
    var body: some View {
        HStack {
            SwURLImage(
                url: URL(string: "https://picsum.photos/200")!,
                transition: .custom(
                    transition: .opacity,
                    animation: .easeIn(duration: 2000)
                )
            ).imageProcessing { image in
                return image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.blue, lineWidth: 4)
                    }
            }
            .frame(width: 50, height: 50)
            Text("Hello, \(value)!")
                .padding()
        }
        .padding()
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(value: "world")
    }
}