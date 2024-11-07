//
//  ContentView.swift
//  AisleApp
//
//  Created by Abhishek on 05/11/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appViewModel = AppViewModel()
    
    var body: some View {
        FirstScreen()
            .environmentObject(appViewModel)
    }
}

//#Preview {
//    ContentView()
//}
