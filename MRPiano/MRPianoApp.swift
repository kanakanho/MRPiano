//
//  MRPianoApp.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import SwiftUI

@main
struct MRPianoApp: App {
    @ObservedObject private var musicDatas = MusicDatas()
    
    var body: some Scene {
        WindowGroup {
            ContentView(musicDatas: musicDatas)
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(musicDatas: musicDatas)
                .id(musicDatas.getIsChanged())
        }
    }
}
