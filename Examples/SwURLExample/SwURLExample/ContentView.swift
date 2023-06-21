//
//  ContentView.swift
//  SwURLExample
//
//  Created by Callum Trounce on 20/06/2023.
//

import SwiftUI
import SwURL

struct ContentView: View {
    var body: some View {
        VStack {
            RemoteImageView(url: URL(string: "https://placekitten.com/300/300")!).imageProcessing { image in
                return image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.blue, lineWidth: 4)
                    }
            }
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
