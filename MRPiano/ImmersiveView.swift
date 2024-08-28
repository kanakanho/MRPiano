//
//  ImmersiveView.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @ObservedObject private var musicDatas: MusicDatas
    init (musicDatas: MusicDatas) {
        self.musicDatas = musicDatas
    }
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)
            }
            print(musicDatas.getSelectedPlayingMusicDataHandler().getTitle())
        }
    }
}

#Preview(immersionStyle: .mixed) {
                ImmersiveView(musicDatas: MusicDatas())
}
