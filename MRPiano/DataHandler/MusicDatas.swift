//
//  MusicDatas.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import Foundation

class MusicDatas: ObservableObject {
    var playingMusicDataHandlers: [PlayingMusicDataHandler] = []
    
    private var isSelected: Bool = false
    @Published private var selectedIndex: Int
    
    init() {
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
            title: "music2", // 楽曲の名前
            composer: "music2 composer", // 楽曲の作者
            csvFileName: "notes_minuet_utf8_encoded", // csvのファイル名
            midiFileName: "bach-menuet", // midiのファイル名
            offsetTime: 2.0, // 始まりまでのオフセットの時間
            middleTime: 0.0, // 途中から再開するときの再開する時間
            isCorrectFinger: true, // 運指の表示を行うか
            isCorrectMusic: true // 演奏時に正しい音楽をやるか
        )
        playingMusicDataHandlers.append(PlayingMusicDataHandler(musicData: anotherMusicData))
        
        let moreAnotherMusicData = MusicData(
            title: "music3", // 楽曲の名前
            composer: "music3 composer", // 楽曲の作者
            csvFileName: "notes_minuet_utf8_encoded", // csvのファイル名
            midiFileName: "bach-menuet", // midiのファイル名
            offsetTime: 2.0, // 始まりまでのオフセットの時間
            middleTime: 0.0, // 途中から再開するときの再開する時間
            isCorrectFinger: true, // 運指の表示を行うか
            isCorrectMusic: true // 演奏時に正しい音楽をやるか
        )
        playingMusicDataHandlers.append(PlayingMusicDataHandler(musicData: moreAnotherMusicData))
        
        self.selectedIndex = 0
    }
    
    func getPlayingMusicDataHandlers() -> [PlayingMusicDataHandler] {
        return playingMusicDataHandlers
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex
    }
    
    func setSelectedIndex(index: Int) {
        print("selected index: \(index)")
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
