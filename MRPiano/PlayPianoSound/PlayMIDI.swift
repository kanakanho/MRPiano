//
//  PlayMIDI.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import AVFoundation

class PlayMIDI {
    private let midiFile: String
    private let soundFontFile: String
    private var midiPlayer: AVMIDIPlayer?
    
    init(midiFileName: String) {
        self.midiFile = midiFileName
        self.soundFontFile = "soundfont"
        
        // Ensure MIDI file URL is valid
        guard let midiFileURL = Bundle.main.url(forResource: midiFile, withExtension: "midi") else {
            print("MIDIファイルが見つかりません")
            fatalError("MIDIファイルが見つかりません")
        }
        
        // Ensure SoundFont file URL is valid
        guard let soundFontFileURL = Bundle.main.url(forResource: "soundfont", withExtension: "sf2") else {
            print("SoundFontファイルが見つかりません")
            fatalError("SoundFontファイルが見つかりません")
        }
        
        do {
            midiPlayer = try AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: soundFontFileURL)
        } catch {
            print("AVMIDIPlayerの初期化エラー: \(error.localizedDescription)")
            return
        }
    }
    
    func play(middleTime: Double) {
        // 途中から再生
        midiPlayer?.currentPosition = middleTime
        
        print("play")
        midiPlayer?.prepareToPlay()
        
        if let midiPlayer = midiPlayer, !midiPlayer.isPlaying {
            midiPlayer.play()
        }
    }
    
    func stop() {
        print("stop")
        midiPlayer?.stop()
    }
}
