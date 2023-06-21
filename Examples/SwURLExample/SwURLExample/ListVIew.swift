//
//  ListVIew.swift
//  SwURLExample
//
//  Created by Callum Trounce on 21/06/2023.
//

import Foundation
import SwiftUI

struct ListView: View {
    let range = Range<Int>(0...10)
    
    var body: some View {
        List(range, id: \.self) { item in
            RowView(index: item)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
