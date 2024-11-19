//
//  DownerApp.swift
//  Downer
//
//  Created by Timon Rosenbichler on 04.11.24.
//

import SwiftUI

@main
struct DownerApp: App {
    var body: some Scene {

        MenuBarExtra("Downer", systemImage: "square.and.arrow.down.on.square") {
            ContentView()
        }.menuBarExtraStyle(.window)
    }
        
}
