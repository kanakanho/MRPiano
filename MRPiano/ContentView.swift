//
//  ContentView.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var musicDatas = MusicDatas()
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(musicDatas.playingMusicDataHandlers) { playingMusicDataHandler in
                        Section(header: Text("Music List")){
                            NavigationLink(destination: PlayPianoView(playingMusicDataHandler: playingMusicDataHandler)) {
                                Text(playingMusicDataHandler.getTitle())
                            }
                        }
                    }
                    Section(header: Text("Instrument")) {
                        Toggle("Piano", isOn: $showImmersiveSpace)
                            .font(.title)
                            .padding(24)
                            .glassBackgroundEffect()
                    }
                    .navigationTitle("MR Piano")
                }
            }
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

