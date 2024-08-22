//
//  MusicDatas.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import Foundation

struct MusicDatas {
    var playingMusicDataHandlers: [PlayingMusicDataHandler] = []
    
    
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
    }
}
