//
//  ContentView.swift
//  Blindar
//
//  Created by Suji Lee on 5/30/24.
//

import SwiftUI
import SwiftData

var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    var body: some View {
        SelectSchoolScreen()
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
