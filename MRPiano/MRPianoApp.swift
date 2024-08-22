//
//  MRPianoApp.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import SwiftUI

@main
struct MRPianoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
