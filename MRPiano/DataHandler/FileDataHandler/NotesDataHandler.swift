//
//  NotesDataHandler.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import Foundation
import TabularData

struct Playing {
    var onsetTime: Double
    var duration: Double
}

struct NoteData {
    var noteNumber: Int
    var noteName: String
    var playing: [Playing]
}

struct NotesDataHandler {
    var MIDIDatas: [NoteData] = []
    
    var isPlaying = false
    var startTime: Date?
    
    init(df: DataFrame) {
        let midiNoteNumberDf = df.sorted(on: "MIDI Note Number")
        var currentMidiNoteNumber = midiNoteNumberDf.rows[0]["MIDI Note Number"] as! Int
        
        for row in df.rows {
            guard let tmpMidiNoteNumber = row["MIDI Note Number"] as? Int else {
                print("MIDI Note Number が Int にキャストできませんでした。")
                return
            }
            if currentMidiNoteNumber != tmpMidiNoteNumber {
                currentMidiNoteNumber = tmpMidiNoteNumber
            }
            
            guard let onsetTime = row["Onset Time"] as? Double else {
                print("Start Time が Double にキャストできませんでした。")
                return
            }
            
            guard let duration = row["Duration"] as? Double else {
                print("Duration が Double にキャストできませんでした。")
                return
            }
            
            guard let noteName = row["Note Name"] as? String else {
                print("Note Name が String にキャストできませんでした。")
                return
            }
            
            let playing = Playing(onsetTime: onsetTime, duration: duration)
            
            if let index = MIDIDatas.firstIndex(where: { $0.noteNumber == currentMidiNoteNumber }) {
                MIDIDatas[index].playing.append(playing)
            } else {
                let playMIDIData = NoteData(noteNumber: currentMidiNoteNumber, noteName: noteName, playing: [playing])
                MIDIDatas.append(playMIDIData)
            }
        }
        
        print(midiNoteNumberDf.description)
        
        printMIDIDatas()
    }
    
    mutating func setStartTime(date:Date) {
        isPlaying = true
        startTime = date
    }
    
    mutating func setEndTime(date:Date) {
        isPlaying = false
        startTime = nil
    }
    
    func dataWithinTimeRange(offsetTime: Double, date: Date) -> [NoteData] {
        // 時間のオフセットを計算する
        let offsetDate = date.addingTimeInterval(offsetTime)
        return nowPlaying(date: offsetDate)
    }
    
    func nowPlaying(date:Date) -> [NoteData] {
        if (!isPlaying) {
            return []
        }
        
        var resultMIDIDatas: [NoteData] = []
        
        // 入力されたDateがstartTime+onsetTimeからDurationの間に存在しているかを確認
        for midiData in MIDIDatas {
            var playing: [Playing] = []
            for play in midiData.playing {
                if let startTime = startTime {
                    if startTime.timeIntervalSince1970 + play.onsetTime <= date.timeIntervalSince1970 &&
                        startTime.timeIntervalSince1970 + play.onsetTime + play.duration >= date.timeIntervalSince1970 {
                        playing.append(play)
                    }
                }
            }
            if playing.count > 0 {
                resultMIDIDatas.append(NoteData(noteNumber: midiData.noteNumber, noteName: midiData.noteName, playing: playing))
            }
        }
        
        return resultMIDIDatas
    }
    
    func getMIDIDatas() -> [NoteData] {
        return MIDIDatas
    }
    
    func printMIDIDatas() {
        for playMIDIData in MIDIDatas {
            print("midiNoteNumber: \(playMIDIData.noteNumber)\t noteName: \(playMIDIData.noteName)")
            for playing in playMIDIData.playing {
                // end time は 小数点 4桁で四捨五入
                print("start poke : \(playing.onsetTime)\t end poke : \(round((playing.onsetTime + playing.duration)*1000)/1000)\t duration : \(playing.duration)")
            }
            print("------------------------------------------------------------")
        }
    }
}
