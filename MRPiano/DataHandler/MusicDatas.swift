//
//  MusicDatas.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import Foundation

class MusicDatas: ObservableObject {
    var playingMusicDataHandlers: [PlayingMusicDataHandler] = []
    
    @Published private var isChanged: Bool = false
    private var isSelected: Bool = false
    @Published private var selectedIndex: Int
    
    init() {
        selectedIndex = 0
        
        let musicData = MusicData(
            title: "Minuet", // 楽曲の名前
            composer: "Johann Sebastian Bach", // 楽曲の作者
            csvFileName: "notes_minuet_utf8_encoded", // csvのファイル名
            midiFileName: "bach-menuet", // midiのファイル名
            offsetTime: 2.0, // 始まりまでのオフセットの時間
            middleTime: 0.0, // 途中から再開するときの再開する時間
            isCorrectFinger: true, // 運指の表示を行うか
            isCorrectMusic: true // 演奏時に正しい音楽をやるか
        )
        
        playingMusicDataHandlers.append(PlayingMusicDataHandler(musicData: musicData))
        
        let anotherMusicData = MusicData(
            title: "another music", // 楽曲の名前
            composer: "another music composer", // 楽曲の作者
            csvFileName: "notes_minuet_utf8_encoded", // csvのファイル名
            midiFileName: "bach-menuet", // midiのファイル名
            offsetTime: 2.0, // 始まりまでのオフセットの時間
            middleTime: 0.0, // 途中から再開するときの再開する時間
            isCorrectFinger: true, // 運指の表示を行うか
            isCorrectMusic: true // 演奏時に正しい音楽をやるか
        )
        playingMusicDataHandlers.append(PlayingMusicDataHandler(musicData: anotherMusicData))
    }
    
    func getPlayingMusicDataHandlers() -> [PlayingMusicDataHandler] {
        return playingMusicDataHandlers
    }
    
    func toggleIsChanged() {
        isChanged.toggle()
    }
    
    func getIsChanged() -> Bool {
        return isChanged
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex
    }
    
    func setSelectedIndex(index: Int) {
        print("selected index: \(index)")
        isChanged.toggle()
        selectedIndex = index
        isSelected = true
    }
    
    func getSelectedPlayingMusicDataHandler() -> PlayingMusicDataHandler {
        if !isSelected {
            return PlayingMusicDataHandler(musicData: MusicData(title: "", composer: "", csvFileName: "", midiFileName: "", offsetTime: 0.0, middleTime: 0.0, isCorrectFinger: false, isCorrectMusic: false))
        }
        return playingMusicDataHandlers[selectedIndex]
    }
}
