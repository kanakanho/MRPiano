//
//  PlayPianoView.swift
//  MRPiano
//
//  Created by blue ken on 2024/08/23.
//

import SwiftUI
import Combine

struct PlayPianoView: View {
    @State private var musicDatas: MusicDatas
    @State private var playingMusicDataHandlerIndex: Int
    @State private var playingMusicDataHandler: PlayingMusicDataHandler
    @State private var notesDataHandler: NotesDataHandler
    
    @State private var offsetTime: Double
    @State private var middleTime: Double
    @State private var isCorrectFinger: Bool
    @State private var isCorrectMusic: Bool
    
    @State private var playMIDI: PlayMIDI
    
    @State private var playing: Bool = false
    @State private var progressPublisher: AnyCancellable?
    @State private var initialMiddleTime: Double = 0.0
    @State private var playbackStartTime: Date?
    @State private var endTime: Double
    
    init(musicDatas: MusicDatas,playingMusicDataHandlerIndex: Int) {
        self.musicDatas = musicDatas
        self.playingMusicDataHandlerIndex = playingMusicDataHandlerIndex
        self.playingMusicDataHandler = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex]
        self.notesDataHandler = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getNotesDataHandler()
        self.offsetTime = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getOffsetTime()
        self.middleTime = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getMiddleTime()
        self.isCorrectFinger = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getIsCorrectFinger()
        self.isCorrectMusic = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getIsCorrectMusic()
        self.playMIDI = PlayMIDI(midiFileName: musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getMidiFileName())
        self.endTime = musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].getEndTime()
    }
    
    var body: some View {
        VStack{
            List {
                Section(header: Text("Config")
                    .font(.title)
                    .padding(12)
                ){
                    Picker("開始までの猶予", selection: $offsetTime) {
                        ForEach(0..<11) {
                            Text("\($0)s").tag(Double($0))
                        }
                    }
                    .disabled(playing)
                    .onChange(of: offsetTime) {
                        playingMusicDataHandler.setOffsetTime(offsetTime: offsetTime)
                        musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].setOffsetTime(offsetTime: offsetTime)
                    }
                    Toggle("運指を表示", isOn: $isCorrectFinger)
                        .onChange(of: isCorrectFinger) {
                            playingMusicDataHandler.changeIsCorrectFinger()
                            musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].changeIsCorrectFinger()
                        }
                        .disabled(playing)
                    Toggle("正しい音楽を演奏", isOn: $isCorrectMusic)
                        .onChange(of: isCorrectMusic) {
                            playingMusicDataHandler.changeIsCorrectMusic()
                            musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].changeIsCorrectMusic()
                        }
                        .disabled(playing)
                }
            }
            ProgressView(value: max(0.0,middleTime),total: endTime)
                .tint(.white)
                .frame(height: 20)
                .scaleEffect(x: 1, y: 40, anchor: .center)
                .clipShape(Capsule())
                .padding(24)
            HStack{
                VStack{
                    Button(action: {
                        middleTime = 0.0
                        playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                        musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].setMiddleTime(middleTime: middleTime)
                    }) {
                        Image(systemName: "backward")
                            .padding(24)
                    }
                    .disabled(playing)
                    Text("最初に戻る")
                }
                VStack{
                    Button(action: {
                        if playingMusicDataHandler.getMiddleTime() > 1.0 {
                            middleTime -= 1.0
                        } else {
                            middleTime = 0.0
                        }
                        playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                        musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].setMiddleTime(middleTime: middleTime)
                    }) {
                        Image(systemName: "gobackward")
                            .padding(24)
                    }
                    .disabled(playing)
                    Text("少し前に戻る")
                }
                .padding(24)
                VStack{
                    Button(action: {
                        
                        print("offset\t \(playingMusicDataHandler.getOffsetTime())")
                        print("middle\t \(playingMusicDataHandler.getMiddleTime())")
                        print("Finger\t \(playingMusicDataHandler.getIsCorrectFinger())")
                        print("Music\t \(playingMusicDataHandler.getIsCorrectMusic())")
                        
                        if middleTime >= endTime {
                            middleTime = 0.0
                        }
                        if !playing {
                            startPlaying()
                        } else {
                            stopPlaying()
                        }
                    }) {
                        if !playing {
                            Image(systemName: "play.fill")
                                .font(.title)
                                .padding(24)
                        } else {
                            Image(systemName: "pause.fill")
                                .font(.title)
                                .padding(24)
                        }
                        
                    }
                    if !playing{
                        Text("スタート")
                    } else {
                        Text("ストップ")
                    }
                }
                VStack{
                    Button(action: {
                        if middleTime + 1.0 < endTime {
                            middleTime += 1.0
                        } else {
                            middleTime = endTime
                        }
                        playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                        musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].setMiddleTime(middleTime: middleTime)
                    }) {
                        Image(systemName: "goforward")
                            .padding(24)
                    }
                    .disabled(playing)
                    Text("少し先に進む")
                }
                .padding(24)
            }
        }
        .navigationTitle("\(playingMusicDataHandler.getTitle())/\(playingMusicDataHandler.getComposer())")
    }
    
    private func startPlaying() {
        playing = true
        // ノーツ表示・運指表示に関しては、offsetTimeを待たずに処理を開始する
        // 正解音声と進行バーについてはoffsetTimeを待ってから処理を開始する
        Thread.sleep(forTimeInterval: playingMusicDataHandler.getOffsetTime())
        if isCorrectMusic {
            playMIDI.play(middleTime: playingMusicDataHandler.getMiddleTime())
        }
        initialMiddleTime = middleTime
        playbackStartTime = Date()
        startProgressPublisher()
        notesDataHandler.setStartTime(date: Date())
        musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].notesDataHandler.setStartTime(date: Date())
    }
    
    private func stopPlaying() {
        playing = false
        if isCorrectMusic {
            playMIDI.stop()
        }
        stopProgressPublisher()
        notesDataHandler.setEndTime(date: Date())
        musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].notesDataHandler.setEndTime(date: Date())
    }
    
    private func startProgressPublisher() {
        progressPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard let startTime = playbackStartTime else { return }
                let elapsedTime = Date().timeIntervalSince(startTime)
                if middleTime > endTime - 0.1 {
                    middleTime = 0.0
                    playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                    musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].setMiddleTime(middleTime: middleTime)
                    stopPlaying()
                    return
                }
                middleTime = max(0.0, initialMiddleTime + elapsedTime)
                playingMusicDataHandler.setMiddleTime(middleTime: middleTime)
                musicDatas.playingMusicDataHandlers[playingMusicDataHandlerIndex].setMiddleTime(middleTime: middleTime)
            }
    }
    
    private func stopProgressPublisher() {
        progressPublisher?.cancel()
        progressPublisher = nil
    }
}

struct PlayPianoView_Previews: PreviewProvider {
    static var previews: some View {
        PlayPianoView(musicDatas: MusicDatas(),playingMusicDataHandlerIndex: 0)
    }
}
