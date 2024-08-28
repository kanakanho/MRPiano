//
//  PlayingMusicDataHandler.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import Foundation

struct MusicData: Identifiable {
    var id = UUID()
    var title: String // 楽曲の名前
    var composer: String // 楽曲の作者
    var csvFileName: String // csvのファイル名
    var midiFileName: String // midiのファイル名
    var offsetTime: Double // 始まりまでのオフセットの時間
    var middleTime: Double // 途中から再開するときの再開する時間
    var isCorrectFinger: Bool // 運指の表示を行うか
    var isCorrectMusic: Bool // 演奏時に正しい音楽をやるか
    
    mutating func toggleIsCorrectFinger() {
        isCorrectFinger.toggle()
    }
    
    mutating func toggleIsCorrectMusic() {
        isCorrectMusic.toggle()
    }
}

struct PlayingMusicDataHandler:Identifiable{
    var id = UUID()
    private var musicData: MusicData
    private var csvDataHandler: CsvDataHandler
    var notesDataHandler: NotesDataHandler
    private var noteDatas: [NoteData] = []
    
    private var endTime: Double
    
    init(musicData: MusicData) {
        self.musicData = musicData
        // csvデータのロード
        csvDataHandler = CsvDataHandler(filepath: musicData.csvFileName)
        // ノート用データへの変換
        notesDataHandler = NotesDataHandler(df: csvDataHandler.getDataFrame())
        noteDatas = notesDataHandler.getMIDIDatas()
        
        // 演奏終了時間の取得
        self.endTime = csvDataHandler.lastNoteTime()
    }
    
    func getNotesDataHandler() -> NotesDataHandler {
        return notesDataHandler
    }
    
    func getEndTime() -> Double {
        return endTime
    }
    
    func getTitle() -> String {
        return musicData.title
    }
    
    func getComposer() -> String {
        return musicData.composer
    }
    
    func getCsvFileName() -> String {
        return musicData.csvFileName
    }
    
    func getMidiFileName() -> String {
        return musicData.midiFileName
    }
    
    func getOffsetTime() -> Double {
        return musicData.offsetTime
    }
    
    mutating func setOffsetTime(offsetTime: Double) {
        musicData.offsetTime = offsetTime
    }
    
    func getMiddleTime() -> Double {
        return musicData.middleTime
    }
    
    mutating func setMiddleTime(middleTime: Double) {
        musicData.middleTime = middleTime
    }
    
    func getIsCorrectFinger() -> Bool {
        return musicData.isCorrectFinger
    }
    
    mutating func changeIsCorrectFinger() {
        musicData.toggleIsCorrectFinger()
    }
    
    func getIsCorrectMusic() -> Bool {
        return musicData.isCorrectMusic
    }
    
    mutating func changeIsCorrectMusic() {
        musicData.toggleIsCorrectMusic()
    }
    
    func getNoteData() -> [NoteData] {
        return noteDatas
    }
}
