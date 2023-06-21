//
//  ContentView.swift
//  SwURLExample
//
//  Created by Callum Trounce on 20/06/2023.
//

import SwiftUI
import SwURL

struct RowView: View {
    let index: Int
    
    var url: String {
        let thing = 200 + index
        return "https://picsum.photos/\(thing)"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            SwURLImage(
                url: URL(string: url)!,
                transition: .custom(transition: .opacity, animation: .easeIn)
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
            Text("Hello, Row \(index)!")
                .padding()
        }
        .padding()
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(index: 2)
    }
}
